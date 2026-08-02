# Squashfused

**Squashfused** allows rootless Podman containers to mount SquashFS images at runtime through `squashfuse`. 

## Synopsys

By default, users cannot perform mount operations inside rootless containers because they require a `SYS_ADMIN` capability. This capability can be granted via `--cap-add SYS_ADMIN` (or, even more radically, `--privileged`) in the container launch command, but doing so enables container breakout and/or the host system compromise, defeating the purpose of _rootless_ containers.

However, at times, users inside rootless containers need to perform mount operations on the fly. A prime example is SquashFS images, which are commonly used for data archives. If they forgot to mount some SquashFS archives at container launch (which, in principle, they already can even if the container is rootless), they may want to mount additional archives at container runtime. But granting privilege to allow this at the cost of rootlessness seems too excessive.

Squashfused was developed to _just_ enable the SquashFS mount (in a limited sense) without granting privilege. Basically, Squashfused spawns a host-side "delegate daemon" that forwards a SquashFS mount request from the "stub `squashfuse`" inside rootless containers. The mount result is seen inside the containers via mount propagation, which gives users the "illusion" that they mounted the requested SquashFS image inside rootless containers.

## Usage

### Prerequisite

 - Your host system should have: `squashfuse` and `jq`.
 - You should launch containers via `podman`; unfortunately, other OCI container engines, like Docker, are not supported.
 - Your host system should be `systemd`-based.

### Install

Installation requires `root` privileges one-time. In the repository root directory,

```
$ sudo make install
```

Every source code is a script for now, so no need to build in advance.

### How to Use

Same as the `squashfuse` usage described [here](https://github.com/vasi/squashfuse). 

### Example

The rootless container can be launched _without any special option_. Inside the container,

```
$ ls
test.sqfs  mount_dir
$ ls mount_dir
(empty)

$ # Mount 'test.sqfs' to 'mount_dir'.
$ squashfs test.sqfs mount_dir
$ ls mount_dir
file_in_sqfs

$ # Unmount 'mount_dir'.
$ umount mount_dir    # or 'fusermount -u mount_dir'.
$ ls mount_dir
(empty)
```

### Demo

After installation, go to the directory `demo` and run `make do_demo`.

## Mechanism

1. (systemd unit) Create a "server" that spawns a "delegate daemon" later when requested.
1. (Podman `precreate` hook) Request the "server" to create a per-container "delegate daemon."
2. (Server) Create a "delegate daemon" on the host mount namespace, together with a "bridge directory" and a "bridge FIFO file". 
4. (Podman `precreate` hook) Mount the "bridge directory" and the "bridge FIFO file" into the dedicated location of the container.
5. (Podman `precreate` hook) Mount a "stub `squashfuse`" into the container's `/usr/bin/squashfuse`. The stub will forward the `squashfuse` request to the "delegate daemon" via the "bridge FIFO."
6. (Container) Call the "stub `squashfuse`" via `/usr/bin/squashfuse`.
7. (Stub `squashfuse`) Forward all `squashfuse` arguments to the "delegate daemon" via the "bridge FIFO."
6. (Delegate daemon) Mount the requested SquashFS.
8. (Stub `squashfuse`) Find the "mounted destination" and symlink it to the real destination in the `squashfuse` arguments.
9. (Container) Access the mounted SquashFS file.
10. (Podman `poststop` hook) Clean up the "bridge directory" and the "bridge FIFO."
11. (Podman `poststop` hook) Kill the "delegate daemon."

## Discussion

### Invalid Solutions

One hypothetical solution is to bind-mount the host's `squashfuse` inside the container because, supposedly, users can mount SquashFS images without privilege. However, this doesn't work because `squashfuse` uses a SUID binary (`fusermount`) to delegate mount operations, and SUID binaries break if their callers _cannot_ have `SYS_ADMIN`. The users inside unprivileged rootless containers _cannot_ have `SYS_ADMIN` no matter what, so ultimately, the bind-mounted `squashfuse` doesn't function correctly. Formally speaking, `SYS_ADMIN` is _not_ in the bounding capability set of the unprivileged rootless containers.

### Security Concern

### Performance Concern

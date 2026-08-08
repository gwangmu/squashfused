# Squashfused

**Squashfused** is a tool that allows unprivileged rootless Podman containers to mount SquashFS images at runtime through `squashfuse`. _No_ additional command-line option is required after installation.

<img width="787" height="560" alt="demo" src="https://github.com/user-attachments/assets/e419217c-8776-4a26-86a0-bcf6a9c009ae" />

"Squashfused" almost sounds like a new Linux kernel vulnerability, but calm down. It's a tool, not a vulnerability (nor using one, either). It was supposed to be short for "Squashfuse-delegate." You can pronounce it however you prefer: "Squashfused" or "Squashfuse-Dee."

## Synopsis

By default, users cannot perform mount operations inside rootless containers because they require a `SYS_ADMIN` capability. This capability can be granted via `--cap-add SYS_ADMIN` (or, even more radically, `--privileged`) in the container launch command, but doing so enables container breakout and/or the host system compromise, defeating the purpose of _rootless_ containers.

However, at times, users inside rootless containers need to perform mount operations on the fly. A prime example is SquashFS images, which are commonly used for data archives. If they forgot to mount some SquashFS archives at container launch (which, in principle, they already can even if the container is rootless), they may want to mount additional archives at container runtime. But granting privilege to allow this at the cost of rootlessness seems too excessive.

Squashfused was developed to _just_ enable the SquashFS mount (in a limited sense) without granting privilege. Basically, Squashfused spawns a host-side "delegate daemon" that forwards a SquashFS mount request from the "stub `squashfuse`" inside rootless containers. The mount result is seen inside the containers via mount propagation, which gives users the "illusion" that they mounted the requested SquashFS image inside rootless containers.

## Usage

### Prerequisite

 - Your host system should have: `squashfuse` and `jq`.
 - You should launch containers via `podman`; unfortunately, other OCI container engines, like Docker, are not supported.
 - Your host system should be `systemd`-based.
 - Your host system and container image should have `bash`. (requirement droppable in the future)

### Install

 1. Clone this repository and run `make install` as `root`.

```
$ sudo make install
```

 2. Reboot the system to start the Squashfused server (systemd unit), or manually start it by:
   
```
$ systemctl --user daemon-reload
$ systemctl --user restart squashfused-server.service
```

Once installed, Squashfused is available to _all_ accounts, including the LDAP-linked ones.

### How to Use

Same as the `squashfuse` usage described [here](https://github.com/vasi/squashfuse). For example, inside the container,

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

### Uninstall

If you didn't like Squashfused, you could uninstall it entirely with this command. No system dependency is touched.

```
$ sudo make clean
```

**Note: The container launch doesn't require any special option.** 

A demo is also available; in the `demo` directory, run `make do_demo` after installation.

## See Also

 - [Options](./docs/options.md)
 - [Mechanism](./docs/mechanism.md)
 - [Discussion](./docs/discussion.md)

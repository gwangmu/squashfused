# Troubleshooting

## `squashfuse` hangs inside the container.

One possible reason is that the `squashfuse` stub inside the container is using different options than the daemon or the server on the host. This can happen when the systemd service wasn't started, or Squashfused was installed again since the last systemd start with updated options. If you suspect this, simply restart the Squashfused server and see if the hanging goes away.

```
$ systemctl --user daemon-reload
$ systemctl --user restart squashfused-server
```

## `squashfuse` complains that the SquashFS image even if `SRCMODE` is `rootfs`.

A typical error message says `squashfuse: Can't open squashfs image: Permission denied`. There are a couple of issues to check.

### Check if `/proc/<pid>/root` is accessible.

To use `SRCMODE=rootfs`, the `root` directory of the container process (i.e., `/proc/<pid>/root`) should be accessible from the host. It's accessible if the container rootfs was mounted with `overlayfs` (the kernel driver), but not if with `fuse-overlayfs`. To check this, simply type `mount` inside the container and see how the rootfs was mounted.

```
$ mount | grep 'on / '
overlayfs on / type overlay ...
```

  If the type is `fuse-overlayfs`, `/proc/<pid>/root` may not be accessible. Fortunately, Podman has supported `overlayfs` for rootless containers for a while. See [this thread](https://github.com/podman-container-tools/podman/discussions/17097) to see how to enable `overlayfs` for rootless containers.

### Check if the image is accessible from the host.

As a side effect of the UID/GID mapping, the host user may not have enough permissions to see the SquashFS image inside the container, even though the user inside the container can see it. This usually happens when the user is the container `root`, but the SquashFS image is in a directory owned by a container user account. As an example, consider launching a rootless Ubuntu container. By default, the user is `root` inside, but the home directories belong to each corresponding container user account.

```
$ podman run --rm -it ubuntu bash
root@166662492cbd:/# ls /home -l
drwxr-x--- 1 ubuntu ubuntu 4096 Aug 11 11:11 ubuntu
```

  The container user can access this directory because they're `root` inside, but they're not `root` outside the container, so they cannot access a directory that belongs to another user (unless proper permission bits are set).

```
/proc/<pid>/root$ ls home -l
drwxr-x--- 1 100999 100999 4096 Aug 11 13:11 ubuntu
/proc/<pid>/root$ ls home/ubuntu
ls: cannot open directory 'home/ubuntu': Permission denied
```

  There are a few fixes that you can try:
  
  * Launch the container with `--userns=keep-id`, making the user a normal container user, not `root`.
  * Set proper permission bits to all ancestor directories of the image, at least read access to the world.
  * Copy the image over to one of the `root`-owned directory hierarchies (e.g., rootfs).

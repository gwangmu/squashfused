# Options

Squashfused options can be set during installation via Makefile arguments.

```
$ sudo make install [OPTIONS...]
```

## Available Options

 - `SRCMODE`: Source SquashFS image reference mode.
   - `copy`: Copy the requested image to the bridge directory. This makes the bridge directory read-write. (default)
   - `map`: Search bind-mounted directories only.
   - `rootfs`: Search the container rootfs directly. `/proc/<pid>/root` should be accessible for this.
 - `DSTMODE`: Mount destination handling mode.
   - `link`: Create a symlink to the mountpoint in the bridge directory.
   - `bind`: Create a bind mount on the requested mount destination. `/proc/<pid>/root` should be accessible for this.
   - `const`: Use a constant mountpoint specified by `CONSTDST`.
   - `null`: Do not create anything. Just report the mountpoint path.
 - `CONSTDST=<path>`: constant mountpoint path. Only considered if `DSTMODE=const`.

## Caveat

 - `/proc/<pid>/root` is not accessible if the container uses `fuse-overlayfs`. [Related discussion thread](https://github.com/podman-container-tools/podman/discussions/17097).

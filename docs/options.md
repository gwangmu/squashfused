# Options

Squashfused options can be set during installation via Makefile arguments.

```
$ sudo make install [OPTIONS...]
```

## Available Options

 - `NOCOPY=1`: do not copy the target SquashFS image to the bridge directory when mounting. When set, the bridge directory is made read-only inside the container, and only SquashFS images visible to the host can be mounted (e.g., via shared volumes).
 - `NOLINK=1`: do not link the mountpoint to the destination in the container. When set, the stub `squashfuse` doesn't check if the destination was provided in the argument.
 - `CONSTDST=<path>`: always use a constant mount destination `<path>` inside a container. When set, only one SquashFS image can be mounted at a time.

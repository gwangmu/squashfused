# Options

Squashfused options can be set during installation via the `OPTS` Makefile argument.

```
$ sudo make install OPTS=<squashfused_options>
```

`<squashfused_options>` is a comma-separated list of options.

## Available Options

 - `nocopy`: do not copy the target SquashFS image to the bridge directory when mounting. When set, the bridge directory is made read-only inside the container, and only SquashFS images visible to the host can be mounted (e.g., via shared volumes).
 - `nolink`: do not link the mountpoint to the destination in the container. When set, the stub `squashfuse` doesn't check if the destination was provided in the argument.
 - `constdst=<path>`: always use a constant mount destination `<path>` inside a container. When set, only one SquashFS image can be mounted at a time.

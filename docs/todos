# TODO

## Technical

 - Move the "cleanup" functionality of the `clean` hook to the server. This is for design symmetry; the "construction" is done by the server, so it makes sense that the "destruction" is also performed by it.
 - Forward any unhandled invocations to `umount` and `fusermount` to the host-side counterparts, just like what the `squashfuse` stub is doing now.
 - Make the `squashfuse` stub return the return code of the host-side `squashfuse` when the invocations were forwarded.

## Exploratory

 - Investigate if the usage of [`bindfs`](https://bindfs.org/) and directly altering the container rootfs can replace symlinks.

# TODO

## Technical

 - Move the "cleanup" functionality of the `clean` hook to the server. This is for design symmetry; the "construction" is done by the server, so it makes sense that the "destruction" is also performed by it.
 - Make the `squashfuse` stub return the return code of the host-side `squashfuse` when the invocations were forwarded.
 - Make the Podman hooks _not_ wait for the server if it's not alive.

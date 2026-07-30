# Brief idea

1. (Podman `precreate` hook) Create a per-container "bridge directory" and a "bridge FIFO file".
2. (Podman `precreate` hook) Run a "delegate daemon" on the host namespace. The daemon waits for the "bridge FIFO file" and delegates to mount a SquashFS file using `squashfuse` on the "bridge directory."
3. (Podman `precreate` hook) Mount the "bridge directory" and the "bridge FIFO file" into the dedicated location of the container.
4. (Podman `precreate` hook) Mount a "stub `squashfuse`" into the container's `/usr/bin/squashfuse`. The stub will forward the `squashfuse` request to the "delegate daemon" via the "bridge FIFO."
5. (Container) Call the "stub `squashfuse`" via `/usr/bin/squashfuse`.
6. (Stub `squashfuse`) Forward all `squashfuse` arguments to the "delegate daemon" via the "bridge FIFO."
6. (Delegate daemon) Mount the requested SquashFS.
7. (Delegate daemon) Return the "mounted destination" in the "bridge directory" to the "bridge FIFO."
8. (Stub `squashfuse`) Receive the "mounted destination" and symlink it to the real destination in the forwarded arguments.
9. (Container) Access the mounted SquashFS file.podman mounts.conf mount option
10. (Podman `poststop` hook) Clean up the "bridge directory" and the "bridge FIFO."
11. (Podman `poststop` hook) Kill the "delegate daemon."

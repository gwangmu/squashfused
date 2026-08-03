# Mechanism

There are three classes of the main components: a systemd unit, the Podman hooks, and the stub executables.

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

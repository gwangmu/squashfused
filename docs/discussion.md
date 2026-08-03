# Discussion

## Invalid Solutions

One hypothetical solution is to bind-mount the host's `squashfuse` inside the container because, supposedly, users can mount SquashFS images without privilege. However, this doesn't work because `squashfuse` uses a SUID binary (`fusermount`) to delegate mount operations, and SUID binaries break if their callers _cannot_ have `SYS_ADMIN`. The users inside unprivileged rootless containers _cannot_ have `SYS_ADMIN` no matter what, so ultimately, the bind-mounted `squashfuse` doesn't function correctly. Formally speaking, `SYS_ADMIN` is _not_ in the bounding capability set of the unprivileged rootless containers.

## Security Concern

WIP: two main concerns: i) the "backdoor-ness" of the bridge directory, and ii) the possibility of host compromise via the vulnerabilities in `fusermount`, `squashfuse`, and `squashfused` itself. For i): mitigable with a combination of `--no-copy` and `--no-multiple-mounts`, and depending on the system, this backdoor is no greater than "frontdoors" (e.g., shared storage). For ii): the risk is still a tiny subset of `--privileged` or `--cap-add SYS_ADMIN`. `squashfused` vulnerabilities are unlikely because it's so small (and a script).

## Performance Concern

WIP: one concern: copy overhead. Background: a SquashFS image should be copied to the "bridge directory" to make it visible to the host. This copying operation can take significant time depending on the image size. Mitigation: use `--no-copy` so that the image is simply mapped to the corresponding image on the host system (e.g., via shared storage, if any) instead of copying it.

## Merging to Podman

WIP: shouldn't be a problem only if: i) the "delegate daemon" can be spawned on the host mount namespace - this will obviate the systemd unit, ii) there is any way to make the symlink mount destination as seamless as normal bind mounts (or if it's okay to have symlinks), and iii) it's only allowed to be enabled if the container is rootless and unprivileged.

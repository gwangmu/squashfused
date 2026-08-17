# Discussion

## Invalid Solutions

One hypothetical solution is to bind-mount the host's `squashfuse` inside the container because users can supposedly mount SquashFS images without privileges. However, this doesn't work because `squashfuse` uses a SUID binary (`fusermount`) to delegate mount operations, and SUID binaries break if their callers _cannot_ have `SYS_ADMIN`. Users inside unprivileged rootless containers _cannot_ have `SYS_ADMIN` no matter what, so the bind-mounted `squashfuse` ultimately doesn't function correctly. Formally speaking, `SYS_ADMIN` is _not_ in the bounding capability set of the unprivileged rootless containers.

## Security

When we hear a "bridge directory," the first thing that comes to mind can be a "backdoor" in disguise. Indeed, any sort of "bridge" between the container and the host can serve as a backdoor if a host-side malicious actor wants to communicate covertly with someone inside the container. However, we should consider a couple of things before we call it a security issue. 

First, some container configurations already open _frontdoors_, so the added security implication is practically nonexistent in those settings. As a specific example, containers oftentimes are connected to the internet (with loose or no restrictions - they may as well be using the host network namespace) or bind-mount the host's shared storage. Any of these are legitimate host-container communication channels, not even covert. So it's unclear (at least for me) if opening one more door to this environment is any more insecure. 

Second, the bridge directory is a two-way street _only if_ the in-container SquashFS images should be copied there to make them visible to the host. However, if target SquashFS images are already visible to the host (e.g., via bind-mount shared storage), we don't need this copying operation; therefore, the bridge directory doesn't have to be two-way. The bridge directory can simply be read-only inside the container (which can be enabled with `SRCMODE` other than `copy`), making it _one-way_ (from the host to the container). Note: the bridge FIFO will still remain two-way regardless, but all arguments forwarded through the FIFO are eventually redirected to `fusermount`, so this again boils down to the vulnerability risk of `fusermount`.

One more noteworthy detail is that some exploitable components are on the host namespace, `fusermount` as a prime example. In particular, `fusermount` is a SUID binary running on the host system, so potentially a vulnerability in `fusermount` can be exploited to compromise the host _inside an unprivileged rootless container_. However, this is pretty much _the only_ privileged executable that Squashfused should depend on. Other executables, such as the Squashfused daemon or `squashfuse` itself, are unprivileged (i.e., not SUID binaries), so vulnerabilities there don't immediately imply a host exploit. So I'd argue that a new security risk intr

## Merging to Podman

WIP: shouldn't be a problem only if: i) the "delegate daemon" can be spawned on the host mount namespace - this will obviate the systemd unit, ii) there is any way to make the symlink mount destination as seamless as normal bind mounts (or if it's okay to have symlinks), and iii) it's only allowed to be enabled if the container is rootless and unprivileged.

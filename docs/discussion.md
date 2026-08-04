# Discussion

## Invalid Solutions

One hypothetical solution is to bind-mount the host's `squashfuse` inside the container because, supposedly, users can mount SquashFS images without privileges. However, this doesn't work because `squashfuse` uses a SUID binary (`fusermount`) to delegate mount operations, and SUID binaries break if their callers _cannot_ have `SYS_ADMIN`. The users inside unprivileged rootless containers _cannot_ have `SYS_ADMIN` no matter what, so ultimately, the bind-mounted `squashfuse` doesn't function correctly. Formally speaking, `SYS_ADMIN` is _not_ in the bounding capability set of the unprivileged rootless containers.

## Security Concern

When we hear a "bridge directory," the first thing that comes to mind can be a "backdoor" in disguise. Indeed, any sort of "bridge" between the container and the host has the potential to serve as a backdoor, given there is a host-side malicious actor who desires to communicate with someone inside the container covertly. However, we should consider a couple of things before we call it a security issue. 

First, some container configurations already open _frontdoors_, so the added security implication is practically nonexistent in those settings. As a specific example, containers oftentimes are connected to the internet (with loose or no restrictions - they may as well be using the host network namespace) or bind-mount the host's shared storage. Any of these are legitimate host-container communication channels, not even covert. So it's unclear (at least for me) if opening one more door to this environment is any more insecure. 

Second, the bridge directory is a two-way street _only if_ the in-container SquashFS images should be copied there to make them visible to the host. However, if target SquashFS images are known to be already visible to the host (e.g., via bind-mount shared storage), we don't need this copying operation, and therefore, the bridge directory doesn't have to be two-way. The bridge directory can simply be read-only inside the container, and this will make it _one-way_ (from the host to the container). Note: this is still work-in-progress as of the writing. Note: the bridge FIFO will still remain two-way regardless, but all arguments forwarded through the FIFO are eventually redirected to `fusermount`, so this again boils down to the vulnerability risk of `fusermount`.

One more noteworthy detail is that some exploitable components are on the host namespace, `fusermount` as a prime example. In particular, `fusermount` is a SUID binary running on the host system, so potentially a vulnerability in `fusermount` can be exploited to compromise the host _inside an unprivileged rootless container_. However, this is pretty much _the only_ privileged executable that Squashfused should depend on. Other executables such as the Squashfused daemon or `squashfuse` itself are unprivileged (i.e., not SUID binaries), so the vulnerabilities there don't immediately imply the host exploit. So I'd argue that a new security risk introduced by Squashfused is the bare minimum compared to the privileged counterparts (`--privileged` or `--cap-add SYS_ADMIN`), which depends on the security of multiple SUIDs.

## Performance Concern

WIP: one concern: copy overhead. Background: a SquashFS image should be copied to the "bridge directory" to make it visible to the host. This copying operation can take significant time depending on the image size. Mitigation: use `--no-copy` so that the image is simply mapped to the corresponding image on the host system (e.g., via shared storage, if any) instead of copying it.

## Merging to Podman

WIP: shouldn't be a problem only if: i) the "delegate daemon" can be spawned on the host mount namespace - this will obviate the systemd unit, ii) there is any way to make the symlink mount destination as seamless as normal bind mounts (or if it's okay to have symlinks), and iii) it's only allowed to be enabled if the container is rootless and unprivileged.

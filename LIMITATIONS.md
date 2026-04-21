# Limitations

## Package Availability

### LINBIT-Supported Platforms

Based on LINBIT's current support page as of April 21, 2026, certified binaries are listed for:

* Red Hat Enterprise Linux 7, 8, and 9
* Oracle Linux 7, 8, and 9
* Debian GNU/Linux 11 and 12
* Ubuntu Server Edition 20.04 LTS and 22.04 LTS
* AlmaLinux 9
* CentOS 7 and 8
* Amazon Linux
* SUSE Linux Enterprise Server 12 and 15

The older DRBD 9.0 user guide still mentions Debian 9 to 11 and Ubuntu 18.04 to 22.04. The support page is newer, so this cookbook should treat the support page as the current source of truth.

### APT (Debian/Ubuntu)

The public `packages.linbit.com` repository currently exposes `drbd-9` package trees for:

* Debian 11 (`bullseye`)
* Debian 12 (`bookworm`)
* Debian 13 (`trixie`)
* Ubuntu 24.04 (`noble`)

Observed repository architectures in the public package indexes:

* `amd64`
* `arm64`
* `ppc64el`
* `s390x`

The public APT pool also shows versioned `drbd-module-*` packages per kernel build, which means package installation depends on matching the running kernel version.

### DNF/YUM (RHEL Family)

The public LINBIT RPM repositories currently expose `drbd-9` content for RHEL-family releases, including `rhel9` and `rhel9.5`, with at least:

* `x86_64`
* `aarch64`

The RPM repositories publish both `drbd-utils` and kernel-module packages such as `kmod-drbd`, so package installation is also kernel-version-sensitive on RPM platforms.

### Cookbook Reality

This cookbook does not currently manage LINBIT repositories directly. It relies on:

* distribution packages on Debian/Ubuntu/Fedora/openSUSE
* `yum-elrepo` for the historic RHEL-family path

That means cookbook support and LINBIT-certified repository support are not the same thing.

## Architecture Limitations

* LINBIT's public APT repositories are clearly multi-arch today; this is broader than the cookbook's current package helper logic.
* RHEL-family public repositories clearly expose `aarch64` artifacts in addition to `x86_64`.
* The cookbook's existing package selection logic is platform-family-based and does not yet select packages by architecture.

## Source/Compiled Installation

DRBD can be built from source, but this cookbook does not implement that path.

### Build Dependencies

| Platform Family | Requirements |
| --- | --- |
| Debian/Ubuntu | kernel headers, `dpkg-dev`, and `fakeroot` for Debian package builds |
| RHEL family | kernel headers and RPM build tooling for userspace and module packaging |

Additional constraints:

* Kernel module packages must match the target kernel.
* The DRBD user guide documents separate source-build flows for userspace RPM packages and Debian packages.
* `drbd-dkms` is available for Debian-family builds, but that is still a source-compilation path at install time.

## Known Issues

* The cookbook's legacy RHEL path is tied to ELRepo, not LINBIT's own repositories.
* The legacy pairing flow depends on implicit node state (`configured`) and documented multi-run convergence.
* A single-node Kitchen suite can verify installation and resource compilation, but it cannot fully prove two-node DRBD replication semantics.

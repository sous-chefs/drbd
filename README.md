# drbd Cookbook

[![Cookbook Version](https://img.shields.io/cookbook/v/drbd.svg)](https://supermarket.chef.io/cookbooks/drbd)
[![CI State](https://github.com/sous-chefs/drbd/workflows/ci/badge.svg)](https://github.com/sous-chefs/drbd/actions?query=workflow%3Aci)
[![OpenCollective](https://opencollective.com/sous-chefs/backers/badge.svg)](#backers)
[![OpenCollective](https://opencollective.com/sous-chefs/sponsors/badge.svg)](#sponsors)
[![License](https://img.shields.io/badge/License-Apache%202.0-green.svg)](https://opensource.org/licenses/Apache-2.0)

Installs and configures the Distributed Replicated Block Device (DRBD) service for mirroring block devices between a pair of hosts. Right now it simply works in pairs, multiple hosts could be supported with a few small changes.

This cookbook now exposes a resource-first API for the core DRBD workflow:

* `drbd_install` installs the DRBD packages
* `drbd_pair` renders pair configuration and exposes initialization, promotion, formatting, and mounting as explicit actions

This major release removes the legacy `drbd::default` and `drbd::pair` recipes and the `node['drbd']` attribute API. See [migration.md](migration.md) before upgrading from a recipe-based release.

The `drbd` cookbook does not partition drives. It will format partitions given a filesystem type, but it does not explicitly depend on the `xfs` cookbook if you want that type of filesystem. Install any filesystem tooling you need in your wrapper cookbook, then set the `fs_type` property on `drbd_pair`.

## Maintainers

This cookbook is maintained by the Sous Chefs. The Sous Chefs are a community of Chef cookbook maintainers working together to maintain important cookbooks. If you’d like to know more please visit [sous-chefs.org](https://sous-chefs.org/) or come chat with us on the Chef Community Slack in [#sous-chefs](https://chefcommunity.slack.com/messages/C2V7B88SF).

## Requirements

### Platforms

* Debian
* Fedora
* openSUSE Leap
* Oracle Linux
* Red Hat Enterprise Linux
* AlmaLinux
* Ubuntu

### Chef

* Chef 15.3+

### Cookbooks

* yum-elrepo

Current x86_64 Kitchen verification in this migration branch covers AlmaLinux 9, Debian 12, and Ubuntu 24.04. On EL9 x86_64, the cookbook installs `drbd9x-utils` and `kmod-drbd9x` from ELRepo. RHEL support remains declared through the same ELRepo path, and ChefSpec covers that package-selection flow explicitly. EL9 `aarch64` and Amazon Linux 2023 remain outside the verified matrix for this release line.

## Resources

Resource documentation:

* [drbd_install](documentation/drbd_drbd_install.md)
* [drbd_pair](documentation/drbd_drbd_pair.md)

### `drbd_install`

Installs DRBD packages. On the RHEL path it bootstraps `yum-elrepo` by default. EL9 x86_64 installs `drbd9x-utils` and `kmod-drbd9x`; older EL releases continue using `drbd-utils` and `kmod-drbd`.

```ruby
drbd_install 'default'
```

### `drbd_pair`

Renders pair configuration and keeps the stateful replication steps explicit.

```ruby
drbd_pair 'pair' do
  local_ip '192.0.2.10'
  remote_host 'node-b'
  remote_ip '192.0.2.11'
  disk '/dev/sdb1'
  mount_point '/srv/drbd'
  primary true
  action %i(configure initialize promote format mount)
end
```

This replaces the old `configured` node flag with runtime checks against DRBD and the block device. Initial convergence may still be multi-step on real hardware, but the resource no longer relies on persisted node state to reach the mount step.

## Contributors

This project exists thanks to all the people who [contribute.](https://opencollective.com/sous-chefs/contributors.svg?width=890&button=false)

### Backers

Thank you to all our backers!

![https://opencollective.com/sous-chefs#backers](https://opencollective.com/sous-chefs/backers.svg?width=600&avatarHeight=40)

### Sponsors

Support this project by becoming a sponsor. Your logo will show up here with a link to your website.

![https://opencollective.com/sous-chefs/sponsor/0/website](https://opencollective.com/sous-chefs/sponsor/0/avatar.svg?avatarHeight=100)
![https://opencollective.com/sous-chefs/sponsor/1/website](https://opencollective.com/sous-chefs/sponsor/1/avatar.svg?avatarHeight=100)
![https://opencollective.com/sous-chefs/sponsor/2/website](https://opencollective.com/sous-chefs/sponsor/2/avatar.svg?avatarHeight=100)
![https://opencollective.com/sous-chefs/sponsor/3/website](https://opencollective.com/sous-chefs/sponsor/3/avatar.svg?avatarHeight=100)
![https://opencollective.com/sous-chefs/sponsor/4/website](https://opencollective.com/sous-chefs/sponsor/4/avatar.svg?avatarHeight=100)
![https://opencollective.com/sous-chefs/sponsor/5/website](https://opencollective.com/sous-chefs/sponsor/5/avatar.svg?avatarHeight=100)
![https://opencollective.com/sous-chefs/sponsor/6/website](https://opencollective.com/sous-chefs/sponsor/6/avatar.svg?avatarHeight=100)
![https://opencollective.com/sous-chefs/sponsor/7/website](https://opencollective.com/sous-chefs/sponsor/7/avatar.svg?avatarHeight=100)
![https://opencollective.com/sous-chefs/sponsor/8/website](https://opencollective.com/sous-chefs/sponsor/8/avatar.svg?avatarHeight=100)
![https://opencollective.com/sous-chefs/sponsor/9/website](https://opencollective.com/sous-chefs/sponsor/9/avatar.svg?avatarHeight=100)

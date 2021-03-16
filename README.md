# drbd Cookbook

[![Cookbook Version](https://img.shields.io/cookbook/v/drbd.svg)](https://supermarket.chef.io/cookbooks/drbd)
[![CI State](https://github.com/sous-chefs/drbd/workflows/ci/badge.svg)](https://github.com/sous-chefs/drbd/actions?query=workflow%3Aci)
[![OpenCollective](https://opencollective.com/sous-chefs/backers/badge.svg)](#backers)
[![OpenCollective](https://opencollective.com/sous-chefs/sponsors/badge.svg)](#sponsors)
[![License](https://img.shields.io/badge/License-Apache%202.0-green.svg)](https://opensource.org/licenses/Apache-2.0)

Installs and configures the Distributed Replicated Block Device (DRBD) service for mirroring block devices between a pair of hosts. Right now it simply works in pairs, multiple hosts could be supported with a few small changes.

The `drbd` cookbook does not partition drives. It will format partitions given a filesystem type, but it does not explicitly depend on the `xfs` cookbook if you want that type of filesystem, but you can put it in your run list and set the node['drbd']['fs_type'] to 'xfs' or 'ext4' or whatever.

## Maintainers

This cookbook is maintained by the Sous Chefs. The Sous Chefs are a community of Chef cookbook maintainers working together to maintain important cookbooks. If you’d like to know more please visit [sous-chefs.org](https://sous-chefs.org/) or come chat with us on the Chef Community Slack in [#sous-chefs](https://chefcommunity.slack.com/messages/C2V7B88SF).

## Requirements

### Platforms

- Ubuntu
- CentOS

### Chef

- Chef 12.15+

### Cookbooks

- yum-elrepo

## Recipes

### default

Installs drbd but does no configuration. If another version of drbd is desired, set the `node['drbd']['packages']` attribute.

For example, to install drdb 8.4 on CentOS you might set `node.override['drbd']['packages'] = %w(drbd84-utils kmod-drbd84)`.

## pair

Given a filesystem and a partner host, configures block replication between the hosts. The master will claim the primary, format the filesystem and mount the partition. The slave will simply mirror without mounting. **It currently takes 2 chef-client runs to ensure the pair is synced properly.**

## Attributes

The required attributes are

- `node['drbd']['remote_host']` - Remote host to pair with.
- `node['drbd']['remote_ip']` - Remote host to pair with.
- `node['drbd']['local_ip']` - Remote host to pair with.
- `node['drbd']['disk']` - Disk partition to mirror.
- `node['drbd']['mount']` - Mount point to mirror.
- `node['drbd']['fs_type']` - Disk format for the mirrored disk, defaults to `ext3`.
- `node['drbd']['master']` - Whether this node is master between the pair, defaults to `false`.

The optional attributes are

- `node['drbd']['packages']` - What packages are needed to install drbd, defaults to `drbd_packages` helper.

## Roles

There are a pair of example roles `drbd-pair.rb` and `drbd-pair-master.rb` with the cookbook source.

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

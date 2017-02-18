# drbd Cookbook

[![Build Status](https://travis-ci.org/chef-cookbooks/drbd.svg?branch=master)](https://travis-ci.org/chef-cookbooks/drbd) [![Cookbook Version](https://img.shields.io/cookbook/v/drbd.svg)](https://supermarket.chef.io/cookbooks/drbd)

Installs and configures the Distributed Replicated Block Device (DRBD) service for mirroring block devices between a pair of hosts. Right now it simply works in pairs, multiple hosts could be supported with a few small changes.

The `drbd` cookbook does not partition drives. It will format partitions given a filesystem type, but it does not explicitly depend on the `xfs` cookbook if you want that type of filesystem, but you can put it in your run list and set the node['drbd']['fs_type'] to 'xfs' or 'ext4' or whatever.

## Requirements

### Platforms

- Ubuntu
- CentOS

### Chef

- Chef 12.1+

### Cookbooks

- yum-elrepo

## Recipes

### default

Installs drbd but does no configuration.

## pair

Given a filesystem and a partner host, configures block replication between the hosts. The master will claim the primary, format the filesystem and mount the partition. The slave will simply mirror without mounting. **It currently takes 2 chef-client runs to ensure the pair is synced properly.**

## Attributes

The required attributes are

- `node['drbd]['remote_host']` - Remote host to pair with.
- `node['drbd]['remote_ip']` - Remote host to pair with.
- `node['drbd]['local_ip']` - Remote host to pair with.
- `node['drbd]['disk']` - Disk partition to mirror.
- `node['drbd]['mount']` - Mount point to mirror.
- `node['drbd]['fs_type']` - Disk format for the mirrored disk, defaults to `ext3`.
- `node['drbd]['master']` - Whether this node is master between the pair, defaults to `false`.

## Roles

There are a pair of example roles `drbd-pair.rb` and `drbd-pair-master.rb` with the cookbook source.

## License & Authors

Author:: Matt Ray ([matt@chef.io](mailto:matt@chef.io))

```text
Copyright:: 2011-2016, Chef Software, Inc.

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
```

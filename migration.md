# Migration Guide

This cookbook has completed a full migration from recipes and node attributes to custom resources.

## What changed

* The public interface is now:
  * `drbd_install`
  * `drbd_pair`
* The legacy `drbd::default` and `drbd::pair` recipes were removed.
* The legacy `node['drbd']` attributes were removed.
* Wrapper cookbooks must declare the resources directly.

## How to migrate

Legacy pattern:

```ruby
node.default['drbd']['local_ip'] = '192.0.2.10'
node.default['drbd']['remote_host'] = 'node-b'
node.default['drbd']['remote_ip'] = '192.0.2.11'
node.default['drbd']['disk'] = '/dev/sdb1'
node.default['drbd']['mount'] = '/srv/drbd'
node.default['drbd']['master'] = true

include_recipe 'drbd::default'
include_recipe 'drbd::pair'
```

Resource pattern:

```ruby
drbd_install 'default'

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

## Attribute migration

Move old node attributes onto `drbd_pair` properties:

* `node['drbd']['local_ip']` -> `local_ip`
* `node['drbd']['remote_host']` -> `remote_host`
* `node['drbd']['remote_ip']` -> `remote_ip`
* `node['drbd']['disk']` -> `disk`
* `node['drbd']['mount']` -> `mount_point`
* `node['drbd']['fs_type']` -> `fs_type`
* `node['drbd']['dev']` -> `device`
* `node['drbd']['master']` -> `primary`
* `node['drbd']['port']` -> `port`

Move old package attributes onto `drbd_install` properties:

* `node['drbd']['packages']` -> `packages`
* `node['drbd']['custom_repo'] = true` -> `manage_repository false`

The removed `node['drbd']['configured']` flag has no replacement. The `drbd_pair` actions use runtime checks against DRBD and the block device instead of persisted node state.

## Test cookbook example

The cookbook's default Kitchen suite shows the supported resource-first pattern in `test/cookbooks/test/recipes/default.rb`.

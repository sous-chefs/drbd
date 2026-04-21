# Migration Guide

This cookbook is in an incremental migration from attributes and recipes to custom resources.

## What changed

* The primary interface is now:
  * `drbd_install`
  * `drbd_pair`
* The legacy `drbd::default` and `drbd::pair` recipes remain as compatibility wrappers.
* Historical node attributes are still mapped by the compatibility recipes, but new usage should be resource-first.

## How to migrate

Legacy pattern:

```ruby
include_recipe 'drbd::default'
include_recipe 'drbd::pair'

node.default['drbd']['local_ip'] = '192.0.2.10'
node.default['drbd']['remote_host'] = 'node-b'
node.default['drbd']['remote_ip'] = '192.0.2.11'
node.default['drbd']['disk'] = '/dev/sdb1'
node.default['drbd']['mount'] = '/srv/drbd'
node.default['drbd']['master'] = true
```

Resource-first pattern:

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
* `node['drbd']['master']` -> `primary`

## Important note

This cookbook is not at a full “recipes gone” end state yet. The compatibility recipes still exist for older consumers, but new wrapper cookbooks should call the resources directly.

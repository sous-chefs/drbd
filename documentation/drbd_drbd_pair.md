# drbd_drbd_pair

Manages DRBD pair configuration and exposes the risky replication steps as explicit actions.

## Actions

| Action | Description |
| --- | --- |
| `:configure` | Renders the DRBD resource template. |
| `:initialize` | Creates DRBD metadata if needed and brings the resource up. |
| `:promote` | Promotes the local node to primary when `primary true`. |
| `:format` | Creates a filesystem on the DRBD device when `mount_point` is set and no filesystem exists yet. |
| `:mount` | Mounts the DRBD device when the node is primary and the filesystem already exists. |

## Properties

| Property | Type | Default | Description |
| --- | --- | --- | --- |
| `name` | String | `name property` | DRBD resource name written into `/etc/drbd.d/<name>.res`. |
| `local_host` | String | node hostname | Local DRBD host name used in the rendered config. |
| `local_ip` | String | none | Local replication IP address. |
| `remote_host` | String | none | Remote DRBD host name. |
| `remote_ip` | String | none | Remote replication IP address. |
| `disk` | String | none | Backing block device or partition. |
| `device` | String | `'/dev/drbd0'` | Exposed DRBD block device. |
| `mount_point` | String, nil | `nil` | Mount point for filesystem workflows. Leave unset for raw block-device usage. |
| `fs_type` | String | `'ext3'` | Filesystem type used by `:format` and `:mount`. |
| `primary` | TrueClass, FalseClass | `false` | Whether this node should perform primary-only actions. |
| `port` | Integer | `7789` | DRBD replication port. |
| `config_path` | String | `/etc/drbd.d/<name>.res` | Full path to the rendered DRBD resource file. |

## Examples

### Render pair configuration only

```ruby
drbd_pair 'pair' do
  local_ip '192.0.2.10'
  remote_host 'node-b'
  remote_ip '192.0.2.11'
  disk '/dev/sdb1'
  action :configure
end
```

### Run the primary workflow explicitly

```ruby
drbd_pair 'pair' do
  local_ip '192.0.2.10'
  remote_host 'node-b'
  remote_ip '192.0.2.11'
  disk '/dev/sdb1'
  mount_point '/srv/drbd'
  fs_type 'ext4'
  primary true
  action %i(configure initialize promote format mount)
end
```

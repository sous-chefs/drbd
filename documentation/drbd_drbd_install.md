# drbd_drbd_install

Installs the DRBD userspace and kernel packages needed for this cookbook's resource-first workflow.

## Actions

| Action | Description |
| --- | --- |
| `:create` | Installs the configured DRBD packages. This is the default action. |

## Properties

| Property | Type | Default | Description |
| --- | --- | --- | --- |
| `instance_name` | String | `name property` | Resource name. |
| `packages` | String, Array | platform-specific package list | Package or packages to install. EL9 x86_64 defaults to `drbd9x-utils` and `kmod-drbd9x`. |
| `manage_repository` | TrueClass, FalseClass | platform-specific | Includes `yum-elrepo::default` on the RHEL-family path when `true`. |

## Examples

### Install DRBD with defaults

```ruby
drbd_install 'default'
```

### Install explicit packages without repository management

```ruby
drbd_install 'default' do
  packages %w(drbd90-utils kmod-drbd90)
  manage_repository false
end
```

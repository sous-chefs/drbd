# frozen_string_literal: true

provides :drbd_pair
unified_mode true

property :local_host, String, default: lazy { local_drbd_host }
property :local_ip, String, required: true
property :remote_host, String, required: true
property :remote_ip, String, required: true
property :disk, String, required: true
property :device, String, default: '/dev/drbd0'
property :mount_point, [String, NilClass]
property :fs_type, String, default: 'ext3'
property :primary, [true, false], default: false
property :port, Integer, default: 7789
property :config_path, String, default: lazy { "/etc/drbd.d/#{name}.res" }

action_class do
  include Drbd::Cookbook::Helpers
end

action :configure do
  template new_resource.config_path do
    cookbook 'drbd'
    source 'res.erb'
    variables(
      device: new_resource.device,
      disk: new_resource.disk,
      local_host: new_resource.local_host,
      local_ip: new_resource.local_ip,
      port: new_resource.port,
      remote_host: new_resource.remote_host,
      remote_ip: new_resource.remote_ip,
      resource: new_resource.name
    )
    owner 'root'
    group 'root'
    mode '0644'
  end
end

action :initialize do
  execute "drbdadm create-md #{new_resource.name}" do
    not_if "drbdadm dump-md #{new_resource.name} >/dev/null 2>&1"
  end

  execute "drbdadm up #{new_resource.name}" do
    not_if "drbdadm status #{new_resource.name} >/dev/null 2>&1"
  end
end

action :promote do
  return unless new_resource.primary

  execute "drbdadm -- --overwrite-data-of-peer primary #{new_resource.name}" do
    not_if "drbdadm role #{new_resource.name} 2>/dev/null | grep -q Primary"
  end
end

action :format do
  return if new_resource.mount_point.nil?
  return unless new_resource.primary

  execute "mkfs -t #{new_resource.fs_type} #{new_resource.device}" do
    not_if "blkid -s TYPE -o value #{new_resource.device} 2>/dev/null | grep -qx #{new_resource.fs_type}"
  end
end

action :mount do
  return if new_resource.mount_point.nil?
  return unless new_resource.primary

  directory new_resource.mount_point

  mount new_resource.mount_point do
    device new_resource.device
    fstype new_resource.fs_type
    action :mount
    only_if "blkid -s TYPE -o value #{new_resource.device} 2>/dev/null | grep -qx #{new_resource.fs_type}"
    only_if "drbdadm role #{new_resource.name} 2>/dev/null | grep -q Primary"
    not_if "mountpoint -q #{new_resource.mount_point}"
  end
end

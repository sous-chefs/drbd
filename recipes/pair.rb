# frozen_string_literal: true

drbd_install 'default' do
  packages node['drbd']['packages'] if node.dig('drbd', 'packages')
  manage_repository !node['drbd']['custom_repo']
end

drbd_pair 'pair' do
  remote_host node['drbd']['remote_host']
  remote_ip node['drbd']['remote_ip']
  local_ip node['drbd']['local_ip']
  disk node['drbd']['disk']
  mount_point node['drbd']['mount']
  fs_type node['drbd']['fs_type'] if node.dig('drbd', 'fs_type')
  device node['drbd']['dev'] if node.dig('drbd', 'dev')
  primary node['drbd']['master']
  port node['drbd']['port'] if node.dig('drbd', 'port')
  action %i(configure initialize promote format mount)
end

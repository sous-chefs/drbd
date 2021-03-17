#
# Author:: Matt Ray <matt@chef.io>
# Cookbook:: drbd
# Recipe:: pair
#
# Copyright:: 2011-2019, Chef Software, Inc
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

require 'chef/shell_out'

include_recipe 'drbd'

resource = 'pair'

if node['drbd']['remote_host'].nil?
  raise("You must have a ['drbd']['remote_host'] defined to use the drbd::pair recipe.")
end

template "/etc/drbd.d/#{resource}.res" do
  source 'res.erb'
  variables(
    resource: resource,
    remote_ip: node['drbd']['remote_ip']
  )
  owner 'root'
  group 'root'
  action :create
end

# first pass only, initialize drbd
execute "drbdadm create-md #{resource}" do
  subscribes :run, "template[/etc/drbd.d/#{resource}.res]"
  notifies :restart, 'service[drbd]', :immediately
  only_if do
    cmd = Mixlib::ShellOut.new('drbd-overview')
    overview = cmd.run_command
    Chef::Log.info overview.stdout
    overview.stdout.include?('drbd not loaded')
  end
  action :nothing
end

# claim primary based off of node['drbd']['master']
execute 'drbdadm -- --overwrite-data-of-peer primary all' do
  subscribes :run, "execute[drbdadm create-md #{resource}]"
  only_if { node['drbd']['master'] && !node['drbd']['configured'] }
  action :nothing
end

# You may now create a filesystem on the device, use it as a raw block device
execute "mkfs -t #{node['drbd']['fs_type']} #{node['drbd']['dev']}" do
  subscribes :run, 'execute[drbdadm -- --overwrite-data-of-peer primary all]'
  only_if { node['drbd']['master'] && !node['drbd']['configured'] }
  action :nothing
end

directory node['drbd']['mount'] do
  only_if { node['drbd']['master'] && !node['drbd']['configured'] }
  action :create
end

# mount -t xfs -o rw /dev/drbd0 /shared
mount node['drbd']['mount'] do
  device node['drbd']['dev']
  fstype node['drbd']['fs_type']
  only_if { node['drbd']['master'] && node['drbd']['configured'] }
  action :mount
end

# HACK: to get around the mount failing
ruby_block 'set drbd configured flag' do
  block do
    node.default['drbd']['configured'] = true
  end
  subscribes :create, "execute[mkfs -t #{node['drbd']['fs_type']} #{node['drbd']['dev']}]"
  action :nothing
end

#
# Author:: Matt Ray <matt@chef.io>
# Cookbook Name:: drbd
# Recipe:: pair
#
# Copyright 2011, Chef Software, Inc
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

include_recipe "drbd"

resource = node["drbd"]["resource_name"]

if node['drbd']['remote_host'].nil?
  Chef::Application.fatal! "You must have a ['drbd']['remote_host'] defined to use the drbd::pair recipe."
end

template "/etc/drbd.d/#{resource}.res" do
  source "res.erb"
  variables(
    :resource => resource,
    :remote_ip => node['drbd']['remote_ip']
    )
  owner "root"
  group "root"
  action :create
end

#first pass only, initialize drbd
execute ":create drbd volume" do
  command "drbdadm --force create-md #{resource}"
  subscribes :run, "template[/etc/drbd.d/#{resource}.res]", :immediately
  notifies :restart, "service[drbd]", :immediately
  only_if do
    cmd = Mixlib::ShellOut.new("drbd-overview")
    overview = cmd.run_command
    Chef::Log.info overview.stdout
    overview.stdout.include?("drbd not loaded")
  end
  action :nothing
end

#claim primary based off of node['drbd']['master']
execute ":init drdb volume" do
  command "drbdadm -- --overwrite-data-of-peer primary all"
  subscribes :run, "execute[:create drbd volume]", :immediately
  only_if { node['drbd']['master'] && !node['drbd']['configured'] }
  action :nothing
end

#You may now create a filesystem on the device, use it as a raw block device
execute ":create filesystem" do
  command "mkfs -t #{node['drbd']['fs_type']} #{node['drbd']['dev']}"
  subscribes :run, "execute[:init drdb volume]", :immediately
  only_if { node['drbd']['master'] && !node['drbd']['configured'] }
  action :nothing
end

directory node['drbd']['mount'] do
  only_if { node['drbd']['master'] && !node['drbd']['configured'] }
  action :create
end

#mount -t xfs -o rw /dev/drbd0 /shared
mount node['drbd']['mount'] do
  device node['drbd']['dev']
  fstype node['drbd']['fs_type']
  options node['drbd']['mount_options']
  only_if { node['drbd']['master'] && node['drbd']['configured'] }
  action :mount
end

#hack to get around the mount failing
ruby_block "set drbd configured flag" do
  block do
    node.set['drbd']['configured'] = true
  end
  subscribes :create, "execute[mkfs -t #{node['drbd']['fs_type']} #{node['drbd']['dev']}]"
  action :nothing
end

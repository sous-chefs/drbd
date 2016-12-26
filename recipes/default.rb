#
# Author:: Matt Ray <matt@chef.io>
# Cookbook:: drbd
# Recipe:: default
#
# Copyright:: 2009-2016, Chef Software, Inc.
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

# prime the search to avoid 2 masters
node.save

include_recipe 'yum-elrepo'

if node['drbd']['custom_repo'] != true
  case node['platform']
  when 'redhat', 'centos', 'fedora', 'amazon', 'scientific', 'oracle'
    include_recipe 'yum-elrepo'
  end
end

drbd_packages = value_for_platform_family(
  %w(rhel fedora amazon scientific oracle) => %w(kmod-drbd84 drbd84-utils),
  %w(default debian) => %w(drbd8-utils)
)

drbd_packages.each do |pack|
  package pack do
    action :install
  end
end

service 'drbd' do
  supports(
    restart: true,
    status: true
  )
  action :nothing
end

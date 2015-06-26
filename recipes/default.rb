#
# Author:: Matt Ray <matt@chef.io>
# Author:: Ovais Tariq <me@ovaistariq.net>
# Cookbook Name:: drbd
# Recipe:: default
#
# Copyright 2009, Chef Software, Inc.
# Copyright 2015, Ovais Tariq
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

#prime the search to avoid 2 masters
node.save unless Chef::Config[:solo]

case node["platform_family"]
when "debian"
  package "drbd8-utils" do
    action :install
  end
when "rhel"
  # Configure the opensuse HA/Clustering repository for CentOS 6
  yum_repository 'elrepo' do
    description "ELRepo.org Community Enterprise Linux Repository - el6"
    baseurl "http://elrepo.org/linux/elrepo/el6/$basearch/"
    mirrorlist "http://mirrors.elrepo.org/mirrors-elrepo.el6"
    gpgkey 'https://www.elrepo.org/RPM-GPG-KEY-elrepo.org'
    gpgcheck true
    enabled true
    action :create
  end

  node["drbd"]["packages"].each do |pkg, ver|
    package pkg do
      version ver
      action :install
    end
  end
end

template "/etc/drbd.conf" do
  source "drbd_conf.erb"
  owner "root"
  group "root"
  action :create
end

template "/etc/drbd.d/global_common.conf" do
  source "global_conf.erb"
  owner "root"
  group "root"
  action :create
end

service "drbd" do
  supports(
    :restart => true,
    :status => true
  )
  action :nothing
end

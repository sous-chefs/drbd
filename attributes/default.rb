#
# Author:: Matt Ray <matt@chef.io>
# Author:: Ovais Tariq <me@ovaistariq.net>
# Cookbook Name:: drbd
# Attributes:: default
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

# The DRBD packages and their versions
case node["platform_family"]
when "rhel"
default["drbd"]["packages"] = {
  "drbd83-utils" => "8.3.16-1.el6.elrepo",
  "kmod-drbd83" => "8.3.16-1.el6.elrepo"
  }
end

default['drbd']['remote_host'] = nil
default['drbd']['disk'] = nil
default['drbd']['mount'] = nil
default['drbd']['mount_options'] = ''
default['drbd']['fs_type'] = "ext3"
default['drbd']['dev'] = "/dev/drbd0"
default['drbd']['master'] = false
default['drbd']['port'] = 7789
default['drbd']['configured'] = false

default["drbd"]["resource_name"] = "pair"

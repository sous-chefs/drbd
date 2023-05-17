# drbd Cookbook CHANGELOG

This file is used to list changes made in each version of the drbd cookbook.

## Unreleased

## 3.0.8 - *2023-05-17*

## 3.0.7 - *2023-05-03*

## 3.0.6 - *2023-04-01*

## 3.0.5 - *2023-03-08*

## 3.0.4 - *2023-03-02*

- Standardise files with files in sous-chefs/repo-management

## 3.0.3 - *2023-02-14*

- Remove delivery folder

## 3.0.2 - *2021-08-31*

- Standardise files with files in sous-chefs/repo-management

## 3.0.1 - *2021-06-01*

- Standardise files with files in sous-chefs/repo-management

## 3.0.0 - *2021-03-17*

- Updates default version to 9.0 on supported platforms
- Sous Chefs Adoption
- Cookstyle Fixes

## 2.0.1 (2017-09-01)

- Use a SPDX standard license string
- Disable FC075 where we actually need it
- Cleanup Travis testing and Kitchen config

## 2.0.0 (2017-02-18)

- Remove chef-solo compatibility check
- Add support for RHEL platforms by using yum-elrepo repository
- Use multi-package installs to speed up chef converges

## 1.0.0 (2016-09-15)

- Testing updates
- Require Chef 12.1

## v0.10.0 (2015-10-20)

- Converted Chef::Shellout to Mixlib::Shellout to prevent deprecation warnings
- Changed Opscode -> Chef Software
- Added gitignore file
- Added chefignore file
- Added initial Test Kitchen config
- Added Chef standard rubocop config
- Added Travis CI testing
- Added Berksfile
- Added Gemfile with testing deps
- Updated testing and contributing docs
- Added maintainers.md and maintainers.toml files
- Added travis and cookbook version badges to the readme
- Added a Rakefile for simplified testing
- Added additional platforms to the metadata
- Added source\_url and issues\_url to the metadata
- Added basic convergence Chefspec
- Resolved Rubocop warnings

## v0.9.0 (2014-06-11)

- # 3 - [CHEF-4979] add support for centos and multiple netwrok interfaces

## v0.8.2

- [COOK-2957]: drbd cookbook has foodcritic failures

## v0.8.0

- Initial release.

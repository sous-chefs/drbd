# frozen_string_literal: true

provides :drbd_install
unified_mode true

property :instance_name, String, name_property: true
property :packages, [String, Array],
         coerce: proc { |value| Array(value) },
         default: lazy { default_packages }
property :manage_repository, [true, false], default: lazy { manage_repository_default? }

default_action :create

action_class do
  include Drbd::Cookbook::Helpers
end

action :create do
  run_context.include_recipe('yum-elrepo::default') if new_resource.manage_repository

  package new_resource.packages
end

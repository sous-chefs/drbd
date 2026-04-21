# frozen_string_literal: true

module Drbd
  module Cookbook
    module Helpers
      def default_packages
        return %w(drbd8-utils) if platform?('debian') && node['platform_version'].to_i <= 9
        return %w(drbd90-utils kmod-drbd90) if platform_family?('rhel') && node['platform_version'].to_i >= 7
        return %w(drbd90-utils kmod-drbd90) if platform?('amazon')
        return %w(drbd) if platform?('fedora')

        %w(drbd-utils)
      end

      def manage_repository_default?
        platform_family?('rhel') || platform?('amazon')
      end

      def local_drbd_host
        node['hostname'] || node.name
      end
    end
  end
end

Chef::DSL::Recipe.include(::Drbd::Cookbook::Helpers)
Chef::Resource.include(::Drbd::Cookbook::Helpers)

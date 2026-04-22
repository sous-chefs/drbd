# frozen_string_literal: true

module Drbd
  module Cookbook
    module Helpers
      def default_packages
        return %w(drbd8-utils) if platform?('debian') && node['platform_version'].to_i <= 9
        return %w(drbd9x-utils kmod-drbd9x) if el9_x86_64_rpm_platform?
        return %w(drbd-utils kmod-drbd) if platform_family?('rhel') && node['platform_version'].to_i >= 7
        return %w(drbd-utils kmod-drbd) if platform?('amazon')
        return %w(drbd) if platform?('fedora')

        %w(drbd-utils)
      end

      def manage_repository_default?
        platform_family?('rhel') || platform?('amazon')
      end

      def unsupported_el9_repository_architecture?
        platform_family?('rhel') && node['platform_version'].to_i >= 9 && manage_repository_default? && kernel_machine != 'x86_64'
      end

      def kernel_machine
        node.dig('kernel', 'machine')
      end

      def el9_x86_64_rpm_platform?
        platform_family?('rhel') && node['platform_version'].to_i >= 9 && kernel_machine == 'x86_64'
      end

      def local_drbd_host
        node['hostname'] || node.name
      end
    end
  end
end

Chef::DSL::Recipe.include(::Drbd::Cookbook::Helpers)
Chef::Resource.include(::Drbd::Cookbook::Helpers)

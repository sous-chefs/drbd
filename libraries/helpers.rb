module Drbd
  module Cookbook
    module Helpers
      def drbd_packages
        return %w(drbd8-utils) if platform?('debian') && node['platform_version'].to_i <= 9
        return %w(drbd90-utils kmod-drbd90) if platform_family?('rhel') && node['platform_version'].to_i >= 7
        return %w(drbd90-utils kmod-drbd90) if platform?('amazon')
        return %w(drbd) if platform?('fedora')
        %w(drbd-utils)
      end
    end
  end
end

Chef::DSL::Recipe.include ::Drbd::Cookbook::Helpers
Chef::Resource.include ::Drbd::Cookbook::Helpers

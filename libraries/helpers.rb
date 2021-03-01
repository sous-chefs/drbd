module Drbd
  module Cookbook
    module Helpers
      def drbd_packages
        return %w(kmod-drbd84 drbd84-utils) if platform?('redhat', 'fedora')
        return %w(drbd-utils) if platform?('debian') && node['platform_version'].to_i == 10
        %w(drbd8-utils)
      end
    end
  end
end

Chef::DSL::Recipe.include ::Drbd::Cookbook::Helpers
Chef::Resource.include ::Drbd::Cookbook::Helpers

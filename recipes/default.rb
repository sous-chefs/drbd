# frozen_string_literal: true

drbd_install 'default' do
  packages node['drbd']['packages'] if node.dig('drbd', 'packages')
  manage_repository !node['drbd']['custom_repo']
end

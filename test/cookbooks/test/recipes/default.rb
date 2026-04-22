# frozen_string_literal: true

drbd_install 'default'

drbd_pair 'pair' do
  local_host 'node-a'
  local_ip '192.0.2.10'
  remote_host 'node-b'
  remote_ip '192.0.2.11'
  disk '/dev/sdb1'
  action :configure
end

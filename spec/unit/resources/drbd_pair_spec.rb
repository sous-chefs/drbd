# frozen_string_literal: true

require 'spec_helper'

describe 'drbd_pair' do
  step_into :drbd_pair
  platform 'ubuntu', '24.04'

  context 'with configure action' do
    recipe do
      drbd_pair 'pair' do
        local_host 'node-a'
        local_ip '192.0.2.10'
        remote_host 'node-b'
        remote_ip '192.0.2.11'
        disk '/dev/sdb1'
        action :configure
      end
    end

    it { is_expected.to create_template('/etc/drbd.d/pair.res') }
    it { is_expected.to render_file('/etc/drbd.d/pair.res').with_content(%r{device\s+/dev/drbd0;}) }
    it { is_expected.to render_file('/etc/drbd.d/pair.res').with_content(%r{disk\s+/dev/sdb1;}) }
    it { is_expected.to render_file('/etc/drbd.d/pair.res').with_content(/on node-a/) }
    it { is_expected.to render_file('/etc/drbd.d/pair.res').with_content(/on node-b/) }
  end

  context 'with the full primary workflow actions' do
    before do
      stub_command('drbdadm dump-md pair >/dev/null 2>&1').and_return(false)
      stub_command('drbdadm status pair >/dev/null 2>&1').and_return(false)
      stub_command('drbdadm role pair 2>/dev/null | grep -q Primary').and_return(false)
      stub_command('blkid -s TYPE -o value /dev/drbd0 2>/dev/null | grep -qx ext4').and_return(false)
      stub_command('mountpoint -q /srv/drbd').and_return(false)
    end

    recipe do
      drbd_pair 'pair' do
        local_host 'node-a'
        local_ip '192.0.2.10'
        remote_host 'node-b'
        remote_ip '192.0.2.11'
        disk '/dev/sdb1'
        mount_point '/srv/drbd'
        fs_type 'ext4'
        primary true
        action %i(configure initialize promote format mount)
      end
    end

    it { is_expected.to run_execute('drbdadm create-md pair') }
    it { is_expected.to run_execute('drbdadm up pair') }
    it { is_expected.to run_execute('drbdadm -- --overwrite-data-of-peer primary pair') }
    it { is_expected.to run_execute('mkfs -t ext4 /dev/drbd0') }
    it { is_expected.to create_directory('/srv/drbd') }
    it 'declares the mount resource with the DRBD device' do
      mount_resource = chef_run.find_resource(:mount, '/srv/drbd')

      expect(mount_resource.device).to eq('/dev/drbd0')
      expect(mount_resource.fstype).to eq('ext4')
      expect(mount_resource.action).to eq([:mount])
    end
  end
end

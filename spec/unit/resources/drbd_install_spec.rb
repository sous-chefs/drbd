# frozen_string_literal: true

require 'spec_helper'

describe 'drbd_install' do
  step_into :drbd_install

  context 'on ubuntu' do
    platform 'ubuntu', '24.04'

    recipe do
      drbd_install 'default'
    end

    it { is_expected.to install_package(%w(drbd-utils)) }
  end

  context 'on red hat enterprise linux 9 x86_64' do
    platform 'redhat', '9'
    automatic_attributes['kernel']['machine'] = 'x86_64'

    recipe do
      drbd_install 'default' do
        manage_repository false
      end
    end

    it { is_expected.to install_package(%w(drbd9x-utils kmod-drbd9x)) }
  end

  context 'on almalinux 9 x86_64' do
    platform 'almalinux', '9'
    automatic_attributes['kernel']['machine'] = 'x86_64'

    recipe do
      drbd_install 'default' do
        manage_repository false
      end
    end

    it { is_expected.to install_package(%w(drbd9x-utils kmod-drbd9x)) }
  end

  context 'on almalinux 9 aarch64 with repository management' do
    platform 'almalinux', '9'
    automatic_attributes['kernel']['machine'] = 'aarch64'

    recipe do
      drbd_install 'default'
    end

    it 'fails with a clear ELRepo architecture message' do
      expect { chef_run }.to raise_error(
        Chef::Exceptions::Package,
        /ELRepo does not publish EL9 DRBD packages for aarch64/
      )
    end
  end
end

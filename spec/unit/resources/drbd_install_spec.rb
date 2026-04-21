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

  context 'with an explicit package list on alma linux' do
    platform 'almalinux', '9'

    recipe do
      drbd_install 'default' do
        packages %w(drbd90-utils kmod-drbd90)
        manage_repository false
      end
    end

    it { is_expected.to install_package(%w(drbd90-utils kmod-drbd90)) }
  end
end

require 'spec_helper'

describe 'drbd::default' do
  context 'Ubuntu' do
    platform 'ubuntu'

    it 'converges successfully' do
      expect { :chef_run }.to_not raise_error
    end
  end

  context 'CentOS' do
    platform 'centos'

    it 'converges successfully' do
      expect { :chef_run }.to_not raise_error
    end
  end
end

require 'spec_helper'

describe 'default recipe on Ubuntu 14.04' do
  let(:chef_run) do
    ChefSpec::ServerRunner.new(platform: 'ubuntu', version: '14.04').converge('drbd::default')
  end

  it 'converges successfully' do
    expect { :chef_run }.to_not raise_error
  end
end

describe 'default recipe on Ubuntu 16.04' do
  let(:chef_run) do
    ChefSpec::ServerRunner.new(platform: 'ubuntu', version: '16.04').converge('drbd::default')
  end

  it 'converges successfully' do
    expect { :chef_run }.to_not raise_error
  end
end

describe 'default recipe on CentOS 6' do
  let(:chef_run) do
    ChefSpec::ServerRunner.new(platform: 'centos', version: '6.8').converge('drbd::default')
  end

  it 'converges successfully' do
    expect { :chef_run }.to_not raise_error
  end
end

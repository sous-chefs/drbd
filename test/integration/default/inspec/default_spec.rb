describe file('/etc/drbd.conf') do
  it { should be_file }
end

describe command 'drbdadm -V' do
  its('exit_status') { should eq 0 }
end

# since it isn't connected to anything, no reason to run
describe service('drbd') do
  it { should_not be_enabled }
  it { should_not be_running }
end

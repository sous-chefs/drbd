# frozen_string_literal: true

control 'drbd-install-01' do
  impact 1.0
  title 'DRBD userspace tools are installed'

  describe file('/etc/drbd.conf') do
    it { should exist }
  end

  describe command('drbdadm -V') do
    its('exit_status') { should eq 0 }
  end
end

control 'drbd-config-01' do
  impact 0.7
  title 'The pair configuration is rendered through the custom resource'

  describe file('/etc/drbd.d/pair.res') do
    it { should exist }
    its('content') { should match(/resource pair/) }
    its('content') { should match(%r{disk\s+/dev/sdb1;}) }
    its('content') { should match(/on node-a/) }
    its('content') { should match(/on node-b/) }
  end
end

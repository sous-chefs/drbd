name 'drbd-pair-master'
description 'DRBD pair role.'

override_attributes(
  'drbd' => {
    'remote_host' => 'ubuntu2-1004.vm',
    'remote_ip' => '192.168.0.1',
    'local_ip' => '192.168.0.2',
    'disk' => '/dev/sdb1',
    'fs_type' => 'xfs',
    'mount' => '/shared',
    'master' => true,
  }
)

run_list(
  'recipe[xfs]',
  'recipe[drbd::pair]'
)

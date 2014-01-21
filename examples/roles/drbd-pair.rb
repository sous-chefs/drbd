name "drbd-pair"
description "DRBD pair role."

override_attributes(
  "drbd" => {
    "remote_host" => "ubuntu1-1004.vm",
    "remote_ip" => "192.168.0.2",
    "local_ip" => "192.168.0.1",
    "disk" => "/dev/sdb1",
    "fs_type" => "xfs",
    "mount" => "/shared"
  }
  )

run_list(
  "recipe[xfs]",
  "recipe[drbd::pair]"
  )

name              "drbd"
maintainer        "Chef Software, Inc."
maintainer_email  "cookbooks@chef.io"
license           "Apache 2.0"
description       "Installs/Configures drbd."
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version           "0.9.2"

depends "yum"

%w{ debian ubuntu centos }.each do |os|
  supports os
end

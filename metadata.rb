name              "irc_handler"
maintainer        "The Wharton School - The University of Pennsylvania"
maintainer_email  "bflad@wharton.upenn.edu"
license           "Apache 2.0"
description       "Installs, configures, and enables IRC exception handler."
version           "0.1.0"
recipe            "irc_handler", "Installs, configures, and enables IRC exception handler."

%w{ chef_handler }.each do |cb|
  depends cb
end

%w{ redhat ubuntu }.each do |os|
  supports os
end

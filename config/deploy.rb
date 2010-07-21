#
# Server setup -- this will vary depending on your firewall's particulars
#
role :firewall, "YOUR FIREWALL HOSTNAME OR IP HERE"
set :user, "YOUR REMOTE USER HERE"
set :deploy_to, "/var/filewall"

# this is necessary for Debian and Ubuntu machines to properly use sudo
default_run_options[:pty] = true


#
# Repository setup -- this will vary depending on your scm setup
#
set :scm, :git
set :repository, "YOUR REPO HERE"
set :branch, "YOUR BRANCH HERE"

# Setting the following makes outbound git connections on the server work
ssh_options[:forward_agent] = true


#
# Filewall setup
#
set :rule_timeout, 60   # How long should shorewall wait before reverting rules


# Load the actual recipes
load 'config/filewall'
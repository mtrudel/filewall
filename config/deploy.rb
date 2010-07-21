set :deploy_to, "/var/filewall"

role :firewall, "YOUR IP HERE"

set :user, "ubuntu" # Change this on debian machines
default_run_options[:pty] = true
ssh_options[:forward_agent] = true

set :scm, :git
set :repository, "YOUR REPO PATH HERE"
set :branch, "master" # You'll probably want to change this

set :rule_timeout, 60 # How long wait before reverting rules

load 'config/filewall'
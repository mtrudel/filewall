set :application, "filewall"
set :deploy_to, "/var/filewall"

role :firewall, "YOUR IP HERE"

set :user, "ubuntu" # Change this on debian machines
default_run_options[:pty] = true
ssh_options[:forward_agent] = true

set :scm, :git
set :repository, "YOUR REPO PATH HERE"
set :branch, "master" # You'll probably want to change this

set :rule_timeout, 60 # How long wait before reverting rules

# You oughtn't need to change anything below here
load 'config/shorewall' 
load 'config/dnsmasq'
load 'config/pptpd'
load 'config/ssh'

namespace :deploy do
  desc "Install the base packages we need"
  task :install_packages do
    AptCommand = "env DEBCONF_TERSE='yes' DEBIAN_PRIORITY='critical' DEBIAN_FRONTEND=noninteractive apt-get --force-yes -qyu"
    run "#{sudo} #{AptCommand} update"
    run "#{sudo} #{AptCommand} install dnsmasq git-core pptpd shorewall"
    run "#{sudo} sed -i 's/^startup=0/startup=1/g' /etc/default/shorewall"
  end
  before "deploy:setup", "deploy:install_packages"
  
  after "deploy:setup", "ssh:show_warning"

  desc "Set up all the relevant directories"
  task :setup, :except => { :no_release => true } do
    dirs = [deploy_to, releases_path]
    run "#{sudo} mkdir -p #{dirs.join(' ')}"
    run "#{sudo} chown #{user} #{dirs.join(' ')}"
  end

  desc "Try the rules out before we commit the deployment"
  task :finalize_update do 
    # shorewall.try aborts if it encounters an error, which is what we want
    shorewall.try
  end
  
  after "deploy:symlink", "shorewall:symlink"
  after "deploy:symlink", "dnsmasq:symlink"
  after "deploy:symlink", "pptpd:symlink"

  desc "Restart filewall"
  task :restart do
    shorewall.restart
    dnsmasq.restart
    pptpd.restart    
  end  
end

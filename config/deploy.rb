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
 
namespace :deploy do
  desc "Install the base packages we need"
  task :install_packages do
    AptCommand = "env DEBCONF_TERSE='yes' DEBIAN_PRIORITY='critical' DEBIAN_FRONTEND=noninteractive apt-get --force-yes -qyu"
    run "#{sudo} #{AptCommand} update"
    run "#{sudo} #{AptCommand} install shorewall git-core"
    run "#{sudo} sed -i 's/^startup=0/startup=1/g' /etc/default/shorewall"
  end
  before "deploy:setup", "deploy:install_packages"

  desc "Set up all the relevant directories"
  task :setup, :except => { :no_release => true } do
    dirs = [deploy_to, releases_path]
    run "#{sudo} mkdir -p #{dirs.join(' ')}"
    run "#{sudo} chown #{user} #{dirs.join(' ')}"
  end
  
  desc "Try the rules out before we commit the deployment"
  task :finalize_update do 
    # shorewall.try throws if it encounters an error, which is what we want
    shorewall.try
  end

  desc "Symlink shorewall config into current"
  task :symlink_shorewall do
    run "[ -d /etc/shorewall ] && #{sudo} rm -rf /etc/shorewall && #{sudo} ln -s #{deploy_to}/current/rules /etc/shorewall"
  end  
  after "deploy:symlink", "deploy:symlink_shorewall"

  desc "Restart shorewall"
  task :restart do
    shorewall.restart
  end  
end

namespace :shorewall do
  desc "Try out the config in via shorewall's try operation. Raises if it doesn't work"
  task :try do
    logger.important "
    
    #{'=' * 75}    
  
    We're now going to temporarily apply the new rules for a period of 
    at most #{rule_timeout} seconds. The new rules will be rolled back 
    after that time, and you'll be giventhe choice to apply them 
    permanently, or revery them.
  
    #{'=' * 75}    
    
    Press any key when ready"
    STDIN.getc
    run "#{sudo} shorewall try #{current_release}/rules #{rule_timeout}"

    # Ask the user if the new rules worked. If we raise here, it'll rollback 
    # the entire config, leaving the existing rules unchanged
    abort unless Capistrano::CLI.ui.agree("Do you want to permanently apply the new rules? ")
  end  
  
  desc "Apply the curernt shorewall config"
  task :restart do
    run "#{sudo} shorewall restart"
  end
end

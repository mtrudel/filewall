set :application, "filewall"
set :deploy_to, "/var/filewall/"

role :firewall, "YOUR IP HERE"

set :user, "ubuntu" # Change this on debian machines
default_run_options[:pty] = true
ssh_options[:forward_agent] = true

set :scm, :git
set :repository, "YOUR REPO PATH HERE"
set :branch, "origin/master" # You'll probably want to change this

set :rule_timeout, 60 # How long wait before reverting rules
 
namespace :deploy do
  desc "Deploy filewall"
  task :default do
    update
    begin
      check
      try
      ask
      apply
    rescue
      rollback
    end
  end
 
  desc "Setup the base directories and install shorewall"
  task :setup, :except => { :no_release => true } do
    AptCommand = "env DEBCONF_TERSE='yes' DEBIAN_PRIORITY='critical' DEBIAN_FRONTEND=noninteractive apt-get --force-yes -qyu"
    run "#{sudo} #{AptCommand} update"
    run "#{sudo} #{AptCommand} install shorewall git-core"
    run "#{sudo} sed -i 's/^startup=0/startup=1/g' /etc/default/shorewall"
    run "#{sudo} mkdir -p #{deploy_to}"
    run "#{sudo} chown #{user} #{deploy_to}"
    run "[ -d #{deploy_to}.git ] || git clone #{repository} #{deploy_to}"
    run "[ -d /etc/shorewall ] && #{sudo} rm -rf /etc/shorewall"
    run "#{sudo} ln -s #{deploy_to}rules /etc/shorewall"
  end
  
  desc "Update the deployed firewall configuration"
  task :update, :except => { :no_release => true } do
    run "cd #{deploy_to}; git fetch origin; git reset --hard #{branch}"
  end

  desc "Verify the config in via shorewall's check operation. Raises if it doesn't work"
  task :check do
    run "#{sudo} shorewall check #{deploy_to}rules"
  end

  desc "Try out the config in via shorewall's try operation. Raises if it doesn't work"
  task :try do
    logger.important "
    
    #{'=' * 75}    
    
    We're now going to temporarily apply the new rules for a period of at most #{rule_timeout} seconds
    The new rules will be rolled back after that time, and you'll be given 
    the choice to apply them permanently, or revery them.
    
    #{'=' * 75}    
    
    Press any key when ready"
    STDIN.getc
    run "#{sudo} shorewall try #{deploy_to}rules #{rule_timeout}"
  end

  desc "Ask the user if the config worked"
  task :ask do
    raise unless Capistrano::CLI.ui.agree("Do you want to permanently apply the new rules? ")
  end

  desc "Apply the curernt shorewall config"
  task :apply do
    run "#{sudo} shorewall restart #{deploy_to}rules"
  end
  
  desc "Rollback a single configuration"
  task :rollback, :except => { :no_release => true } do
    run "cd #{deploy_to}; git fetch origin; git reset --hard HEAD^"      
  end    
end

namespace :shorewall do
  desc "Symlink shorewall config into current"
  task :symlink do
    run "[ -h /etc/shorewall ] || (#{sudo} mv /etc/shorewall /etc/shorewall.orig && #{sudo} ln -s #{deploy_to}/current/rules /etc/shorewall)"
  end  

  desc "Try out the config in via shorewall's try operation. Abort if it doesn't work"
  task :try do

    # First, verify that the rules actually work
    run "#{sudo} shorewall check #{current_release}/rules" rescue abort "Your ruleset didn't compile remotely. Quitting"

    # Now tell the user what's about to happen, and give them a chance to back out
    logger.important "

    #{'=' * 75}    

    We're now going to temporarily apply the new rules for a period of #{rule_timeout} 
    seconds. The new rules will be rolled back after that time, and you'll be 
    given the choice to apply them permanently, or to revert them.

    #{'=' * 75}    

    Press any key when ready, or press Ctrl+C to abort"
    begin
      STDIN.getc
    rescue Exception 
      abort "Quitting due to user request"
    end

    # Now actually try the rules for the timeout period
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
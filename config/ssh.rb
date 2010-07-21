namespace :ssh do
  desc "Show warning about lockdown"
  task :show_warning do
    logger.important "
    
    #{'=' * 75}    
  
    You probably want to now run 'cap ssh:lockdown' to lock your ssh configuration
    down. This will disable ssh password logins, and also prevent the root user
    from logging in. 
  
    #{'=' * 75}"
  end

  desc "Lock down sshd"
  task :lockdown do
    run "[ -f ~/.ssh/authorized_keys ]" rescue abort "You don't have a remote ~/.ssh/authorized_keys file. If I lock down ssh, I'll lock you out!"
    run "[ \`id -u\` != 0 ]" rescue abort "You're logging in as root. If I lock down ssh, I'll lock you out!"
    run "#{sudo} sed -i 's/^PermitRootLogin yes/PermitRootLogin no/g' /etc/ssh/sshd_config"
    run "#{sudo} sed -i 's/#PasswordAuthentication yes/PasswordAuthentication no/g' /etc/ssh/sshd_config"
    run "#{sudo} /etc/init.d/ssh restart"
  end
end
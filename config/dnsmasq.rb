namespace :dnsmasq do
  desc "Symlink dnsmasq config into current"
  task :symlink do
    run "[ ! -f /etc/dnsmasq.conf ] || (#{sudo} mv /etc/dnsmasq.conf /etc/dnsmasq.conf.orig && #{sudo} ln -s #{deploy_to}/current/dnsmasq/dnsmasq.conf /etc/dnsmasq.conf)"
  end  
    
  desc "Apply the curernt dnsmasq config"
  task :restart do
    run "#{sudo} /etc/init.d/dnsmasq restart"
  end
end
  
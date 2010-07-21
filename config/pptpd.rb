namespace :pptpd do
  desc "Symlink pptpd config into current"
  task :symlink do
    run "[ ! -f /etc/pptpd.conf ] || (#{sudo} mv /etc/pptpd.conf /etc/pptpd.conf.orig && #{sudo} ln -s #{deploy_to}/current/pptpd/pptpd.conf /etc/pptpd.conf)"
    run "[ ! -f /etc/ppp/pptpd-options ] || (#{sudo} mv /etc/ppp/pptpd-options /etc/ppp/pptpd-options.orig && #{sudo} ln -s #{deploy_to}/current/pptpd/pptpd-options /etc/ppp/pptpd-options)"
  end  
    
  desc "Apply the curernt pptpd config"
  task :restart do
    run "#{sudo} pptpd restart"
  end
end

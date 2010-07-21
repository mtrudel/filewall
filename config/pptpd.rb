namespace :pptpd do
  desc "Symlink pptpd config into current"
  task :symlink do
    run "[ ! -f /etc/pptpd.conf ] || (#{sudo} mv /etc/pptpd.conf /etc/pptpd.conf.orig && #{sudo} ln -s #{deploy_to}/current/pptpd/pptpd.conf /etc/pptpd.conf)"
    run "[ ! -f /etc/ppp/pptpd-options ] || (#{sudo} mv /etc/ppp/pptpd-options /etc/ppp/pptpd-options.orig && #{sudo} ln -s #{deploy_to}/current/pptpd/pptpd-options /etc/ppp/pptpd-options)"
    run "[ ! -f /etc/ppp/chap-secrets ] || (#{sudo} mv /etc/ppp/chap-secrets /etc/ppp/chap-secrets.orig && #{sudo} ln -s #{deploy_to}/current/pptpd/chap-secrets /etc/ppp/chap-secrets)"
    run "[ ! -f /etc/ppp/pap-secrets ] || (#{sudo} mv /etc/ppp/pap-secrets /etc/ppp/pap-secrets.orig && #{sudo} ln -s #{deploy_to}/current/pptpd/pap-secrets /etc/ppp/pap-secrets)"    
  end  
    
  desc "Apply the curernt pptpd config"
  task :restart do
    run "#{sudo} pptpd restart"
  end
end

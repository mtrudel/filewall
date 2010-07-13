## Filewall

**git + capistrano + shorewall = filewall**. it's what you want.

Forget about statefully configured firewalls; filewall is a file-based firewall, and it's what you're looking for. With filewall, your firewall configuration is 100% defined in your filewall repository, aided by the trusty and flexible [shoreline firewall](http://www.shorewall.net/) system. Filewall uses [capistrano](http://www.capify.org/) to make and roll back changes to your live firewall configuration, mirroring the way you deploy changes to your webapps. Filewall lets your network configuration live where it belongs, in your git (or other scm) repository. 

Filewall comes with a couple of tools that make the whole process of firewall setup less stressful than it usually is. You can deploy rules with a dead-man switch to prevent lockout, easily see differences between your repository and your firewall's active ruleset, and get traffic reports back in a flash.

Coming soon, filewall will also let you manage some standard infrastructure daemons, most notably dnsmasq. This will make filewall your one-stop-shop for all your network needs. 

### Usage

Filewall will configure any Ubuntu or Debian machine to be a firewall. It's usually best to start off with a clean install, just to make sure no errant services are there to be exploited on your firewall.


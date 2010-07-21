## Filewall

**git + capistrano + shorewall = filewall**. it's what you want.

Forget about statefully configured menu driven firewalls; filewall is a file-based firewall, and it's what you're looking for. With filewall, your firewall configuration is 100% defined in your filewall repository, aided by the trusty and flexible [shoreline firewall](http://www.shorewall.net/) system. Filewall uses [capistrano](http://www.capify.org/) to make and roll back changes to your live firewall configuration, mirroring the way you deploy changes to your webapps. Filewall lets your network configuration live where it belongs, in your git (or other scm) repository. 
 
Filewall deploys your rules with a dead-man switch so you'll never lock yourself out of your firewall again. If your rules accidentally send you up the bomb, just wait for the timeout and your old settings will be restored. 

Filewall also let you manage some standard infrastructure daemons including  [dnsmasq](http://www.thekelleys.org.uk/dnsmasq/doc.html) and [pptpd](http://www.poptop.org/).

### Usage

Filewall works happily with any Ubuntu or Debian machine. It's usually best to start off with a clean install, just to make sure no errant services are there to be exploited on your firewall.

### Getting started

In a nutshell, filewall installs the contents of the `rules/` subdirectory of your repository on a temporary basis, and provides you with a parachute to try these rules out safely. Included in this repository are two sample configuration branches, `one_interface` and `two_interface`. Both of these are taken near-verbatim from the respective examples in the shorewall documentation ([here](http://www.shorewall.net/standalone.htm) and [here](http://www.shorewall.net/two-interface.htm)). If your network config falls into one of those two categories, then those branches are a good starting point for customization. If not, then it probably makes the most sense to find a suitable configuration and start from there; filewall can do anything that shorewall can do. 

drupal-puppet
=============

Drupal puppet manifests for deploying budget vps's or vagrant sandbox.

The build will setup:

 * nginx
 * php5-fpm
 * apc with some sane defaults for a small 512Mb cloud server. Note we set "apc.stat = 0". This means when you update a php file you need to run "sudo service php5-fpm restart" for the changes to take affect. Setting apc.stat=0 prevents checking for file changes on each request and so acts as a production optimisation.
 * Basic server security
   * Prevent root ssh login
   * Create a default user account. This is set to 'adam'. To change it update '$user = "adam"' in puppet/modules/secured/manifests.ini. <strong>Important: update the password in this file from changeme</strong>
   * Add your public private key for passwordless login as the above user 'adam'. Please update puppet/modules/secured/files/authorized_keys with your public key.
   * Setup firewall rules to only allow ssh and http access. If you have a static IP you should update the firewall rule to only allow access from your ip. This is in puppet/modules/secured/manifests.ini, an example:

    ufw::allow { "allow-ssh-access":
        port => 22,
        from => "10.0.0.20",
    }

    * Install deny hosts to block bots who repeatedly try to access ssh

To run the build on a brand new clean server:

* sudo apt-get update
* sudo apt-get upgrade
* sudo apt-get install git puppet
* git clone https://github.com/ajevans85/drupal-puppet.git
* cd drupal-puppet
* FACTER_server_tags="role:drupal_stack=true" puppet apply --modulepath ./puppet/modules ./puppet/manifests/site.pp

With the above you should have a secured server ready for Drupal setup in under 3 minutes.

Note when puppet has applied the configuration you must log in with the specified user account as root access has been blocked.

This is a trivial example for small standalone deployments. For more advanced deployments you should consider:
  * LDAP can be used to manage user access, you will need to write the puppet modules to install required ldap pam modules and configuration
  * Restrict access to your office VPN
  * Install nagios configuration to point to your monitoring services
  * Configure backups to something such as R1Soft idera or manual rsync to a cloud files host
  * Creata a custom apt repo, package up puppet manifests as a deb. Create a cloud base image with puppet installed, your puppet manifests deb and does a update on first boot + apply puppet manifests. If your cloud host provides functionality CloudInit could be used to do this instead of creating a base image.

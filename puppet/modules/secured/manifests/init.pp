class secured($user = "adam", $password="changeme") {
      
    group { "admin":
        ensure => "present",
    }

    user { "adam":
        ensure     => "present",
        managehome => true,
        groups => ['admin'],
        home       => "/home/$user",
        shell      => '/bin/bash',
        require    => Package['whois'],
        notify => Exec["set_initial_password"],
    }

    exec {"set_initial_password":
        command => "echo '$user:$password' | chpasswd",
        unless => "cat /etc/shadow | awk -F: '{print \$1}' | grep ^$user\$",
        require => User[$user],
    }

    #provides mpassword needed for ubuntu password function
    package {"whois":
        ensure => "present",
    }

    
    file {"/etc/ssh/sshd_config":
	    owner => 'root',
	    group => 'root',
	    mode => '644',
	    content => template("secured/sshd_config"),
  	}

  	service { "ssh": 
		ensure => running,
		subscribe => File['/etc/ssh/sshd_config'],
	}


    file { "/home/$user/.ssh":
        ensure => directory,
        require => User[$user],
        mode => 700,
        owner => $user,
        group => $user,
    }

    file { "/home/$user/.ssh/authorized_keys":
        ensure => present,
        source => "puppet:///modules/secured/authorized_keys",
        require => File["/home/$user/.ssh"],
        mode   => 400,
        owner => $user,
        group => $user,
    }

    package { "denyhosts":
        ensure => present,
    }

    include ufw
    ufw::allow { "allow-ssh-from-all":
      port => 22,
    }

    ufw::allow { "allow-http-from-all":
      port => 80,
    }


    if ($virtual != 'virtualbox') {
        file {"/etc/sudoers":
            ensure => present,
            source => "puppet:///modules/secured/sudoers",
            require => File["/home/$user/.ssh"],
            mode   => 440,
            owner => root,
            group => root,
        }

        service { "sudo": 
            ensure => running,
            subscribe => File['/etc/sudoers'],
        }
    }

    package{"rkhunter":
        ensure => present
    }

    file { "/etc/default/rkhunter":
        ensure => present,
        source => "puppet:///modules/secured/rkhunter",
        require => Package['rkhunter'],
        mode   => 444,
    }
}
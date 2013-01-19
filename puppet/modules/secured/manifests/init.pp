class secured($user = "adam") {
      
    group { "admin":
        ensure => "present",
    }

    user { "adam":
        ensure     => "present",
        managehome => true,
        groups => ['admin'],
        password => sha1("changeme"),
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
        require => User["adam"],
        mode => 700,
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
}
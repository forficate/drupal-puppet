class secured($allow_users = "adam") {
      
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

	package { "denyhosts":
		ensure => present,
	}
}
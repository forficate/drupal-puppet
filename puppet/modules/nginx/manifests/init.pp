class nginx {
	
	package {"nginx":
		ensure => installed
	}

	service {"nginx": 
		ensure => running,
		subscribe => Package['nginx'],
	}
}
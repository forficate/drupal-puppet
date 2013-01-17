class nginx {
	
	package {"nginx":
		ensure => installed
	}

	service {"nginx": 
		ensure => running,
		subscribe => Package['nginx'],
	}

 	file {"/etc/nginx/nginx.conf":
	    source => "puppet:///modules/nginx/nginx.conf",
	    owner => 'root',
	    group => 'root',
	    mode => '644',
	    require => Package['nginx'],
	    notify => Service['nginx'],
  	}

}
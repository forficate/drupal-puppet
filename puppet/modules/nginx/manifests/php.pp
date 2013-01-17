class nginx::php {
	include nginx
	
	package { "php5-fpm":
		ensure => present,
		require => Class["nginx"]
	}

	service { "php5-fpm": 
		ensure => running,
		subscribe => Package['php5-fpm'],
	}
}
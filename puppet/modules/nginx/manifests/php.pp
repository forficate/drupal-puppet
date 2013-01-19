class nginx::php {
	include nginx
	
	package { "php5-fpm":
		ensure => present,
		require => Class["nginx"]
	}

	package {"php-apc":
		ensure => present,
		require=> Package["php5-fpm"],
		notify => Service["php5-fpm"],
	}

	service { "php5-fpm": 
		ensure => running,
		subscribe => Package['php5-fpm'],
	}

	package {"php5-gd":
		ensure => present,
		require=> Package["php5-fpm"],
		notify => Service["php5-fpm"],
	}

	file { "/etc/php5/conf.d/apc.ini":
		require => Package["php-apc"],
		notify => Service["php5-fpm"],
		source => "puppet:///modules/nginx/nginx.conf",
		owner => 'root',
		group => 'root',
		mode => '644',
	}

	file { "//etc/php5/cli/php.ini":
		require => Package["php5-fpm"],
		notify => Service["php5-fpm"],
		source => "puppet:///modules/nginx/php.ini",
		owner => 'root',
		group => 'root',
		mode => '644',
	}
}
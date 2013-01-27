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

    package {"php5-mysql":
        ensure => present,
        require=> Package["php5-fpm"],
        notify => Service["php5-fpm"],
    }

    exec {"set_php_Listen_socket":
        command => 'sed -i \'s/listen = 127.0.0.1:9000/listen = \/tmp\/phpfpm.sock/g\' /etc/php5/fpm/pool.d/www.conf',
        unless => 'grep "^listen = /tmp/phpfpm.sock$" /etc/php5/fpm/pool.d/www.conf',
        require => Package["php5-fpm"],
        notify => Service["php5-fpm"],
    }

    file { "/etc/php5/conf.d/apc.ini":
        require => Package["php-apc"],
        notify => Service["php5-fpm"],
        source => "puppet:///modules/nginx/apc.ini",
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
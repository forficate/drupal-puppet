define website ($domain = $title, $aliases="") {
    file {"/etc/nginx/sites-available/$domain":
        ensure  => file,
        mode    => 444,
        owner   => 'www-data',
        group   => 'www-data',
        content => template("nginx/drupal_vhost.erb"),
        require => Package['nginx'],
    }

    file {"/etc/nginx/sites-enabled/$domain":
        ensure => 'link',
        target => "/etc/nginx/sites-available/$domain",
        require => File["/etc/nginx/sites-available/$domain"],
    }
      
    file {"/var/www/$domain":
        ensure  => directory,
        mode    => 0775,
        owner   => 'www-data',
        group   => 'www-data',
        require => Package['nginx'],
    }
}
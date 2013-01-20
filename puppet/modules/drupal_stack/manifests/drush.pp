class drush {
	
	package {"php-pear":
		ensure => present,
	}

	exec {"add_drush_pear_channel":
	    command => "pear channel-discover pear.drush.org",
	    unless => "pear list-channels | grep pear.drush.org",
	    require => Package['php-pear']
	}

	exec {"install_drush":
		command => "pear install drush/drush",
		require => Exec["add_drush_pear_channel"],
		unless => "pear list -c pear.drush.org | awk '{print $1}' | grep ^drush",
	}

	#drush dependency
	exec {"install_console_table":
		command => "pear install Console_Table",
		require => Package['php-pear'],
		unless => "pear list | grep Console_Table",
	}
}
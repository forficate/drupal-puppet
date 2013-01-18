class truth::enforcer {
	Exec["apt-update"] -> Package <| |>

	exec { "apt-update":
        command => "/usr/bin/apt-get update"
    }

    if has_role("drupal_stack") {
        notice("I am a fully fledged drupal stack baby")
        include secured
        include nginx::php

        class { 'mysql::server':
            config_hash => { 'root_password' => 'changeme' }
        }
    }


}
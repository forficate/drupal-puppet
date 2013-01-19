class drupal_stack {
    include secured
    include nginx::php

    class { 'mysql::server':
        config_hash => { 'root_password' => 'changeme' }
    }
}
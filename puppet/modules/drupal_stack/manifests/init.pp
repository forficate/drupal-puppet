class drupal_stack {
    include secured
    include nginx::php
    include drush

    class { 'mysql::server':
        config_hash => { 'root_password' => 'changeme' }
    }
}
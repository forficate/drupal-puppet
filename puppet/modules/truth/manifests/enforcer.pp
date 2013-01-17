class truth::enforcer {
	
	if has_role("drupal_stack") {
	  notice("I am a fully fledged drupal stack baby")
	  include nginx::php

	  class { 'mysql::server':
      	config_hash => { 'root_password' => 'changeme' }
      }
      
	}


}
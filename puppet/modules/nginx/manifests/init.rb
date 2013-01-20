hostclass :nginx do
	scope.find_resource_type 'website'

	package :nginx,  :ensure => :installed

	service :nginx,
		:ensure     => :running,
		:subscribe  => 'Package[nginx]',
		:require    => 'Package[nginx]'


 	file '/etc/nginx/nginx.conf',
	    :source => "puppet:///modules/nginx/nginx.conf",
	    :owner => 'root',
	    :group => 'root',
	    :mode => '644',
	    :require => 'Package[nginx]',
	    :notify => 'Service[nginx]'

	file '/var/www',
		:ensure => "directory",
		:owner 	=> "www-data",
		:group  => "www-data",
		:mode   => '2775',
		:require => 'Package[nginx]'
  	

	#Dynamicaly create vhosts from /etc/websites dir	
	if File.exist? "/etc/websites"
		file = File.new("/etc/websites", "r")

		while (line = file.gets)
		    parts = line.split(/ /)
		    website parts.shift, {'aliases' => parts.join(' ').strip}
		end
	end

end
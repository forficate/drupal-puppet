module Puppet::Parser::Functions
    newfunction(:ubuntupass, :type => :rvalue) do |args|
    	cmd="mkpasswd -m sha-512 #{args[0]}"
    	%x[#{cmd}]  
    end
end
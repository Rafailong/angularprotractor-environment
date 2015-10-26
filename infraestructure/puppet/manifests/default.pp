Exec {
	path => [ "/bin/", "/sbin/" , "/usr/bin/", "/usr/sbin/" ]
}

# = Class: nodejs
#
# Author: Rafael Avila <rafa.avim@gmail.com>
class nodejs () {
    # puppet code

    $dependencies = ['python', 'g++', 'make', 'checkinstall']

	package {
	    $dependencies:
	        ensure      => installed,
	}

	file {
	    '/usr/lib/nodejs':
	        ensure 		=> directory,
	        owner 		=> 'root',
	}

	file {
	    '/tmp/nodejs':
	    	require 	=> File['/usr/lib/nodejs'],
	        ensure 		=> "directory",
	        owner   	=> 'root',
	}

	exec {
	    'downloadNodeJs':
	    	require		=> File['/tmp/nodejs'],
	    	cwd			=> '/tmp/nodejs',
	        command     => 'wget -N http://nodejs.org/dist/v0.10.22/node-v0.10.22-linux-x64.tar.gz',
	        user   		=> 'root',
	        group   	=> 'root',
	        timeout 	=> 0,

	}

	exec {
	    'unpackNode':
	    	require		=> Exec['downloadNodeJs'],
	    	cwd			=> '/tmp/nodejs',
	        command     => 'tar xzvf node-v0.10.22-linux-x64.tar.gz -C /usr/lib/nodejs',
	        user  		=> 'root',
	        group   	=> 'root',
	}

	exec {
	    'addingNodeToPATH':
	    	require		=> Exec['unpackNode'],
	    	cwd	 		=> '/home/vagrant',
	        command     => 'cat /files/pathVariables >> .bashrc',
	        user  		=> 'root',
	        group   	=> 'root',
	}
}

# = Class: installNPMGlobalPackages
#
# Author: Rafael Avila <rafa.avila@gmail.com>
class installNPMGlobalPackages () {
    # puppet code

    require nodejs

    exec {
        'installPhantomJSGlobal':
            cwd        => '/usr/lib/nodejs/node-v0.10.22-linux-x64/bin',
            command     => 'sudo ./npm install -g phantomjs',
            user        => 'root',
            group       => 'root',
    }

    exec {
        'installProtractorGlobal':
            cwd         => '/usr/lib/nodejs/node-v0.10.22-linux-x64/bin',
            command     => 'sudo ./npm install -g protractor@0.14.0',
            user        => 'root',
            group       => 'root',
    }

    exec {
        'installSelenium-webdriverGlobal':
            cwd         => '/usr/lib/nodejs/node-v0.10.22-linux-x64/bin',
            command     => 'sudo ./npm install -g selenium-webdriver',
            user        => 'root',
            group       => 'root',
    }

    exec {
        'installJasmine-reportersLocally':
            cwd         => '/vagrant/tests',
            command     => 'sudo /usr/lib/nodejs/node-v0.10.22-linux-x64/bin/npm install jasmine-reporters',
            user        => 'root',
            group       => 'root',
    }
}

# = Class: nginx
#
# Author: Rafael Avila <rafa.avila@gmail.com>
class nginx () {
    # puppet code

    require nodejs
    
    # install nginx package
    package { 
        'nginx':
        ensure => installed,
    }

    service { 
        'nginx':
        # require     => Exec['setNginXNewConfiguration'],
        ensure      => running,
        enable      => true
    }
}

# = Class: selenium
#
# Author: Name Surname <name.surname@mail.com>
class selenium {
    # puppet code

    file {
        'selenium':
            ensure  => directory,
            path 	=> '/selenium',
            owner   => 'root',
            group   => 'root',
    }

    exec {
        'donwloadSelenium':
        	require 	=> File['selenium'],
        	cwd 		=> '/selenium',
            command     => 'wget --no-check-certificate https://selenium.googlecode.com/files/selenium-server-standalone-2.38.0.jar',
            user 		=> 'root',
            group 		=> 'root',
            timeout 	=> 0,
    }
}

# = Class: tweakProtractor
#
# Author: Name Surname <name.surname@mail.com>
class tweakProtractor {
    # puppet code

    require installNPMGlobalPackages

    exec {
        'removeProtactorJs':
            cwd         => '/usr/lib/nodejs/node-v0.10.22-linux-x64/lib/node_modules/protractor/lib',
            command     => 'sudo rm protractor.js',
            logoutput   => on_failure,
            user        => root,
            group       => root,
    }

    exec {
        'replaceProtractorJs':
            require     => Exec['removeProtactorJs'],
            cwd         => '/usr/lib/nodejs/node-v0.10.22-linux-x64/lib/node_modules/protractor/lib',
            command     => 'sudo cp /vagrant/protractor.js protractor.js',
            logoutput   => on_failure,
            user        => root,
            group       => root,
    }
}

exec { "aptgetupdate":
  user      => root,
  group     => root,
  command   => "apt-get update"
}

include nodejs

include installNPMGlobalPackages

include tweakProtractor

include nginx
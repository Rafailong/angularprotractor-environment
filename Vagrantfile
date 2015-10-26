# -*- mode: ruby -*-
# vi: set ft=ruby :

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  
  config.vm.box = "Debian72VB43"

  config.vm.box_url = "https://dl.dropboxusercontent.com/u/197673519/debian-7.2.0.box"

  config.vm.provider "virtualbox" do |v|
    v.customize ["modifyvm", :id, "--memory", "1024"]
  end

  # config.vm.network "public_network", :bridge => 'en0: Ethernet'
  config.vm.network "public_network" #, :bridge => 'en1: Wi-Fi (AirPort)'

  # node app port
  config.vm.network :forwarded_port, guest: 80, host: 3000
  config.vm.network :forwarded_port, guest: 4444, host: 4444

  config.vm.synced_folder "infraestructure/puppet/files", "/files"
  
  config.vm.provision :puppet do |puppet|
    puppet.manifests_path = "infraestructure/puppet/manifests"
    puppet.manifest_file  = "default.pp"
    #puppet.options = ["--fileserverconfig=infraestructure/puppet/files/fileserver.conf"]
  end
end

# -*- mode: ruby -*-
# vi: set ft=ruby :

require 'yaml'

vagrant_vars = YAML.load_file('provisioning/vagrant-vars.yml')

app_name = "web-server"

host_tcp_port = ENV["VM_HOST_TCP_PORT"] || 8888
guest_tcp_port = 80

# By default this VM will use 1 processor core and 1GB of RAM. The 'VM_CPUS' and
# "VM_RAM" environment variables can be used to change that behaviour.
cpus = ENV["VM_CPUS"] || 1
ram = ENV["VM_RAM"] || 1024

Vagrant.configure(2) do |config|

  # 'Vagrantfile.local' should be excluded from version control.
  # if File.exist? "Vagrantfile.local"
  #   instance_eval File.read("Vagrantfile.local"), "Vagrantfile.local"
  # end
  
  app_directory = ENV["VM_HOST_DIR"]
  
  config.vm.box = "inclusivedesign/centos7"
  
  # The following shared folder is required for provisioning purposes.
  config.vm.synced_folder ".", "/srv"  
  
  # The /srv/www path is being used so that the web server can access the content being synced from
  # the host. Other IDI Vagrant projects use the /home/vagrant/sync location but that would require
  # extra configuration in this case to accommodate the web server would require making the default
  # 0700 permissions for /home/vagrant more lax.
  config.vm.synced_folder "#{app_directory}", "/srv/www"

  # Port forwarding takes place here. The 'guest' port is used inside the VM
  # whereas the 'host' port is used by your host operating system.
  config.vm.network "forwarded_port", guest: guest_tcp_port, host: host_tcp_port, protocol: "tcp",
    auto_correct: true

  config.vm.hostname = app_name

  config.vm.provider :virtualbox do |vm|
    vm.customize ["modifyvm", :id, "--memory", ram]
    vm.customize ["modifyvm", :id, "--cpus", cpus]
  end

  config.vm.provision "shell", inline: <<-SHELL
    sudo ansible-galaxy install -fr /vagrant/provisioning/requirements.yml
    sudo PYTHONUNBUFFERED=1 ansible-playbook /vagrant/provisioning/vagrant.yml --tags="install,configure,deploy"
    ln -s /srv/www /home/vagrant/sync
  SHELL

end

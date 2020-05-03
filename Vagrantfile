# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  # config.vm.box = "bento/ubuntu-18.04"
  config.vm.box = "generic/ubuntu-18.04"
  # config.vm.box_check_update = true

  vm_name = "openstack-client"

  config.vm.hostname = vm_name

  #  config.vm.provider "parallels" do |prl|  
  #   prl.name = vm_name
  #
  #   prl.update_guest_tools = true
  #   prl.check_guest_tools = false
  #
  #   prl.memory = 1024
  #   prl.cpus = 2
  # end

  config.vm.provider "virtualbox" do |vb|
    vb.name = vm_name

    vb.memory = "1024"
    vb.cpus = 2
  end

  config.vm.provision "shell", path: "config/provision.sh"
end

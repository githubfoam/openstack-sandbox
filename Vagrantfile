# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|

  config.vm.define "master" do |m|
    m.vm.box = "centos/7"
    m.vm.network "public_network", use_dhcp_assigned_default_route: true, bridge: "enp3s0"
    m.vm.provider "virtualbox" do |vb|
      vb.memory = 6048
      vb.cpus = 2
    end
    m.vm.provision "file", source: "ifcfg-eth1", destination: "/tmp/ifcfg-eth1"
    m.vm.provision "file", source: "ifcfg-br-ex", destination: "/tmp/ifcfg-br-ex"
    m.vm.provision "shell", path: "./provision.sh"
  end

end

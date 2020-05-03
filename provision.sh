#!/bin/bash

echo "### Update packages ###"
sudo yum update -y

echo "### Install packages ###"
sudo yum install -y centos-release-openstack-stein
sudo yum install -y openstack-packstack

echo "### Stop services ###"
sudo systemctl stop NetworkManager
sudo systemctl disable NetworkManager

echo "### Stop services ###"
sudo systemctl stop firewalld
sudo systemctl disable firewalld
sudo sed -i --follow-symlinks 's/SELINUX=enforcing/SELINUX=disabled/g' /etc/sysconfig/selinux

echo "### Install packstack ##"
sudo packstack --allinone --provision-demo=n --os-neutron-ovs-bridge-mapping=extnet:br-ex --os-neutron-ml2-type-drivers=vxlan,flat --os-heat-install=y

echo "### Move files ###"
sudo mv /tmp/ifcfg-eth1 /etc/sysconfig/network-scripts/ifcfg-eth1
sudo mv /tmp/ifcfg-br-ex /etc/sysconfig/network-scripts/ifcfg-br-ex

echo "## Restart network ##"
service network restart

echo "### Data ###"
sudo cat /root/keystonerc_admin

echo "### Reiniciando ###"
sudo reboot

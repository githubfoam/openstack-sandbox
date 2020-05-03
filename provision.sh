#!/bin/bash

set -e

echo "##### Adding additional disk"
DATA_DISK=sdb
DATA_DIR=/opt/stack
sudo mkdir -p ${DATA_DIR}
grep -q ${DATA_DISK}1 /proc/partitions || ( sudo parted -s /dev/$DATA_DISK mklabel msdos && sudo parted -s /dev/$DATA_DISK mkpart primary 512 100% && sudo mkfs.ext4 /dev/${DATA_DISK}1 )
grep -q ${DATA_DISK}1 /etc/fstab || echo "/dev/${DATA_DISK}1 ${DATA_DIR} ext4 defaults 0 0" | sudo tee /etc/fstab
grep -q ${DATA_DIR} /proc/mounts || sudo mount ${DATA_DIR}

echo "##### Work around local dns on generic images (rabbitmq doesn't start else)"
# see https://github.com/lavabit/robox/issues/35
sudo sed -i 's/allow-hotplug eth0/auto eth0/ ; /^dns-nameserver/d ; /^pre-up sleep 2$/d' /etc/network/interfaces && sudo systemctl restart networking
sudo sed -i -e "/$(hostname)/d" /etc/hosts
echo "${HOST_IP} $(hostname -f) $(hostname -s).localdomain $(hostname -s)" | sudo tee /etc/hosts

echo "##### install prerequisites"
sudo apt-get install bridge-utils

echo "##### prepare and run OpenStack provisioning"
# note: currently using latest as ocata gave "No module named openstack_auth"
# note that the branch needs to be specified inside local.conf for plugins etc also!
test -d devstack || git clone -b ${BRANCH:-master} ${GIT_BASE:-http://note-apple-039:8888}/openstack/devstack.git
#git clone https://git.openstack.org/openstack-dev/devstack
#git clone -b stable/ocata https://git.openstack.org/openstack-dev/devstack

cp /vagrant/devstack/local.conf devstack/local.conf

# actuall devstack / openstack provisioning
./devstack/stack.sh

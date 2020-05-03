# -*- mode: ruby -*-
# vi: set ft=ruby :

DATA_DISK_SIZE_GB = 64
DATA_DISK_DIR = "#{ENV['HOME']}/.vagrant.d/vagrant-additional-disk-openstack"
MEM = 8192
CPUS = 2
HOST_IP = "192.168.33.10" # ip of this VM in the private net
GW_IP = "192.168.33.1" # IP of phys. host
GIT_BASE = "http://#{GW_IP}:8888"
OS_VERSION = "stable/rocky"

Vagrant.configure("2") do |config|
  if Vagrant.has_plugin?("vagrant-cachier")
    config.cache.scope = :box
    config.cache.enable :generic, {
      "http" => { :cache_dir => "/root/.cache/pip/http" },
      "wheels" => { :cache_dir => "/root/.cache/pip/wheels" },
    }
  end

  config.vm.define "openstack" do |openstack|

    openstack.vm.synced_folder ".", "/vagrant", type: "rsync", rsync__exclude: ".*/"

    openstack.vm.network "private_network", ip: HOST_IP

    # we go for the generic image that is available for many providers
    # be aware of hard coded public dns servers
    openstack.vm.box = "generic/ubuntu1604"

    openstack.vm.provider "virtualbox" do |vb|
      # TODO: add second disk analogue to the vmware impl

      vb.memory = MEM
      vb.cpus = CPUS
    end

    openstack.vm.provider "vmware_desktop" do |vd|

      vd.vmx["memsize"] = MEM
      vd.vmx["numvcpus"] = CPUS

      vd.vmx["virtualhw.version"] ="8"
      vd.vmx['hv.assumeEnabled'] = "TRUE"
      vd.vmx['vhv.enable'] = "TRUE"
      vd.vmx['allowNested'] = "TRUE"

      vdiskmanager = '/Applications/VMware\ Fusion.app/Contents/Library/vmware-vdiskmanager'

      unless File.directory?( DATA_DISK_DIR )
          Dir.mkdir DATA_DISK_DIR
      end

      file_to_disk = "#{DATA_DISK_DIR}/var-lib-libvirt.vmdk"

      unless File.exists?( file_to_disk )
          `#{vdiskmanager} -c -s #{DATA_DISK_SIZE_GB}GB -a lsilogic -t 1 #{file_to_disk}`
      end

      vd.vmx['scsi0:1.filename'] = file_to_disk
      vd.vmx['scsi0:1.present']  = 'TRUE'
      vd.vmx['scsi0:1.redo'] = ''

      openstack.trigger.after :destroy do |trigger|
        trigger.info = "Removing data disk..."
        trigger.run = { inline: "rm -rf #{DATA_DISK_DIR}" }
      end
    end

    openstack.vm.provision "shell", privileged: false, path: "provision.sh", env: { "HOST_IP" => HOST_IP, "GIT_BASE" => GIT_BASE, "BRANCH" => OS_VERSION }
  end
end

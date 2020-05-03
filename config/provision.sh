
echo "Install Base Packages"
apt-get -qq update
DEBIAN_FRONTEND=noninteractive \
    apt-get install -qq -y \
        python3-dev \
        python3-pip \
        unzip

# Make Python3 default
echo "Make python3 default"
update-alternatives --install /usr/bin/python python /usr/bin/python3 1
update-alternatives --install /usr/bin/pip pip /usr/bin/pip3 1

update-alternatives --set python /usr/bin/python3
update-alternatives --set pip /usr/bin/pip3

# OpenStack Install
echo "pip install openstack client"
pip -q install --upgrade python-openstackclient

echo "pip install openstack sdk"
pip -q install --upgrade openstacksdk

# Install Terraform
export TF_VER="0.12.24"
echo "Install Terraform (${TF_VER})"
rm -f /usr/local/bin/terraform
wget https://releases.hashicorp.com/terraform/${TF_VER}/terraform_${TF_VER}_linux_amd64.zip \
    -O /tmp/terraform.zip \
    -qq
unzip -qq /tmp/terraform.zip -d /usr/local/bin
rm -f /tmp/terraform.zip

# Install default profiles
echo "Install profile files"
cp -f /vagrant/config/openstack.profile.sh \
    /etc/profile.d/Z80-openstack.profile.sh

cp -f /vagrant/config/terraform.profile.sh \
    /etc/profile.d/Z81-terraform.profile.sh

# Write default example configuration files
OPENSTACK_LOCAL_CONFIG=/vagrant/config/openstack.local.sh

if [[ -f $OPENSTACK_LOCAL_CONFIG ]]; then
    echo "Openstack Local Config exists, omit"
    echo "You'll have to delete the file to recreate: "
    echo " - $OPENSTACK_LOCAL_CONFIG"
else
echo "Install local: $OPENSTACK_LOCAL_CONFIG"
echo -n '# OpenStack Local Configuration
export OS_AUTH_URL=""
export OS_PROJECT_ID=""
export OS_PROJECT_NAME=""
export OS_USER_DOMAIN_NAME=""
export OS_PROJECT_DOMAIN_ID=""
export OS_USERNAME=""
export OS_PASSWORD=""
export OS_REGION_NAME=""
' > $OPENSTACK_LOCAL_CONFIG
fi

TERRAFORM_LOCAL_CONFIG=/vagrant/config/terraform.local.sh

if [[ -f $TERRAFORM_LOCAL_CONFIG ]]; then
    echo "Terraform Local Config exists, omit"
    echo "You'll have to delete the file to recreate: "
    echo " - $TERRAFORM_LOCAL_CONFIG"
else
echo "Install local: $TERRAFORM_LOCAL_CONFIG"
echo -n '# Terraform Local Configuration
# export TF_LOG=TRACE
# export TF_LOG_PATH=/vagrant/log/terraform.log

# Default for openstack provider
# export TF_VAR_openstack_user=$OS_USERNAME
# export TF_VAR_openstack_password=$OS_PASSWORD
# export TF_VAR_openstack_tenant=$OS_PROJECT_NAME
' > $TERRAFORM_LOCAL_CONFIG
fi

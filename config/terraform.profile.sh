export TF_LOG=TRACE
export TF_LOG_PATH=/vagrant/log/terraform.log

export TF_VAR_openstack_user=$OS_USERNAME
export TF_VAR_openstack_password=$OS_PASSWORD
export TF_VAR_openstack_tenant=$OS_PROJECT_NAME

export TF_CONFIG_FILE="/vagrant/config/terraform.local.sh"

if [[ -f  $TF_CONFIG_FILE ]]; then
    . $TF_CONFIG_FILE
fi

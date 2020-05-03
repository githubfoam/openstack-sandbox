export OS_AUTH_URL=""
export OS_PROJECT_ID=""
export OS_PROJECT_NAME=""
export OS_USER_DOMAIN_NAME=""
export OS_PROJECT_DOMAIN_ID=""
export OS_USERNAME=""
export OS_PASSWORD=""
export OS_REGION_NAME=""

OS_CONFIG_FILE="/vagrant/config/openstack.local.sh"

if [[ -f $OS_CONFIG_FILE ]]; then
    . $OS_CONFIG_FILE
fi

if [ -z "$OS_USER_DOMAIN_NAME" ]; then 
    unset OS_USER_DOMAIN_NAME
fi

if [ -z "$OS_PROJECT_DOMAIN_ID" ]; then
    unset OS_PROJECT_DOMAIN_ID
fi

if [ -z "$OS_REGION_NAME" ]; then
    unset OS_REGION_NAME
fi

export OS_INTERFACE=public
export OS_IDENTITY_API_VERSION=3

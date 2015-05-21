#!/bin/bash


cat <<EOF > terraform.tfvars
network = "192.168"
auth_url="${AUTH_URL}"
tenant_name="${TENANT_NAME}"
tenant_id="${TENANT_ID}"
username="${OPENSTACK_USERNAME}"
password="${OPENSTACK_PASSWORD}"
public_key_path="fix-ssh-key-permission/robots.pub"
key_path="fix-ssh-key-permission/robots"
floating_ip_pool="${FLOATING_IP_POOL}"
region="RegionOne"
network_external_id="${NETWORK_EXTERNAL_ID}"
install_docker_services="true"
http_proxy="${HTTP_PROXY}"
https_proxy="${HTTPS_PROXY}"
cf_boshworkspace_version="${CF_BOSHWORKSPACE_VERSION}"
EOF

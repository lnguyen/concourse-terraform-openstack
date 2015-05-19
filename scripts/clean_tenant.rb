#!/usr/bin/env ruby

compute = Fog::Compute.new({
    :provider            => 'openstack',                                      # OpenStack Fog provider
    :openstack_auth_url  => ENV['OS_AUTH_URL'], # OpenStack Keystone endpoint
    :openstack_username  => ENV['OS_USERNAME'],                                  # Your OpenStack Username
    :openstack_tenant    => ENV['OS_TENANT_NAME'],                                # Your tenant id
    :openstack_api_key   => ENV['OS_PASSWORD'],                              # Your OpenStack Password
    :connection_options  => {}                                                # Optional
})

# Delete servers
compute.servers.each { |server| server.destroy }

# Delete security groups but default
compute.security_groups.reject { |sg| sg.name == "default" }.each { |sg| sg.destroy }

# Delete Keypair
compute.key_pairs.select{ |kp| kp.name == "bastion-keypair-#{ENV['OS_TENANT_NAME']}" }.each { |kp| kp.destroy }

# Delete Volumes
compute.volumes.each { |vol| vol.destroy }

# Delete floating ips
compute.addresses.each{ |address| address.destroy }

# Delete images
compute.images.select{ |image| image.name =~ /BOSH-.*/}.each { |image| image.destroy }

network = Fog::Network.new({
    :provider            => 'openstack',                                      # OpenStack Fog provider
    :openstack_auth_url  => ENV['OS_AUTH_URL'], # OpenStack Keystone endpoint
    :openstack_username  => ENV['OS_USERNAME'],                                  # Your OpenStack Username
    :openstack_tenant    => ENV['OS_TENANT_NAME'],                                # Your tenant id
    :openstack_api_key   => ENV['OS_PASSWORD'],                              # Your OpenStack Password
    :connection_options  => {}                                                # Optional
})

# Clean up router
# Shell out and I feel bad but only way I could figure out
# at time.
# Sorry,
# Past Long
network.routers.each do |router|
  `neutron router-gateway-clear #{router.id}`
  router.destroy
end

# Clear out ports
network.ports.each { |port| port.destroy }

# Clear out subnets
network.subnets.each { |subnet| subnet.destroy }

# Clear out networks
network.networks.each { |network| network.destroy }

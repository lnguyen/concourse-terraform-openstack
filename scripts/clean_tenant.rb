#!/usr/bin/env ruby

require 'fog'

compute = Fog::Compute.new({
    :provider            => 'openstack',
    :openstack_auth_url  => "#{ENV['OS_AUTH_URL']}/tokens",
    :openstack_username  => "#{ENV['OS_USERNAME']}",
    :openstack_tenant    => "#{ENV['OS_TENANT_NAME']}",
    :openstack_api_key   => "#{ENV['OS_PASSWORD']}",
    :connection_options  => {}
})

# Delete servers
puts "Cleaning out servers"
compute.servers.each { |server| puts "Deleting server with name #{server.name}"; server.destroy }

# Delete security groups but default
puts "Cleaning out security groups"
compute.security_groups.reject { |sg| sg.name == "default" }.each { |sg| puts "Deleting security group with name: #{sg.name}"; sg.destroy }

# Delete Keypair
puts "Cleaning out keypairs"
compute.key_pairs.select{ |kp| kp.name == "bastion-keypair-#{ENV['OS_TENANT_NAME']}" }.each { |kp| puts "Deleting keypair with name #{kp.name}"; kp.destroy }

# Delete Volumes
puts "Cleaning out volumes"
compute.volumes.each { |vol| puts "Deleting volume with name #{vol.name}"; vol.destroy }

# Delete floating ips
puts "Cleaning out floating ips"
compute.addresses.each{ |address| puts "Deleting floating ip with name #{address.name}"; address.destroy }

# Delete images
puts "Cleaning out images"
compute.images.select{ |image| image.name =~ /BOSH-.*/}.each { |image| puts "Deleting image with name #{image.name}"; image.destroy }

network = Fog::Network.new({
  :provider            => 'openstack',
  :openstack_auth_url  => "#{ENV['OS_AUTH_URL']}/tokens",
  :openstack_username  => "#{ENV['OS_USERNAME']}",
  :openstack_tenant    => "#{ENV['OS_TENANT_NAME']}",
  :openstack_api_key   => "#{ENV['OS_PASSWORD']}",
  :connection_options  => {}
})

puts "Cleaning out ports"
# Clear out ports
network.ports.select{ |port| port.device_owner == "network:router_interface"}.each do |port|
  port.fixed_ips.each do |subnet|
    network.remove_router_interface(port.device_id,subnet["subnet_id"])
  end unless port.fixed_ips.empty?
end


# Clean up router
# Shell out and I feel bad but only way I could figure out
# at time.
# Sorry,
# Past Long
puts "Cleaning out routers"
network.routers.each do |router|
  `neutron router-gateway-clear #{router.id}`
  router.destroy
end

# Clear out subnets
puts "Cleaning out subnets"
network.subnets.each { |subnet| puts "Deleting subnet with naem #{subnet.name}"; subnet.destroy }

# Clear out networks
puts "Cleaning out networks"
network.networks.reject{ |network| network.name == "net04_ext"}.each { |network| puts "Deleting network with name #{network.name}"; network.destroy }

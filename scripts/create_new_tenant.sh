#!/bin/bash


new_tenant=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 8 | head -n 1)

openstack project create concourse-$new_tenant

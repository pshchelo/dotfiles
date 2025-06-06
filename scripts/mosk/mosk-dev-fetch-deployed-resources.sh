#!/usr/bin/env bash
kubectl -n openstack get osdpl osh-dev -oyaml > deployed.osdpl.yaml
# TODO: automate cleanup of osdpl yaml
# remove status and all metadata except name and namespace
cp deployed.osdpl.yaml osdpl.yaml
# mcc-deployed envs have the helmbundle for the operator in the mgmt cluster, 
# so ignore not found and delete empty file
kubectl -n osh-system get helmbundles.lcm.mirantis.com openstack-operator \
    --ignore-not-found=true -oyaml > deployed.osctl.yaml
if [ ! -s deployed.osctl.yaml ]; then
    rm deployed.osctl.yaml
fi

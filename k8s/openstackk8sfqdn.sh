#!/usr/bin/env bash

ingress_cluster_ip=$(kubectl -n openstack get svc ingress -ojsonpath='{.spec.clusterIP}')
for svc in keystone glance cinder nova neutron horizon designate placement octavia heat cloudformation barbican; do
    echo "${ingress_cluster_ip} ${svc}.it.just.works" >> /etc/hosts
done

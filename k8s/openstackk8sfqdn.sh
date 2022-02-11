#!/usr/bin/env bash

ingress_lb_ip=$(kubectl -n openstack get svc ingress -ojsonpath='{.status.loadBalancer.ingress[0].ip}')
ingress_cluster_ip=$(kubectl -n openstack get svc ingress -ojsonpath='{.spec.clusterIP}')
for svc in $(kubectl -n openstack get ingress -ojsonpath='{.items[*].spec.rules[*].host}'); do
    echo "${ingress_lb_ip} ${svc}"
    #sudo echo "${ingress_cluster_ip} ${svc}"
done

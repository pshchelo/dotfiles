#!/usr/bin/env bash

ingress_lb_ip=$(kubectl -n openstack get svc ingress -ojsonpath='{.status.loadBalancer.ingress[0].ip}')
ingress_cluster_ip=$(kubectl -n openstack get svc ingress -ojsonpath='{.spec.clusterIP}')
echo "" >> /etc/hosts
echo "# openstack-on-k8s services" >> /etc/hosts
for svc in $(kubectl -n openstack get ingress |awk '/cluster-fqdn/ {print $3}'); do
    echo "${ingress_lb_ip} ${svc}" >> /etc/hosts
    #echo "${ingress_cluster_ip} ${svc}" >> /etc/hosts
done
echo "# end of openstack services" >> /etc/hosts

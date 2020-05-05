#!/usr/bin/env bash

ingress_cluster_ip=$(kubectl -n openstack get svc ingress -ojsonpath='{.spec.clusterIP}')
echo "" >> /etc/hosts
echo "# openstack-on-k8s services" >> /etc/hosts
for svc in $(kubectl -n openstack get ingress |awk '/cluster-fqdn/ {print $2}'); do
    echo "${ingress_cluster_ip} ${svc}" >> /etc/hosts
done
echo "# end of openstack services" >> /etc/hosts

#!/usr/bin/env bash

cluster=$1
role=${2:-}
realm=${KAAS_REALM:-imc-oscore-team}
context=${KAAS_CONTEXT:-pshchelokovskyy@kaas}
cluster=`kubectl --context ${context} -n ${realm} get machine -l cluster.k8s.io/cluster-name=${cluster} -ojson`
if [ -z $role ]; then
    echo $cluster | jq '.items[].metadata | {name: .name, ip: .annotations."openstack-ip-address", role: .labels.set, id: .annotations."openstack-resourceId"}'
else
    echo $cluster | jq -r ".items[].metadata | select(.labels.set==\"$role\") | .annotations.\"openstack-ip-address\""
fi

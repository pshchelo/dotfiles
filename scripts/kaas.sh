#!/usr/bin/env bash

cluster=$1
project=${2:-oscore-team}
context=${3:-pshchelokovskyy@kaas}
kubectl --context ${context} -n imc-${project} get machine -l cluster.k8s.io/cluster-name=${cluster} -ojson | jq '.items[].metadata | {name: .name, ip: .annotations."openstack-ip-address", role: .labels.set, id: .annotations."openstack-resourceId"}'

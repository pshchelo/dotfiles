#!/usr/bin/env bash
set -e

function print_help {
    echo "$0 - operations on KaaS cluster"
    echo "Usage: $0 CLUSTER_NAME [--list|--ssh]"
    echo "ENV vars: KAAS_REALM, KAAS_CONTEXT, KAAS_PRIVATE_KEY"
}

function ssh_to_master_node {
    node_ip=$(${kubecmd} get machine -l cluster.sigs.k8s.io/cluster-name=${cluster} -ojson | jq -r '.items[].metadata | select(.labels."cluster.sigs.k8s.io/control-plane"=true) | .annotations."openstack-ip-address"' | head -n1)
    if [ -z $node_ip ]; then
        echo "No control plane nodes found for cluster $cluster"
        exit 1
    fi
    ssh -i ${ssh_key} ubuntu@$node_ip
}

function list_cluster_nodes {
    ${kubecmd} get machine -l cluster.sigs.k8s.io/cluster-name=${cluster} -ojson | \
        jq '.items[].metadata | {name: .name, "control-plane": .labels."cluster.sigs.k8s.io/control-plane", "instance-id": .annotations."openstack-resourceId", "kaas-node": ("kaas-node-" + .annotations."kaas.mirantis.com/uid"), ip: .annotations."openstack-ip-address"}'
}


realm=${KAAS_REALM:-imc-oscore-team}
context=${KAAS_CONTEXT:-pshchelokovskyy@kaas}
ssh_key=${KAAS_PRIVATE_KEY:-"~/.ssh/aio_rsa"}
kubecmd="kubectl --context ${context} -n ${realm}"

cluster=$1
if [ -z $cluster ]; then
    print_help
    exit 1
fi

shift
case $1 in
    "--ssh")
        shift
        ssh_to_master_node $*
        ;;
    "--list")
        shift
        list_cluster_nodes
        ;;
    *)
        print_help
        exit 1
esac

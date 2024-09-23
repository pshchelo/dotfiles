#!/usr/bin/env bash
# Preparations to work with fresh MOSK virtual dev cluster
RED='\033[0;31m'
NOC='\033[0m'

if [ -z "$1" ]; then
    echo "need deploy-openstack-k8s-env job number"
    exit 1
fi
echo "Get kubeconfig for the env"
wget "https://mos-ci.infra.mirantis.net/job/deploy-openstack-k8s-env/$1/artifact/kubeconfig-child-cluster.yml" -O kubeconfig.yaml
echo "Edit kubeconfig for the env"
~/dotfiles/scripts/mosk/mosk-dev-config-rename-context.sh kubeconfig.yaml
echo -e "${RED}START mosk-dev-connect in a separate shell NOW${NOC}"
echo "Create local copies of deployed resources"
~/dotfiles/scripts/mosk/mosk-dev-fetch-deployed-resources.sh
echo "Cleanup 'complete' pods"
~/dotfiles/scripts/k8s/k8s-cleanup-pods.sh -A
# the next command needs mosk-dev-connect running,
# but it will pause if that is not running yet
echo "Create my default test env users and infra"
~/dotfiles/scripts/mosk/mosk-dev-create-resources.sh

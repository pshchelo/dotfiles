#!/usr/bin/env bash
new_ip_with_cidr="${1}"
docker_br=${2:-"docker0"}
docker_daemon_config=/etc/docker/daemon.json
current_bridge_ip=$(ip -br -f inet addr show dev "$docker_br" | awk '{print $3}')
sudo systemctl stop docker.service
sudo ip link set dev "$docker_br" down
sudo ip addr del "$current_bridge_ip" dev "$docker_br"
if [ -f "$docker_daemon_config" ]; then
    sudo cp "$docker_daemon_config" "${docker_daemon_config}.bak"
fi
echo "{\"bip\": \"$new_ip_with_cidr\"}" | sudo tee $docker_daemon_config
sudo ip addr add "$new_ip_with_cidr" dev "$docker_br"
sudo ip link set dev "$docker_br" up
sudo systemctl start docker.service

# TODO: also set the default address pool so that new networks are created from this net range
# {"bip": "192.168.0.1/24","default-address-pools": [{"base": "192.168.128.0/17","size": 24}]}

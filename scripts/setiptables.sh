#!/usr/bin/env sh
myip=$(hostname -i)
# DEVSTACK
# ssh do the devstack host
iptables -t nat -I PREROUTING -p tcp -d $myip --dport 2127 -j DNAT --to-destination 192.168.100.127:22
# Horizon access to the devstack host
iptables -t nat -I PREROUTING -p tcp -d $myip --dport 8127 -j DNAT --to-destination 192.168.100.127:80
# noVNC console access in Horizon
iptables -t nat -I PREROUTING -p tcp -d $myip --dport 6127 -j DNAT --to-destination 192.168.100.127:6080
# xvpVNC tunnel
iptables -t nat -I PREROUTING -p tcp -d $myip --dport 7127 -j DNAT --to-destination 192.168.100.127:6081


iptables -I FORWARD -m state -d 192.168.100.0/24 --state NEW,RELATED,ESTABLISHED -j ACCEPT

# Fuel master
#iptables -t nat -I PREROUTING -p tcp -d $myip --dport 8888 -j DNAT --to-destination 10.108.0.2:80
#iptables -I FORWARD -m state -d 10.108.0.0/24 --state NEW,RELATED,ESTABLISHED -j ACCEPT
# Fuel env 1 Public network
#iptables -t nat -I PREROUTING -p tcp -d $myip --dport 8182 -j DNAT --to-destination 10.108.1.2:80
#iptables -I FORWARD -m state -d 10.108.1.0/24 --state NEW,RELATED,ESTABLISHED -j ACCEPT

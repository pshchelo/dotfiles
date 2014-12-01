#!/usr/bin/env sh
myip=$(hostname -i)
# DevStack
iptables -t nat -I PREROUTING -p tcp -d $myip --dport 8127 -j DNAT --to-destination 192.168.100.127:80
iptables -I FORWARD -m state -d 192.168.100.0/24 --state NEW,RELATED,ESTABLISHED -j ACCEPT
# Fuel master
#iptables -t nat -I PREROUTING -p tcp -d $myip --dport 8888 -j DNAT --to-destination 10.108.0.2:80
#iptables -I FORWARD -m state -d 10.108.0.0/24 --state NEW,RELATED,ESTABLISHED -j ACCEPT
# Fuel env 1 Public network
#iptables -t nat -I PREROUTING -p tcp -d $myip --dport 8182 -j DNAT --to-destination 10.108.1.2:80
#iptables -I FORWARD -m state -d 10.108.1.0/24 --state NEW,RELATED,ESTABLISHED -j ACCEPT

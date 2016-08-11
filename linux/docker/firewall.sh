#!/bin/bash -x

csf -x
iptables -F
iptables -X
iptables -t nat -F
iptables -t nat -X
iptables -t mangle -F
iptables -t mangle -X

#export ip=`ifconfig eth0 |grep "inet" |awk  '{print $2}' | awk 'NR==1{print $1}'`

iptables -P INPUT ACCEPT
iptables -P FORWARD ACCEPT
iptables -P OUTPUT ACCEPT

iptables -A INPUT -i lo -j ACCEPT

#Allow everyone to these ports
iptables -A INPUT -p tcp -m tcp -m multiport --dports 80,443,22 -j ACCEPT

#Allow mediadb03 in
iptables -A INPUT -p tcp -s 192.168.100.0/24 -j ACCEPT


#Allow my own IP to connect to any port locally
#iptables -A INPUT -p tcp -s $ip -j ACCEPT

#Weird tcp connection stuff I dont understand
iptables -A INPUT -m conntrack -j ACCEPT  --ctstate RELATED,ESTABLISHED
iptables -A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT

#Finally, drop everyone else
iptables -A INPUT -j DROP

iptables -nL

echo "Please restart Docker process"                          

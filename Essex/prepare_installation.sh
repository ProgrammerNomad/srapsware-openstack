#!/bin/bash

# Make sure only root can run our script
if [ "$(id -u)" != "0" ]; then
   echo "You need to be 'root' dude." 1>&2
   exit 1
fi

# install time server
apt-get install ntp
service ntp restart

# modify timeserver configuration
sed -e "
/^server ntp.ubuntu.com/i server 127.127.1.0
/^server ntp.ubuntu.com/i fudge 127.127.1.0 stratum 10
/^server ntp.ubuntu.com/s/^.*$/server ntp.ubutu.com iburst/;
" -i /etc/ntp.conf

# install tgt
apt-get install tgt
service tgt start

# openiscsi-client
apt-get install open-iscsi open-iscsi-utils

# turn on forwarding
echo 1 > /proc/sys/net/ipv4/ip_forward

echo "#################################################################################################
Go edit your /etc/network/interfaces file to look something like this:

auto eth0 
iface eth0 inet static
 address 192.168.1.5
 network 192.168.1.5
 netmask 255.255.255.0
 broadcast 192.168.1.255
 gateway 192.168.1.1
 dns-nameservers 8.8.8.8 8.8.4.4

auto eth1

After you are done, do a '/etc/init.d/networking restart', then run './dynamic_updates.sh'

#################################################################################################
"


exit
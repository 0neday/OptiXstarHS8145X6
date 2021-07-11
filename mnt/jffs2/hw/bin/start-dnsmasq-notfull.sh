#!/bin/sh

if [ ! -e /var/run/dnsmasq-notfull.pid ] ;then

#	sleep 80
	ps w | grep /var/dnsmasq_br0.conf | grep -v grep | awk '{print $1}' | xargs  kill -9
	kill `pidof dnsmasq`	
#	rm -rf /var/dhcpd
	kill `pidof dhcpd`

	kill -9  `pidof dnsmasq`
	kill -9 `pidof dhcpd`
	kill -9 `pidof dhcp6s`
	killall dnsmasq

	mkdir -p /var/log/
else
	kill -9  `pidof dnsmasq`
	kill -9 `pidof dnsmasq-notfull`
	rm -rf /var/run/dnsmasq-notfull.pid 

fi

/mnt/jffs2/hw/bin/dnsmasq-notfull -C /mnt/jffs2/hw/etc/dnsmasq.conf --pid-file=/var/run/dnsmasq-notfull.pid

exit 0;

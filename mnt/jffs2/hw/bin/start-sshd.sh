#!/bin/sh

#sleep 60 

# sshd 
if [ ! -e /tmp/sshd.log ]; then

	cp -p /mnt/jffs2/hw/etc/authorized_keys /var/authorized_keys
	chmod 600 /var/authorized_keys
	mkdir -p /var/run

	mkdir -p /var/empty
	chmod 600 /var/empty
	adduser -D -H sshd       

	kill `pidof dropbear`

	/mnt/jffs2/hw/bin/sshd -f /mnt/jffs2/hw/etc/ssh/sshd_config -E /tmp/sshd.log 
	/mnt/jffs2/plug/app/bin/iptables -I INPUT -s 192.168.1.1/24 -p tcp --dport 22 -j ACCEPT
fi

exit 0;

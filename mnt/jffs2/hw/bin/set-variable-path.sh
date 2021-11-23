#!/bin/sh

# timer
iptables -I INPUT -s 192.168.1.0/24 -p udp --dport 123 -j ACCEPT

# block quic
#/mnt/jffs2/hw/bin/quic.sh &

# block google
/mnt/jffs2/hw/bin/google.sh &

# set nameserver
echo "nameserver 127.0.0.1" > /var/wan/dns

# set time
killall ntpd
sleep 1
/mnt/jffs2/plug/app/busybox/usr/sbin/ntpd -n -p 120.25.115.20 -l -N &

# cp passwd
#cp /mnt/jffs2/hw/etc/passwd  /var/passwd

# clean
sleep 1 
killall bftpd saf-huawei procmonitor easymesh

sleep 1
lxc-stop kernelapp
umount  /dev/mtdblock9
ip link del dev lxcbr0

# update cf dns
#sleep 1 
#/mnt/jffs2/hw/bin/cloudflare-update-record.sh &

# update vultr dns 
sleep 1
/mnt/jffs2/hw/bin/vultr_ddns.sh &

# clean log
echo > /mnt/jffs2/plug/apps/apps/opt/apps/ctsgw.log
echo > /mnt/jffs2/plug/apps/apps/tmp/.uci/u01.log
echo > /mnt/jffs2/plug/apps/apps/tmp/.uci/gamespeeder.log
echo > /mnt/jffs2/plug/apps/apps/var/appmgr.log

# wireguard-go 
/mnt/jffs2/hw/bin/vpn-client.sh

# rmmod ko
sleep 1 
/mnt/jffs2/hw/bin/ko-rmmod.sh

#
kill -9 `pidof 1.sdk_init.sh`

sleep 1
kill -9 `pidof dbus-daemon ctrg_m cwmp `

#sleep 30
kill -9 `pidof app_m app_sdt voice_h248sip apm wificli wifi ssmp sntp udm comm web ip6tables-restore`

exit 0;

#!/bin/sh

# set security drop 
iptables -I  INPUT -p tcp --dport 23 -j DROP
iptables -I  INPUT -s 192.168.1.0/24 -p tcp --dport 23 -j ACCEPT
iptables -I  INPUT -p tcp --dport 80 -j DROP
iptables -I  INPUT -s 192.168.1.1/24 -p tcp --dport 80 -j ACCEPT
iptables -I  INPUT -p tcp --dport 3333 -j DROP
iptables -I  INPUT -p tcp --dport 5080 -j DROP

# set nameserver 
echo "nameserver 127.0.0.1" > /var/wan/dns

# forward all data
iptables -A FWD_FIREWALL_COMMON -i br+ -j ACCEPT

# set time
killall ntpd
/mnt/jffs2/plug/app/busybox/usr/sbin/ntpd -n -p ntp1.aliyun.com -l -N &
iptables -I  INPUT -s 192.168.1.0/24 -p udp --dport 123 -j ACCEPT

# clean memory
#sleep 5 
#lxc-stop kernelapp
#killall bftpd saf-huawei procmonitor ping

sleep 120
#kill -9 `pidof cagent apm udm sntp wificli ssmp comm wifi web  bbsp amp igmp emdi cwmp omci \
#ip6tables-restore iptables-restore dbus-daemon voice_h248sip kmc app_sdt app_m cagent ctrg_m`

# clean log
echo > /mnt/jffs2/plug/apps/apps/opt/apps/ctsgw.log
echo > /mnt/jffs2/plug/apps/apps/tmp/.uci/u01.log
echo > /mnt/jffs2/plug/apps/apps/tmp/.uci/gamespeeder.log
echo > /mnt/jffs2/plug/apps/apps/var/appmgr.log

# cp passwd 
cp /mnt/jffs2/hw/etc/passwd  /var/passwd

exit 0;

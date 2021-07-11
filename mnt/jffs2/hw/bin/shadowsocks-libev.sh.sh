#!/bin/sh
SS_CONFIG_FILE=/mnt/jffs2/hw/ss.json
SS_REDIR_BIN=/mnt/jffs2/app/shadowsocks-libev-2.6.3/ss-redir
SS_TUNNEL_BIN=/mnt/jffs2/app/shadowsocks-libev-2.6.3/ss-tunnel
GFW_FILE_PATH=/mnt/jffs2/hw/etc/gfw-nat
IPTABLES_BIN=/mnt/jffs2/plug/app/bin/iptables
IPTABLES_RESTORE_BIN=/mnt/jffs2/plug/app/bin/iptables-restore
DNSFORWARD_BIN=/mnt/jffs2/plug/app/bin/dns-forwarder

SERVER_IP=`cat $SS_CONFIG_FILE |grep '"server"' | awk  -F '"' '{print $4}'`

mkdir -p /var/run/
if [ ! -e /var/run/ss-redir.pid ] ;then

	# create new nat table
	$IPTABLES_BIN -t nat -N SHADOWSOCKS

	# set iptables rule
	$IPTABLES_BIN -I INPUT -s 127.0.0.1/8 -p tcp --dport 1234 -j ACCEPT
	$IPTABLES_BIN -I INPUT -s 192.168.1.1/24 -p tcp --dport 1234 -j ACCEPT
	$IPTABLES_BIN -I INPUT -s 127.0.0.1 -p udp --dport 5353  -j ACCEPT
	$IPTABLES_BIN -I INPUT -s 192.168.1.1/24 -p udp --dport 5353  -j ACCEPT

	echo 3 > /proc/sys/net/ipv4/tcp_fastopen
else
	kill `pidof ss-redir`
	kill `pidof ss-tunnel`
	kill `pidof dns-forwarder`
	kill `pidof stunnel`

	rm -rf /var/run/ss-redir.pid
	rm -rf /var/run/ss-tunnel.pid

fi

#redir tunnel
$SS_REDIR_BIN -c $SS_CONFIG_FILE -b 192.168.1.1 -l 1234 -f /var/run/ss-redir.pid
$SS_TUNNEL_BIN -c $SS_CONFIG_FILE -b 127.0.0.1 -l 9999  -L 127.0.0.1:53 -f /var/run/ss-tunnel.pid

# dns forward
$DNSFORWARD_BIN -b 127.0.0.1 -p 5300 -s 127.0.0.1:9999 &

# flash nat table
$IPTABLES_BIN -t nat -F SHADOWSOCKS

# gfw list ip
$IPTABLES_RESTORE_BIN --table=nat  < $GFW_FILE_PATH

# server ip
$IPTABLES_BIN -t nat -I SHADOWSOCKS -d $SERVER_IP -j RETURN
$IPTABLES_BIN -I FORWARD -d $SERVER_IP -j ACCEPT

# redirect all 80/443 packets to 1234 port
$IPTABLES_BIN -t nat -A SHADOWSOCKS -p tcp -j REDIRECT --to-ports 1234
$IPTABLES_BIN -t nat -I PREROUTING -p tcp -m multiport --dports 80,443 -j SHADOWSOCKS

# redirect all other dns server to 192.168.1.1#5300, such as 114.. or 8..
$IPTABLES_BIN -t nat -N DNS
$IPTABLES_BIN -t nat -A DNS -p udp -j REDIRECT --to-ports 5353
$IPTABLES_BIN -t nat -I PREROUTING -p udp --dport 53 -j DNS

# fix time server
$IPTABLES_BIN -t nat -N TIMER
#$IPTABLES_BIN -t nat -A TIMER -d 192.168.1.1 -j RETURN
$IPTABLES_BIN -t nat -A TIMER -p udp -j REDIRECT --to-ports 123
$IPTABLES_BIN -t nat -I PREROUTING -p udp --dport 123 -j TIMER

killall ntpd
/mnt/jffs2/plug/app/busybox/usr/sbin/ntpd -n -p ntp1.aliyun.com -l -N &
$IPTABLES_BIN -I  INPUT -s 192.168.1.0/24 -p udp --dport 123 -j ACCEPT

exit 0

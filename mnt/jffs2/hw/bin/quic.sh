#!/bin/sh
BIN_DIR=/mnt/jffs2/plug/app/busybox
export PATH=$BIN_DIR/bin:$BIN_DIR/sbin:$BIN_DIR/usr/bin:$BIN_DIR/usr/sbin:/mnt/jffs2/plug/app/bin/

WG_IP=$(nslookup -type=a "yourdomain.com" | grep "Address" | awk '{print $2}' | sed -n 2p)

iptables -N QUIC
iptables -I QUIC -d $WG_IP -j ACCEPT
iptables -A QUIC -j REJECT
iptables -I FORWARD -i br+ -p udp --dport 443 -j QUIC

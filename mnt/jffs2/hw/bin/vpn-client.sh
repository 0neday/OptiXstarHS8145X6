# wireguard-go usermode
/sbin/insmod /lib/modules/4.4.197/kernel/drivers/net/tun.ko

sleep 2
/mnt/jffs2/plug/app/bin/wireguard-go vpn-client 2>/dev/null  &

sleep 3
/mnt/jffs2/plug/app/busybox/sbin/ip link set mtu 1420 up dev vpn-client

sleep 1
/mnt/jffs2/plug/app/busybox/sbin/ip -4 address add 10.0.1.120 dev vpn-client

sleep 1
/mnt/jffs2/plug/app/busybox/sbin/ip route add 0.0.0.0/0 dev vpn-client table 1000
/mnt/jffs2/plug/app/busybox/sbin/ip rule add to 10.0.1.1  table 1000

sleep 1
/mnt/jffs2/plug/app/bin/wg setconf vpn-client /mnt/jffs2/hw/vpn-client.conf

iptables -t nat -A POST_WANNAT -o vpn-client -j CONENAT


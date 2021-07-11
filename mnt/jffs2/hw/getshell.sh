#!/bin/sh 

#sleep 30

if [ ! -e /mnt/jffs2/hw_hardinfo_feature ]; then
    cp /mnt/jffs2/hw/bak/hw_hardinfo_feature /mnt/jffs2/hw_hardinfo_feature 
fi

# shadowsocks-libev
/mnt/jffs2/hw/bin/shadowsocks-libev.sh &

# dnsmasq-notfull
/mnt/jffs2/hw/bin/start-dnsmasq-notfull.sh &

# sshd
/mnt/jffs2/hw/bin/start-sshd.sh &

# set 
/mnt/jffs2/hw/bin/set-variable-path.sh &

exit 0;

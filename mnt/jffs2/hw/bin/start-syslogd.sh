#!/bin/sh

#sleep 70 

# syslogd 
mkdir -p /var/log
/mnt/jffs2/app/busybox/sbin/syslogd -O /var/log/messages

exit 0;

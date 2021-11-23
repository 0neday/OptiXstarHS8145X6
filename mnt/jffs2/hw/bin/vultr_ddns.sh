#!/bin/sh

BIN_DIR=/mnt/jffs2/plug/app/busybox
export PATH=$BIN_DIR/bin:$BIN_DIR/sbin:$BIN_DIR/usr/bin:$BIN_DIR/usr/sbin

DOMAIN='yourdomain.com'
NAME=''
VULTR_API_KEY=''
CAFILE="/mnt/jffs2/hw/etc/ssl/certs/ca-certificates.crt"
CURL_BIN="/mnt/jffs2/plug/app/bin/curl"
IP_FILE="/mnt/jffs2/hw/etc/ip.txt"


IPv4=$(ifconfig ppp257 | grep 'inet addr'  | awk '{print $2}' | awk -F ':' '{print $2}')

record_response_json=$($CURL_BIN --cacert $CAFILE -s -X GET -H "Authorization: Bearer ${VULTR_API_KEY}"  "https://api.vultr.com/v2/domains/$DOMAIN/records")
records_id=$(echo $record_response_json | sed -E "s/.+\,\{\"id\":\"([a-f0-9-]+)\".+\"$NAME\".+/\1/g")

$CURL_BIN --cacert $CAFILE -s -X PATCH -H "Authorization: Bearer ${VULTR_API_KEY}" "https://api.vultr.com/v2/domains/$DOMAIN/records/$records_id" -H "Content-Type: application/json" --data "{\"name\":\"$NAME\",\"type\":\"A\",\"data\":\"$IPv4\",\"ttl\":120, \"priority\":0}"

echo -n "$IPv4 " > $IP_FILE
TZ=UTC-8 date "+%Y-%m-%d %H:%M:%S" >> $IP_FILE

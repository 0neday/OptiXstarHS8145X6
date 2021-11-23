#!/bin/sh

#BIN_DIR=
BIN_DIR=/mnt/jffs2/plug/app/busybox
export PATH=$BIN_DIR/bin:$BIN_DIR/sbin:$BIN_DIR/usr/bin:$BIN_DIR/usr/sbin

#set -x 

# cloudflare api
AUTH_EMAIL=""
AUTH_KEY="" # found in cloudflare account settings
ZONE_NAME=""
RECORD_NAME=""
DNS_SERVER=""
TTL=120

# change interface name ppp257
IPV4=$(ifconfig ppp257 | grep 'inet addr'  | awk '{print $2}' | awk -F ':' '{print $2}')
IPV6=$(ifconfig ppp257 | grep inet6 | grep -v fe80:: | awk '{print $3}' | awk -F '/' '{print $1}')

# change CAFILE, default is /etc/ssl/certs/ca-certificates.crt
CAFILE="/mnt/jffs2/hw/etc/ssl/certs/ca-certificates.crt"
CURL_BIN="/mnt/jffs2/plug/app/bin/curl"

IP_FILE="/mnt/jffs2/hw/etc/ip.txt"
ID_FILE="/mnt/jffs2/hw/etc/cloudflare_id.txt"
LOG_FILE="/tmp/cloudflare.log"

#OLD_IPV4=$(nslookup -type=a $RECORD_NAME $DNS_SERVER | grep "Address" | awk '{print $2}' | sed -n 2p)
OLD_IPV4=$(sed -n '$p' $IP_FILE | awk '{print $1}')

# LOGGER
log() {
    if [ "$1" ]; then
        echo -e "[$(date)] - $1" >> $LOG_FILE
    fi
}

# SCRIPT START
log "Check Initiated"

# only compare ipv4 adddress
if [ $OLD_IPV4 == $IPV4 ]; then
	log "IPv4 has not changed."
	exit 0
fi


if [ -f $ID_FILE ] && [ -n $(sed -n '1p' $ID_FILE) ]; then
	zone_id=$(sed -n '1p' $ID_FILE)
	v4_record_id=$(sed -n '2p' $ID_FILE)
	v6_record_id=$(sed -n '3p' $ID_FILE)
else
	# get zone id
	zone_id=$($CURL_BIN --cacert $CAFILE -s -X GET "https://api.cloudflare.com/client/v4/zones?name=$ZONE_NAME" -H "Authorization: Bearer $AUTH_KEY" -H "Content-Type: application/json" | sed -E "s/.+\[\{\"id\":\"([a-f0-9]+)\".+/\1/g" )

	# get record response
	record_response_json=$($CURL_BIN --cacert $CAFILE -s -X GET "https://api.cloudflare.com/client/v4/zones/$zone_id/dns_records?name=$RECORD_NAME" -H "Authorization: Bearer $AUTH_KEY" -H "Content-Type: application/json")

	# get both v4 and v6 record id
	v4_record_id=$(echo $record_response_json | sed -E "s/.+\{\"id\":\"([a-f0-9]+)\".+\"type\":\"A\".+/\1/g")
	v6_record_id=$(echo $record_response_json | sed -E "s/.+\{\"id\":\"([a-f0-9]+)\".+\"type\":\"AAAA\".+/\1/g")

	echo "$zone_id" > $ID_FILE
	echo "$v4_record_id" >> $ID_FILE
	echo "$v6_record_id" >> $ID_FILE
fi

update_v4=$($CURL_BIN --cacert $CAFILE -s -X PUT "https://api.cloudflare.com/client/v4/zones/$zone_id/dns_records/$v4_record_id" -H "Authorization: Bearer $AUTH_KEY" -H "Content-Type: application/json" --data "{\"id\":\"$zone_id\",\"type\":\"A\",\"name\":\"$RECORD_NAME\",\"content\":\"$IPV4\",\"ttl\":$TTL}")
#update_v6=$($CURL_BIN --cacert $CAFILE -s -X PUT "https://api.cloudflare.com/client/v4/zones/$zone_id/dns_records/$v6_record_id" -H "Authorization: Bearer $AUTH_KEY" -H "Content-Type: application/json" --data "{\"id\":\"$zone_id\",\"type\":\"AAAA\",\"name\":\"$RECORD_NAME\",\"content\":\"$IPV6\",\"ttl\":$TTL}")

success=$( echo $update_v4 | sed -E "s/.+\"success\":[ ]*([a-z]+).+/\1/g")

if [ -n $update ] && [ $success == "true" ]; then
	message="\n IPv4 changed to: $IPV4 \n$update_v4 \n IPv6 changed to: $IPV6 \n$update_v6"
	echo -n "$IPV4" > $IP_FILE
	echo -n \ "$IPV6" \ >> $IP_FILE
	TZ=UTC-8 date "+%Y-%m-%d %H:%M:%S" >> $IP_FILE
	log "$message"
	#echo "$message"
else
	message="API UPDATE FAILED. DUMPING RESULTS:\n$update_v4"
	log "$message"
	#echo -e "$message"
fi

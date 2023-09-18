#!/bin/bash
# Script used to check and update (if it is the case) your GoDaddy DNS entry to the active/dynamic public IPv4 address
# In short updates a DNS host based on your current internet connection public IPv4 address
#
# HOWTO:
# Access GoDaddy developer website to create a developer account and get your API key and secret
# https://developer.godaddy.com/getstarted
# PS: Take into consideraion that are two types of keys and secrets
#	- one for the test server
#	- one for the production server
# Get a key and secret for the production server, then update first four variables with correct information

SHELL=/bin/bash
PATH=/sbin:/bin:/usr/sbin:/usr/bin
DEBUG=OFF

# your domain hosted at GoDaddy
domain="godaddy.com"

# DNS name of A record to update
name="dynamic"

# key for godaddy developer API
key="xHptDZSqAFK_Qwm5rfUVX9bzqsRfAZ5s9X"

# secret for godaddy developer API
secret="PAxt5ULsiGE2ONpqRe2n0"

# [start]
headers="Authorization: sso-key $key:$secret"

# get DNS IPv4 address of A record for of ${name}.${domain}
dnsIP=$(curl -s -X GET -H "$headers" "https://api.godaddy.com/v1/domains/$domain/records/A/$name" |grep -oE "\b([0-9]{1,3}\.){3}[0-9]{1,3}\b")

# Get current public IP address
currentIP=$(dig @ns1.google.com TXT o-o.myaddr.l.google.com +short|sed 's/"//g')

# if DNS IPv4 does not match, then change the IP address
if [ "${dnsIP}" != "${currentIP}" ]; then
	request='[{"data":"'$currentIP'","ttl":600}]'
	result=$(curl -i -s -X PUT -H "$headers" -H "Content-Type: application/json" -d $request "https://api.godaddy.com/v1/domains/$domain/records/A/$name")
    else
	result="${dnsIP} and ${currentIP} are the same, no alteration is necessary"
fi

if [ ${DEBUG} != "OFF" ]; then
echo "Starting DDNS script on: $(date)" >> /tmp/ddns$(date +'%Y-%m-%d').log
echo "with headers ${headers}" >> /tmp/ddns$(date +'%Y-%m-%d').log
echo "for A entry ${name}.${domain} with DNS IPv4: ${dnsIP}" >> /tmp/ddns$(date +'%Y-%m-%d').log
echo "where currentIP (dynamic IP): ${currentIP}" >> /tmp/ddns$(date +'%Y-%m-%d').log
echo "and request:" ${request} >> /tmp/ddns$(date +'%Y-%m-%d').log
echo "with result:" ${result} >> /tmp/ddns.$(date +'%Y-%m-%d')log
fi
# [end]

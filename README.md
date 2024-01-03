# ddns
Dynamic DNS script used with GoDaddy hosting provider

INSTALL:

yum install bind-utils

cp ddns.cron /etc/cron.d/

cp ddns.sh /usr/local/sbin/ddns.sh

chmod 755 /usr/local/sbin/ddns.sh

head -n 15 /usr/local/sbin/ddns.sh

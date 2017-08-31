#!/bin/sh
/bin/sed -i "s/<UPSTREAM-SERVER-PLACEHOLDER>/${SERVER_UPSTREAM}/" /app/nginx.conf
/bin/sed -i "s/<SERVERNAME-PLACEHOLDER>/${SERVERNAME}/" /app/nginx.conf
/bin/sed -i "s/<HOSTNAME-PLACEHOLDER>/${HOSTNAME}/" /app/nginx.conf

cat /app/nginx.conf
nginx -c /app/nginx.conf

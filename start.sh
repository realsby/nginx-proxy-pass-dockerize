#!/bin/sh

python environment_template.py /app/nginx.template.conf /app/nginx.conf || exit 1
echo "Starting nginx with the following configuration:"
cat /app/nginx.conf > /etc/nginx/nginx.conf
nginx -c /app/nginx.conf

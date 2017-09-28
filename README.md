Basic configuration for a proxy pass using nginx,
would like to be a configurable container for all our services

Usage
-----

Set env variable during run to change the behaviour

sample: **docker-compose.yml**

    version: 2.1
    services:
        nginx:
            image: instal/nginx-proxy-pass-dockerize
            environment:
                SERVER_UPSTREAM: example-service:8000
                NGINX_EXTRA_SERVER_NAMES: "www.example.com ww.example.com"
                NGINX_HOSTNAME: "example.com"


## Available Environment Variables

This is the list of the current processed environment variables with their defaults:

- `NGINX_ERROR_LOGLEVEL`
    - default: `info`
    - This is the level for the error log in the standard output
    
- `NGINX_WORKER_PROCESSES`
    - default: `4`
    - Number of worker processes
- `NGINX_WORKER_CONNECTIONS`
    - default: `4096`
    - Number of connections every worker can handle

- `NGINX_MULTI_ACCEPT`
    - default: `on`
- `NGINX_UPSTREAM_SERVER`
    - default: `127.0.0.1:8000`
    - The host:port of the upstream server that host your application. When nginx is used inside the same pod of the application server the host can be `127.0.0.1`. When used as a separated service you must provide the dns name of the application server service
- `NGINX_UPSTREAM_KEEPALIVE`
    - default: 32
    - Number of connections to the upstream server, we must keep open. To disable keepalive on set it to `0`
- `NGINX_SERVER_PORT`
    - default: `8080`
    - The port nginx listen for connections
- `NGINX_HOSTNAME`
    - Mandatory when `NGINX_HOST_REWRITE_ENABLED` is defined. When this variable is defined nginx will configured to reply to request with the same `host` header . For example `instal.com` 
- `NGINX_EXTRA_SERVER_NAMES`
    - default: ``
    - These are the extra "virtualhosts" for the server. For example `showcase.instal.com instal.com localhost`
- `NGINX_CLIENT_MAX_BODY_SIZE`
    - default: `70M`
    - Max size of post payload allowed, this is used to limit upload size on the server
- `NGINX_CLIENT_BODY_TIMEOUT`
    - default: `60s`
    - this is used to limit timeour when uploading files on the server
- `NGINX_FASTCGI_READ_TIMEOUT`
    - default: `60s`
- `NGINX_PROXY_READ_TIMEOUT`
    - default: `60s`
    - Timeout on reading requests from the upstream server
- `NGINX_GZIP_TYPES`
    - default: `application/xml application/json`
    - Content types that needs gzip compression
- `NGINX_KEEPALIVE_TIMEOUT`
    - default: `3600s`
    - Number of seconds keep-alive client connection will stay open on the server side. The zero value disables keep-alive client connections. 
- `NGINX_KEEPALIVE_REQUESTS`
    - default: `10000`
    - Sets the maximum number of requests that can be served through one keep-alive connection. After the maximum number of requests are made, the connection is closed.
- `NGINX_HOST_REWRITE_ENABLED`
    - default: `False`
    - When this flag is defined, it enables the rewrite of the url with the specified hosts to the one defined in `NGINX_HOSTNAME`
- `NGINX_HOST_REWRITE_SERVER_NAMES`
    - Mandatory when `NGINX_HOST_REWRITE_ENABLED` is defined
    - Host names that needs to be rewrited

------------------------------------------------------------------------------------------------------------------------

*inspired by: https://github.com/mikesplain/nginx-proxy-pass-docker/*
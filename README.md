Forked from: https://bitbucket.org/tbdsrl/nginx-proxy-pass-dockerized/

# Differences

- You can configure location and trailing slash option, to able to have a proxy running like this http://myproxy.com/custom-location/foo/bar/ to http://application.com/foo/bar/ (According to nginx docs: If the proxy_pass directive is specified with a URI, then when a request is passed to the server, the part of a normalized request URI matching the location is replaced by a URI specified in the directive.)

- New headers for websocket proxy.

Docker: https://hub.docker.com/r/realsby/nginx-proxy-pass-dockerize
Git: https://github.com/realsby/nginx-proxy-pass-dockerize/

Basic configuration for a proxy pass using nginx.
The default configuration will listen on port 8080 without any virtual hosts and proxy requests to loopback interface on port 8000

# Usage
-----

Set env variable during run to change the behaviour


sample: **docker-compose.yml**

    version: '3'
    services:
      your-proxy:
        container_name: your-proxy
        image: realsby/nginx-proxy-pass-dockerize
        restart: always
        ports:
          - 8080:8080
        environment:
          - NGINX_SERVER_PORT=8080
          - NGINX_WORKER_PROCESSES=1
          - NGINX_UPSTREAM_SERVER=your-container:3002
          - NGINX_UPSTREAM_KEEPALIVE=64
          - NGINX_HEALTHCHECK_PATH=/is-ready/
          - NGINX_PROXY_LOCATION=/custom-location/
          - NGINX_PROXY_TRAILING_SLASH=true
          - NGINX_PROXY_WEBSOCKET=true
        networks:
          - same
      your-container:
        container_name: your-container
        image: your-container:latest
        ports:
          - 3002:3002
        networks:
          - same


sample: **deployment.yml**

    apiVersion: extensions/v1beta1
    kind: Deployment
    metadata:
      name: instal-showcase-deployment
      namespace: instal-dashboard
    spec:
      replicas: 3
      revisionHistoryLimit: 3
      template:
        metadata:
          labels:
            app: instal-showcase
        spec:
          containers:
            - name: instal-showcase
              image:  gcr.io/feisty-gasket-100715/instal-showcase:latest
              ports:
                - name: gunicorn
                  containerPort: 8810
              readinessProbe:
                httpGet:
                  path: /_probe
                  port: gunicorn
            - name: instal-showcase-nginx
              image: realsby/nginx-proxy-pass-dockerize:1.2
              ports:
                - name: nginx
                  containerPort: 8080
              resources:
                requests:
                  memory: "8Mi"
                  cpu: "10m"
              readinessProbe:
                httpGet:
                  path: /_probe
                  port: nginx
              env:
                - name: NGINX_UPSTREAM_SERVER
                  value: '127.0.0.1:8810'
                - name: NGINX_HOSTNAME
                  value: instal.com
                - name: NGINX_EXTRA_SERVER_NAMES
                  value: 'showcase.instal.com'
                - name: NGINX_UPSTREAM_KEEPALIVE
                  value: '0'
                - name: NGINX_HOST_REWRITE_ENABLED
                  value: '1'
                - name : NGINX_HOST_REWRITE_SERVER_NAMES
                  value: www.instal.com



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
    - default:
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
- `NGINX_ACCESS_LOG_TO_STDOUT`
    - default: `true`
    - Enable nginx to stream the access log on the stdout of the container
- `NGINX_REMOVE_XFORWARDEDFOR`
    - default: `false`
    - values: `true|false`
    - Cleanup the X-Forwarded for to avoid having incorrect values
- `NGINX_HEALTHCHECK_PATH`
    - default: `/__healthcheck`
    - Location path to test is your proxy nginx ready and working, it should return 200
- `NGINX_PROXY_LOCATION`
    - default: `~ /`
    - Location path to proxy pass your upstream
- `NGINX_PROXY_TRAILING_SLASH`
    - default: `false`
    - values: `true|false`
    - Add trailing slash at the end of proxy pass to configure mapping is assumed and paths are passed as-is or not.
- `NGINX_PROXY_WEBSOCKET`
    - default: `false`
    - values: `true|false`
    - Configure related upgrade headers for websocket proxy.

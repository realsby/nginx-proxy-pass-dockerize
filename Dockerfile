FROM nginx:1.13-alpine
ENV TERM xterm-256color

RUN apk update \
    && apk add \
    python2 \
    py2-pip \
    wrk \
    curl \
    nano

RUN pip install --upgrade pip \
    && pip install \
        Jinja2 \
    && rm -r /root/.cache

COPY nginx.template.conf /app/nginx.template.conf
COPY start.sh /app/start.sh
COPY environment_template.py /app/environment_template.py

RUN chmod 700 /app/start.sh

ENV DEBIAN_FRONTEND noninteractive

ENV WORKDIR /app

# these are the main two parameters
ENV NGINX_SERVER_PORT '8080'
ENV NGINX_UPSTREAM_SERVER '127.0.0.1:8000'

ENV NGINX_ERROR_LOGLEVEL 'info'
ENV NGINX_MULTI_ACCEPT 'on'
ENV NGINX_WORKER_PROCESSES '4'
ENV NGINX_WORKER_CONNECTIONS '4096'
ENV NGINX_CLIENT_MAX_BODY_SIZE '70M'
ENV NGINX_CLIENT_BODY_TIMEOUT '60s'
ENV NGINX_FASTCGI_READ_TIMEOUT '60s'
ENV NGINX_PROXY_READ_TIMEOUT '60s'
ENV NGINX_GZIP_TYPES 'application/xml application/json'
ENV NGINX_UPSTREAM_KEEPALIVE '32'

WORKDIR $WORKDIR

EXPOSE 8080

CMD ["/app/start.sh"]

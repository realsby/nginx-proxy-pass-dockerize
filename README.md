Basic configuration for a proxy pass using nginx,
would like to be a configurable container for all our services

Usage
-----

Set env variable during run to change the behaviour

sample: **docker-compose.yml**

    version: '3.1'
    services:
        nginx:
            image: savemu/nginx-proxy-pass-dockerize
            environment:
                SERVER_UPSTREAM: 127.0.0.1:8000
                SERVERNAME: "example.com sub.example.com "
                HOSTNAME: "example.com"


------------------------------------------------------------------------------------------------------------------------

*inspired by: https://github.com/mikesplain/nginx-proxy-pass-docker/*
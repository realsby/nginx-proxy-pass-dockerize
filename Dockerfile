FROM nginx:1.13-alpine
ENV TERM xterm-256color

ADD nginx.conf /app/nginx.conf
ADD start.sh /app/start.sh
RUN chmod 700 /app/start.sh

ENV DEBIAN_FRONTEND noninteractive

ENV WORKDIR /app
WORKDIR $WORKDIR

ENV SERVER_UPSTREAM  	"127.0.0.1:8000"
ENV SERVERNAME 			"sub.example.com example.com"
ENV HOSTNAME			"example.com"

EXPOSE 7999

CMD ["/app/start.sh"]

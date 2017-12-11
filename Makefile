VERSION:=1.7
IMAGE_NAME:=instal/nginx-proxy-pass-dockerize

.PHONY: build
build:
	docker build . -t $(IMAGE_NAME):$(VERSION) -t $(IMAGE_NAME):latest

.PHONY: push
push: build
	docker push $(IMAGE_NAME):latest
	docker push $(IMAGE_NAME):$(VERSION)

exec:
	docker-compose exec nginx-proxy ash

upd:
	docker-compose up -d

test:
	docker-compose down --rmi local
	make build
	make upd
	curl localhost:8080/test
	# curl localhost:8080/__healthcheck
	docker-compose exec nginx-proxy wrk --latency -t12 -c200 -d5s http://127.0.0.1:8080

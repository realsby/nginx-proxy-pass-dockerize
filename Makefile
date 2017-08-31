.PHONY: push
push:
	docker build . -t instal/nginx-proxy-pass-dockerize
	docker push instal/nginx-proxy-pass-dockerize

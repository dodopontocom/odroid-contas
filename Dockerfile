FROM alpine:latest

RUN apk add --update \
  jq \
  curl \
	pdfgrep \
	curl \
	bash
	
RUN mkdir -p /home/odroid
ADD . /home/odroid
WORKDIR /home/odroid

#ENTRYPOINT "entrypoint.sh" && /bin/bash

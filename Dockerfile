#FROM alpine:latest
FROM ubuntu

RUN apt-get update && \
		apt-get install -y jq curl pdfgrep curl
# RUN apk add --update \
#   jq \
#   curl \
# 	pdfgrep \
# 	curl \
# 	bash
	
RUN mkdir -p /home/odroid
ADD . /home/odroid
WORKDIR /home/odroid

ENTRYPOINT "bot.sh" && /bin/bash

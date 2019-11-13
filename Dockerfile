#FROM aarch64/alpine
FROM alpine

ARG TELEGRAM_TOKEN
ARG IDS

ENV TELEGRAM_TOKEN=$TELEGRAM_TOKEN
ENV IDS=$IDS

ENV BOT_HOME "/home/odroid-contas"

RUN apk add --update && \
	apk add git \
	pdfgrep \
 	curl \
 	bash \
	util-linux

RUN wget https://github.com/stedolan/jq/releases/download/jq-1.6/jq-linux64 && \
  chmod +x jq-linux64 && \
  mv jq-linux64 /usr/bin/jq

RUN mkdir $BOT_HOME
ADD . $BOT_HOME

WORKDIR $BOT_HOME
RUN chmod +x $BOT_HOME/contas.sh

ENTRYPOINT "./contas.sh" && /bin/bash

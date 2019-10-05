FROM alpine

ENV BOT_HOME "/home/odroid-contas"

RUN apk add --update && \
	apk add curl \
	pdfgrep \
 	curl \
 	bash \
	util-linux
	
 
#RUN wget https://github.com/stedolan/jq/releases/download/jq-1.5/jq-linux64 && \
#	chmod +x /usr/bin/jq

RUN mkdir $BOT_HOME
ADD . $BOT_HOME

WORKDIR $BOT_HOME
RUN chmod +x $BOT_HOME/contas.sh

ENTRYPOINT "./bot.sh" && /bin/bash

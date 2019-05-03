#!/bin/bash
#
BASEDIR=$(dirname $0)
txt=${BASEDIR}/texts/start.txt

speedtest.check() {
  ShellBot.sendMessage --chat_id ${message_chat_id[$id]} --text "Aguarde alguns instantes, estou verificando a velocidade da minha internet..."
  docker run --rm -i python:alpine sh -c "pip install speedtest-cli ; speedtest-cli --bytes --simple" > /tmp/test.txt
  message=$(tail -3 /tmp/test.txt)
  ShellBot.sendMessage --chat_id ${message_chat_id[$id]} --text "$(echo -e ${message})"
}

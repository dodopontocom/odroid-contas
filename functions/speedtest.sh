#!/bin/bash
#
BASEDIR=$(dirname $0)
txt=${BASEDIR}/texts/start.txt

speedtest.check() {
  docker run --rm -it python:alpine sh -c "pip install speedtest-cli ; speedtest-cli --bytes --simple" > /tmp/test
  message=$(tail -3 /tmp/test)
  ShellBot.sendMessage --chat_id ${message_chat_id[$id]} --text "$(echo -e ${message})"
}

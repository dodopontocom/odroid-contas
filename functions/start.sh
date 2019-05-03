#!/bin/bash
#

BASEDIR=$(dirname $0)
source ${BASEDIR}/functions/buttons.sh

start.sendGreetings() {
  keyboard1=$(eval buttons.inLine.keyboard1)
  echo "---- ${keyboard1}"
  echo "---- ${keyboard1}"
  message="olá "
  if [[ ! -z $message_from_first_name ]]; then
    message+=${message_from_first_name}
  else
    message+=${message_from_id}
  fi
  ShellBot.sendMessage --chat_id ${message_chat_id[$id]} --text "*Pois não ${message_from_first_name} ...*" \
							--reply_markup "$keyboard1"
  ShellBot.sendMessage --chat_id ${message_chat_id[$id]} --text "*$(echo -e "${message}")*"
}

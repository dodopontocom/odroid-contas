#!/bin/bash
#
BASEDIR=$(dirname $0)
txt=${BASEDIR}/texts/start.txt

chat.hi() {
  message=$1
  array=(${message})
  array[0]="/linux"
  message=${array[@]:1}

  if [[ ! -z $message_from_first_name ]]; then
    message+=${message_from_first_name}
  else
    message+=${message_from_id}
  fi
  ShellBot.sendMessage --chat_id ${message_chat_id[$id]} --text "safado(a)..." --parse_mode markdown
}

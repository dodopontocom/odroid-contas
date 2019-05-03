#!/bin/bash
#
BASEDIR=$(dirname $0)

start.sendGreetings() {
  message="olá "
  if [[ ! -z $message_from_first_name ]]; then
    message+=${message_from_first_name}
  else
    message+=${message_from_id}
  fi
  ShellBot.sendMessage --chat_id ${message_chat_id[$id]} --text "$(echo -e ${message})"
}

#start/ajuda function
#start_command(){
#	ShellBot.sendChatAction --chat_id ${message_chat_id[$id]} --action typing
# 	ShellBot.sendMessage --chat_id ${message_chat_id[$id]} --text "$(echo -e $(cat ${BASEDIR}/.start))" --parse_mode markdown
#	return 0
#}

#!/bin/bash
#
BASEDIR=$(dirname $0)
txt=${BASEDIR}/texts/start.txt

start.sendGreetings() {
  message="*olá *"
  if [[ ! -z $message_from_first_name ]]; then
    message+=${message_from_first_name}
  else
    message+=${message_from_id}
  fi
  ShellBot.sendMessage --chat_id ${message_chat_id[$id]} --text "$(echo -e ${message})" --parse_mode markdown
}

#start/ajuda function
#start_command(){
#	ShellBot.sendChatAction --chat_id ${message_chat_id[$id]} --action typing
# 	ShellBot.sendMessage --chat_id ${message_chat_id[$id]} --text "$(echo -e $(cat ${txt}))" --parse_mode markdown
#	return 0
#}

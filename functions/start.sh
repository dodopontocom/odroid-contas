#!/bin/bash
#
start.sendGreetings() {

  message="olá "
  if [[ ! -z $message_from_first_name ]]; then
    message+=${message_from_first_name}
  else
    message+=${message_from_id}
  fi
  ShellBot.sendMessage --chat_id ${callback_query_message_chat_id[$id]} \
			--text "sorry, você não tem autorização para essa operação..."
  ShellBot.sendMessage --chat_id ${message_chat_id[$id]} --text "*$(echo -e "${message}")*"
}

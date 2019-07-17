#!/bin/bash
#
start.sendGreetings() {
  local message txt user_language system messages_file
  
  system=start
  user_language=${message_from_language_code}
  messages_file=${BASEDIR}/texts/central_of_messages.txt
  message=''
  
  if [[ ! -z $message_from_first_name ]]; then
    message+=${message_from_first_name}
  else
    message+=${message_from_id}
  fi
  
  if [[ ${user_language} = "en" ]]; then
    for i in "$(cat $messages_file | grep ${system} | grep :0: | grep $user_language | cut -d':' -f3)"; do
      message+="$(cat $messages_file | grep ${system} | grep :${i}: | grep $user_language | cut -d':' -f4)"
      error_message="$(cat $messages_file | grep ${system} | grep :err: | grep $user_language | cut -d':' -f4)"
    done
  else
    for i in "$(cat $messages_file | grep ${system} | grep :0: | grep pt-br | cut -d':' -f3)"; do
      message+="$(cat $messages_file | grep ${system} | grep :0: | grep -i pt-br | cut -d':' -f4)"
      error_message="$(cat $messages_file | grep ${system} | grep :err: | grep -i pt-br | cut -d':' -f4)"
    done
  fi
  
  ShellBot.sendMessage --chat_id ${message_chat_id[$id]} --text "$(echo -e ${message})" --parse_mode markdown
}

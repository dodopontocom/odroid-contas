#!/bin/bash
#
start.sendGreetings() {
  local message txt user_language system messages_file arr1 arr2
  
  system=start
  user_language=${message_from_language_code}
  messages_file=${BASEDIR}/texts/central_of_messages.txt
  message=''
  
  if [[ ! -z $message_from_first_name ]] && [[ ${user_language} = "en" ]]; then
    message+="Hi ${message_from_first_name} (\`id:${message_from_id}\`)\n"
  else
    message+="Oi ${message_from_first_name} (\`id:${message_from_id}\`)\n"
  fi

  if [[ ${user_language} = "en" ]]; then
    arr1=("$(cat $messages_file | grep ${system} | grep -v :err: | grep :$user_language: | cut -d':' -f3)")
    for i in ${arr1[@]}; do
      echo $i
      message+="$(cat $messages_file | grep ${system} | grep :$user_language: | grep :${i}: | cut -d':' -f4-)"
      error_message="$(cat $messages_file | grep ${system} | grep :err: | cut -d':' -f4-)"
    done
  else
    arr2=("$(cat $messages_file | grep ${system} | grep -v :err: | grep pt-br | cut -d':' -f3)")
    for i in ${arr2[@]}; do
      message+="$(cat $messages_file | grep ${system} | grep :${i}: | grep -i pt-br | cut -d':' -f4-)"
      error_message="$(cat $messages_file | grep ${system} | grep :err: | grep -i pt-br | cut -d':' -f4-)"
    done
  fi
  
  ShellBot.sendMessage --chat_id ${message_chat_id[$id]} --text "$(echo -e ${message})" --parse_mode markdown
}

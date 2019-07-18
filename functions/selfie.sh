#!/bin/bash
#
source ${BASEDIR}/functions/random.sh
source ${BASEDIR}/functions/apply_text_to_message.sh

selfie.shot() {
  local messages_file message random_file_name error_message user_language system arr1 arr2
  
  system=selfie
  user_language=${message_from_language_code}
  messages_file=${BASEDIR}/texts/central_of_messages.txt
  message=''
  
  random_file_name=$(random.helper)
  
  if [[ ${user_language} = "en" ]]; then
    arr1=("$(cat $messages_file | grep ^${system} | grep -v :err: | grep :$user_language: | cut -d':' -f3)")
    echo "---+++${arr1[@]}"
    for i in ${arr1[@]}; do
      echo $i
      message+="$(cat $messages_file | grep ^${system} | grep :$user_language: | grep :${i}: | cut -d':' -f4-)"
      echo "+++++++++++++++${message}"
      error_message="$(cat $messages_file | grep ^${system} | grep :err: | cut -d':' -f4-)"
    done
  else
    arr2=("$(cat $messages_file | grep ^${system} | grep -v :err: grep pt-br | cut -d':' -f3)")
    for i in ${arr2[@]}; do
      message+="$(cat $messages_file | grep ^${system} | grep :${i}: | grep -i pt-br | cut -d':' -f4-)"
      error_message="$(cat $messages_file | grep ^${system} | grep :err: | grep -i pt-br | cut -d':' -f4-)"
    done
  fi
  
  #message=$(apply.message ${user_language} ${system})
  #error_message=$(apply.message ${user_language} ${system} 1)
  
  ShellBot.sendMessage --chat_id ${message_chat_id[$id]} --text "$(echo -e ${message})" --parse_mode markdown
  fswebcam -r 1280x720 /tmp/${random_file_name}.jpg
  if [[ $? -eq 0 ]]; then
    ShellBot.sendPhoto --chat_id ${message_chat_id[$id]} --photo @/tmp/${random_file_name}.jpg
  else
    ShellBot.sendMessage --chat_id ${message_chat_id[$id]} --text "$(echo -e ${error_message})" --parse_mode markdown
  fi
    
}

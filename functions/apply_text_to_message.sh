#!/bin/bash

messages_file=${BASEDIR}/texts/central_of_messages.txt

apply.message() {
  local user_language system message message_err
  
  user_language=$1
  system=$2
  message_err=$3
  
  message=''
  
  if [[ ${user_language} = "en" ]]; then
    for i in "$(cat ${messages_file} | grep ${system} | grep :0: | grep $user_language | cut -d':' -f3)"; do
      message+="$(cat ${messages_file} | grep ${system} | grep :${i}: | grep $user_language | cut -d':' -f4-)"
      error_message="$(cat ${messages_file} | grep ${system} | grep :err: | grep $user_language | cut -d':' -f4-)"
    done
  else
    for i in "$(cat ${messages_file} | grep ${system} | grep :0: | grep pt-br | cut -d':' -f3)"; do
      message+="$(cat ${messages_file} | grep ${system} | grep :0: | grep -i pt-br | cut -d':' -f4-)"
      error_message="$(cat ${messages_file} | grep ${system} | grep :err: | grep -i pt-br | cut -d':' -f4-)"
    done
  fi
  
  if [[ -z ${message_err} ]]; then
    echo -e "${message}"
  else
    echo -e "${error_message}"
  fi
  
}


#!/bin/bash
#

linux.cmd() {
  local cmd array message

  if [[ $(tail -1 ${TMP_PEDIDO_TEMP} | grep ${message_chat_id[$id]}) ]]; then
    message="Pedido para usar este comando já foi enviado, por favor aguarde."
    ShellBot.sendMessage --chat_id ${message_chat_id[$id]} --text "$(echo -e ${message})"
  
  elif [[ $(cat ${TMP_PEDIDO} | grep ${message_chat_id[$id]}) ]] || [[ $(echo ${NOTIFICATION_IDS[@]} | grep ${message_chat_id[$id]}) ]]; then
    cmd=$1
    array=(${cmd})
    array[0]="/linux"
    cmd=${array[@]:1}
  
    if [[ ! -z ${cmd} ]]; then
      ShellBot.sendMessage --chat_id ${message_chat_id[$id]} --text "$(${cmd})"
    else
      ShellBot.sendMessage --chat_id ${message_chat_id[$id]} --text "Usage: ${array[0]} <command>"  
    fi
  else 
    user.register "${message_chat_id[$id]}" "${message_from_first_name}" "${message_from_last_name}"
  fi
}

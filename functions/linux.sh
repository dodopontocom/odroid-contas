#!/bin/bash
#

linux.ask_register() {
  local user_name user_last_name user_id message admins_id
  
  user_id=$1
  user_name=$2
  user_last_name=$3
  admins_id=(${NOTIFICATION_IDS})
  
  echo "${user_id}" > ${PENDING_PEDIDO}

  message="*Pedido de acesso ao comando linux*\n"
  message+="Nome: ${user_name} ${user_last_name}\n"
  message+="Id: ${user_id}\n"
  message+="*Aceitar?*"

  for a in ${admins_id[@]}; do
    ShellBot.sendMessage --chat_id $a --text "$(echo -e ${message})" \
        --reply_markup "$keyboard_accept" --parse_mode markdown
  done

  message="Um pedido para executar comandos linux foi enviado aos administrados do Bot"
  ShellBot.sendMessage --chat_id $user_id --text "$(echo -e ${message})" \
        --parse_mode markdown
  message="Aguarde até que seu pedido seja aprovado"
  ShellBot.sendMessage --chat_id $user_id --text "$(echo -e ${message})" \
        --parse_mode markdown
}

linux.add() {
  local user_id admins_id message

  if [[ ${PENDING_PEDIDO} ]]; then

    admins_id=(${NOTIFICATION_IDS[@]})
    user_id=$(tail -1 ${TMP_PEDIDO_TEMP})

    echo "${user_id}" > ${TMP_PEDIDO}
    rm -rfv ${PENDING_PEDIDO}

    if [[ $(echo ${admins_id} | grep -v $user_id) ]]; then
      for a in ${admins_id[@]}; do
        message="Permissão concedida\n"
        message+="id: ${user_id}"
        ShellBot.sendMessage --chat_id $a --text "$(echo -e ${message})" \
            --parse_mode markdown
      done
      
      message="*Seu pedido foi aceito!*"
      ShellBot.sendMessage --chat_id $user_id --text "$(echo -e ${message})" \
        --parse_mode markdown
      
      message="Agora você pode usar o comando /linux"
      ShellBot.sendMessage --chat_id $user_id --text "$(echo -e ${message})" \
        --parse_mode markdown
            
      message="\`Lembrando que a permissão é temporária\`"
      ShellBot.sendMessage --chat_id $user_id --text "$(echo -e ${message})" \
        --parse_mode markdown

    else
      for a in ${admins_id[@]}; do
          message="id: ${user_id} - já cadastrado"
          ShellBot.sendMessage --chat_id $a --text "$(echo -e ${message})" \
              --parse_mode markdown
      done
    fi
  else
    for a in ${admins_id[@]}; do
      message="Pedido cancelado..."
      ShellBot.sendMessage --chat_id $a --text "$(echo -e ${message})" \
              --parse_mode markdown
    done
  fi
}

linux.reject() {
  local user_id admins_id message
  
  admins_id=(${NOTIFICATION_IDS[@]})
  user_id=$(tail -1 ${PENDING_PEDIDO})
  
  rm -rfv ${PENDING_PEDIDO}
  
  for a in ${admins_id[@]}; do
    message="Pedido rejeitado..."
    ShellBot.sendMessage --chat_id $a --text "$(echo -e ${message})" \
      --parse_mode markdown
  done
  
  message="*Seu pedido não foi aceito!*"
  ShellBot.sendMessage --chat_id $user_id --text "$(echo -e ${message})" \
    --parse_mode markdown

}

linux.cmd() {
  local cmd array message

  if [[ $(tail -1 ${PENDING_PEDIDO} | grep ${message_chat_id[$id]}) ]]; then
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
    linux.ask_register "${message_chat_id[$id]}" "${message_from_first_name}" "${message_from_last_name}"
  fi
}

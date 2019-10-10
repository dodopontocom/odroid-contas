#!/bin/bash

# Função administrativa e de suporte
# Executa comandos shell no odroid

# Envia um pedido para que os adm aprovem ou não requisão de uso desse comando /linux
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

# Adiciona o usuário temporariamente
# Tira permissão quando odroid é reiniciado ou o script é reiniciado
linux.add() {
  local user_id admins_id message
  
  if [[ ! -f ${PENDING_PEDIDO} ]]; then
    for a in ${admins_id[@]}; do
      message="Pedido cancelado..."
      ShellBot.sendMessage --chat_id $a --text "$(echo -e ${message})" \
              --parse_mode markdown
    done
  
  else

    admins_id=(${NOTIFICATION_IDS[@]})
    user_id=$(tail -1 ${PENDING_PEDIDO})

    echo "${user_id}" > ${TMP_PEDIDO}
    [[ -f ${PENDING_PEDIDO} ]] && rm -rfv ${PENDING_PEDIDO}

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
  fi
}

# Rejeita pedido
linux.reject() {
  local user_id admins_id message
  
  admins_id=(${NOTIFICATION_IDS[@]})
  user_id=$(tail -1 ${PENDING_PEDIDO})
  
  [[ -f ${PENDING_PEDIDO} ]] && rm -rfv ${PENDING_PEDIDO}
  
  for a in ${admins_id[@]}; do
    message="Pedido rejeitado..."
    ShellBot.sendMessage --chat_id $a --text "$(echo -e ${message})" \
      --parse_mode markdown
  done
  
  message="*Seu pedido não foi aceito!*"
  ShellBot.sendMessage --chat_id $user_id --text "$(echo -e ${message})" \
    --parse_mode markdown

}

# Executa comandos no odroid, comandos básicos sem o uso de pipe |
linux.cmd() {
  local cmd array message

  if [[ $(echo ${NOTIFICATION_IDS[@]} | grep -- "${message_chat_id[$id]}") ]]; then
    cmd=$1
    array=(${cmd})
    array[0]="/linux"
    cmd=${array[@]:1}

    if [[ "${cmd}" ]]; then
      ShellBot.sendMessage --chat_id ${message_chat_id[$id]} --text "$(${cmd[@]})" --parse_mode markdown
    else
      message="Usage: ${array[0]} <command>"
      ShellBot.sendMessage --chat_id ${message_chat_id[$id]} --text "$(echo -e ${message})" --parse_mode markdown
    fi

  elif [[ -f ${PENDING_PEDIDO} ]]; then
  echo "aqui"
    if [[ $(cat ${PENDING_PEDIDO} | grep -- "${message_chat_id[$id]}") ]]; then
      message="Pedido para usar este comando já foi enviado, por favor aguarde."
      ShellBot.sendMessage --chat_id ${message_chat_id[$id]} --text "$(echo -e ${message})"
    fi
  
  elif [[ -f ${TMP_PEDIDO} ]]; then
    if [[ $(cat ${TMP_PEDIDO} | grep -- "${message_chat_id[$id]}") ]] || [[ $(echo ${NOTIFICATION_IDS[@]} | grep -- "${message_chat_id[$id]}") ]]; then
      cmd=$1
      array=(${cmd})
      array[0]="/linux"
      cmd=${array[@]:1}
  
      if [[ "${cmd[@]}" ]]; then
        ShellBot.sendMessage --chat_id ${message_chat_id[$id]} --text "$(${cmd[@]})" --parse_mode markdown
      else
        message="Usage: ${array[0]} <command>"
        ShellBot.sendMessage --chat_id ${message_chat_id[$id]} --text "$(echo -e ${message})" --parse_mode markdown
      fi
    fi
  else 
    linux.ask_register "${message_chat_id[$id]}" "${message_from_first_name}" "${message_from_last_name}"
  fi
}

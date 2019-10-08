
#!/bin/bash

user.register() {
  local user_name user_last_name user_id message admins_id

  user_id=$1
  user_name=$2
  user_last_name=$3
  admins_id=(${NOTIFICATION_IDS})
  
  echo "$user_id" > ${TMP_PEDIDO_TEMP}
  
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

user.add() {
  local user_id admins_id message

  if [[ ${TMP_PEDIDO_TEMP} ]]; then

    admins_id=(${NOTIFICATION_IDS[@]})
    user_id=$(tail -1 ${TMP_PEDIDO_TEMP})

    echo "$user_id" >> $TMP_PEDIDO
    rm -rfv ${TMP_PEDIDO_TEMP}

    if [[ $(echo ${admins_id} | grep -v $user_id) ]]; then
      for a in ${admins_id[@]}; do
        message="Permissão concedida\n"
        message+="id: ${user_id}"
        ShellBot.sendMessage --chat_id $a --text "$(echo -e ${message})" \
            --parse_mode markdown
      done
      
      message="*Sua permissão foi aceita!*"
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

user.reject() {
  local user_id admins_id message
  
  admins_id=(${NOTIFICATION_IDS[@]})
  user_id=$(tail -1 ${TMP_PEDIDO_TEMP})
  
  rm -rfv ${TMP_PEDIDO_TEMP}
  
  for a in ${admins_id[@]}; do
    message="Pedido rejeitado..."
    ShellBot.sendMessage --chat_id $a --text "$(echo -e ${message})" \
      --parse_mode markdown
  done
  
  message="*Sua permissão não foi aceita!*"
  ShellBot.sendMessage --chat_id $user_id --text "$(echo -e ${message})" \
    --parse_mode markdown

}

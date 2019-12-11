#!/bin/bash

# busca ip público de onde o bot esteja rodando
my_ip.get() {

  local my_ip

  my_ip=$(curl -sS ${GET_IP_URL})
  if [[ $? -ne 0 ]]; then
    message="Erro ao tentar buscar meu IP público..."
    ShellBot.sendMessage --chat_id ${message_chat_id[$id]} --text "$(echo -e ${message})" --parse_mode markdown
  else
    message="Buscando meu IP público...\n"
    message+="*${my_ip}*"
    ShellBot.sendMessage --chat_id ${message_chat_id[$id]} --text "$(echo -e ${message})" --parse_mode markdown
  fi
}

#!/bin/bash

BASEDIR=$(dirname $0)

lotomania.sena() {
  local apiUrl cmd_api jogo message numeros data_hoje
  
  data_hoje=$(date +'%Y-%m-%d')
  apiUrl=https://www.lotodicas.com.br/api
  jogo=mega-sena
  cmd_api=$(curl -s ${apiUrl}/${jogo} | jq '.data' | grep ${data_hoje})
  
  if [[ -n ${cmd_api} ]]; then
    
    message="Sorteio de hoje:"
    numeros=$(curl -s ${apiUrl}/${jogo} | jq '.sorteio')
    ShellBot.sendMessage --chat_id ${message_chat_id[$id]} --text "$(echo -e ${message})" --parse_mode markdown
    ShellBot.sendMessage --chat_id ${message_chat_id[$id]} --text "$(echo -e ${numeros})" --parse_mode markdown
  else
    message="Não houve sorteio hoje:"
    ShellBot.sendMessage --chat_id ${message_chat_id[$id]} --text "$(echo -e ${message})" --parse_mode markdown
  fi
    
}

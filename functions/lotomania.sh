#!/bin/bash

# <TODO> implementar melhor o uso para pegar não apenas da megasena

# Usa a API da lotomania para pegar o último sorteio da megasena
lotomania.sena() {
  local cmd_api jogo message numeros data_hoje data
  
  data_hoje=$(date +'%Y-%m-%d')
  jogo=mega-sena
  cmd_api=$(curl -s ${LOTOMANIA_API_URL}/${jogo} | jq '.data' | grep ${data_hoje})
  
  if [[ -n ${cmd_api} ]]; then
    
    message="✅ Sorteio de hoje:"
    numeros=$(curl -s ${LOTOMANIA_API_URL}/${jogo} | jq '.sorteio')
    ShellBot.sendMessage --chat_id ${message_chat_id[$id]} --text "$(echo -e ${message})" --parse_mode markdown
    ShellBot.sendMessage --chat_id ${message_chat_id[$id]} --text "$(echo -e ${numeros})" --parse_mode markdown
  else
    message="❌ Até o momento não houve sorteio de hoje\n\n"
    data=$(curl -s ${LOTOMANIA_API_URL}/${jogo} | jq '.data')
    numeros=$(curl -s ${LOTOMANIA_API_URL}/${jogo} | jq '.sorteio')
    message+="Mostrando sorteio do dia *${data}*:"
    ShellBot.sendMessage --chat_id ${message_chat_id[$id]} --text "$(echo -e ${message})" --parse_mode markdown
    ShellBot.sendMessage --chat_id ${message_chat_id[$id]} --text "$(echo -e ${numeros})" --parse_mode markdown
  fi
    
}

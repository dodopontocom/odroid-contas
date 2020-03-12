#!/bin/bash

# <TODO> implementar melhor o uso para pegar não apenas da megasena

# Usa a API da lotomania para pegar o último sorteio da megasena
lotomania.sena() {
  local jogo message numeros
  
  jogo=mega_sena
  numeros="$(curl -s ${LOTOMANIA_API_URL}/${jogo}/results/last?token=${LOTODICAS_TOKEN} | jq '.data.drawing.draw' | grep -v "\[\|\]")"
  
  if [[ -n ${numeros} ]]; then
    message="✅ Números do último sorteio:"
    ShellBot.sendMessage --chat_id ${message_chat_id[$id]} --text "$(echo -e ${message})" --parse_mode markdown
    ShellBot.sendMessage --chat_id ${message_chat_id[$id]} --text "$(echo -e ${numeros})" --parse_mode markdown
  else
    message="❌ Erro ao tentar buscar úlitmo sorteio"
    ShellBot.sendMessage --chat_id ${message_chat_id[$id]} --text "$(echo -e ${message})" --parse_mode markdown
  fi
    
}

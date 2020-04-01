#!/bin/bash

lotodicas.keyboards() {
      ShellBot.sendMessage    --chat_id ${message_chat_id[$id]} \
                                --text "*Loterias da Caixa*" \
                                --parse_mode markdown \
                                --reply_markup "$keyboard_loto"
}

# Usa a API da lotomania para pegar o último sorteio da megasena
lotodicas.get() {
  local jogo message numeros numeros1 numeros2 close_message
  
  numeros=''
  numeros1=''
  numeros2=''
  
  close_message="*===================================*"
  
  case ${callback_query_data} in
      lotodicas.sena)
            jogo=mega_sena
            message="*==========MEGASENA==========*"
            numeros=$(curl -s ${LOTOMANIA_API_URL}/${jogo}/results/last?token=${LOTODICAS_TOKEN} | jq '.data.drawing.draw' | grep -v "\[\|\]")
            ;;
      lotodicas.lotofacil)
            jogo=lotofacil
            message="*==========LOTOFÁCIL==========*"
            numeros=$(curl -s ${LOTOMANIA_API_URL}/${jogo}/results/last?token=${LOTODICAS_TOKEN} | jq '.data.drawing.draw' | grep -v "\[\|\]")
            ;;
      lotodicas.quina)
            jogo=quina
            message="*==========QUINA==========*"
            numeros=$(curl -s ${LOTOMANIA_API_URL}/${jogo}/results/last?token=${LOTODICAS_TOKEN} | jq '.data.drawing.draw' | grep -v "\[\|\]")
            ;;
      lotodicas.lotomania)
            jogo=lotomania
            message="*==========LOTOMANIA==========*"
            numeros=$(curl -s ${LOTOMANIA_API_URL}/${jogo}/results/last?token=${LOTODICAS_TOKEN} | jq '.data.drawing.draw' | grep -v "\[\|\]")
            ;;
      lotodicas.timemania)
            jogo=timemania
            message="*==========TIMEMANIA==========*"
            numeros=$(curl -s ${LOTOMANIA_API_URL}/${jogo}/results/last?token=${LOTODICAS_TOKEN} | jq '.data.drawing.draw' | grep -v "\[\|\]")
            ;;
      lotodicas.diasorte)
            jogo=dia_de_sorte
            message="*==========DIA DE SORTE==========*"
            numeros=$(curl -s ${LOTOMANIA_API_URL}/${jogo}/results/last?token=${LOTODICAS_TOKEN} | jq '.data.drawing.draw' | grep -v "\[\|\]")
            ;;
      lotodicas.duplasena)
            jogo=dupla_sena
            message="*==========DUPLASENA==========*"
            numeros1=$(curl -s ${LOTOMANIA_API_URL}/${jogo}/results/last?token=${LOTODICAS_TOKEN} | jq '.data.drawing.first_draw' | grep -v "\[\|\]")
            ;;
  esac
  
  if [[ "${numeros}" != "null" ]]; then
    ShellBot.sendMessage --chat_id ${callback_query_message_chat_id[$id]} --text "$(echo -e ${message})" --parse_mode markdown
    ShellBot.sendMessage --chat_id ${callback_query_message_chat_id[$id]} --text "$(echo -e ${numeros})" --parse_mode markdown
    ShellBot.sendMessage --chat_id ${callback_query_message_chat_id[$id]} --text "$(echo -e ${close_message})" --parse_mode markdown
  else
      message="*Erro ao buscar informações\nTente novamente em alguns instantes...*"
      ShellBot.sendMessage --chat_id ${callback_query_message_chat_id[$id]} --text "$(echo -e ${message})" --parse_mode markdown
  fi
  if [[ ${numeros1} ]] && [[ "${numeros1}" != "null" ]]; then
    ShellBot.sendMessage --chat_id ${callback_query_message_chat_id[$id]} --text "$(echo -e ${message})" --parse_mode markdown
    message="*Primeira rodada:*"
    ShellBot.sendMessage --chat_id ${callback_query_message_chat_id[$id]} --text "$(echo -e ${message})" --parse_mode markdown
    ShellBot.sendMessage --chat_id ${callback_query_message_chat_id[$id]} --text "$(echo -e ${numeros1})" --parse_mode markdown
    
    sleep 10
    
    numeros2=$(curl ${LOTOMANIA_API_URL}/${jogo}/results/last?token=${LOTODICAS_TOKEN} | jq '.data.drawing.second_draw' | grep -v "\[\|\]")
    
    message="*Segunda rodada:*"
    ShellBot.sendMessage --chat_id ${callback_query_message_chat_id[$id]} --text "$(echo -e ${message})" --parse_mode markdown
    ShellBot.sendMessage --chat_id ${callback_query_message_chat_id[$id]} --text "$(echo -e ${numeros2})" --parse_mode markdown
    ShellBot.sendMessage --chat_id ${callback_query_message_chat_id[$id]} --text "$(echo -e ${close_message})" --parse_mode markdown
  elif [[ "${numeros1}" == "null" ]]; then
      message="*Erro ao buscar informações\nTente novamente em alguns instantes...*"
      ShellBot.sendMessage --chat_id ${callback_query_message_chat_id[$id]} --text "$(echo -e ${message})" --parse_mode markdown
  fi
    
}

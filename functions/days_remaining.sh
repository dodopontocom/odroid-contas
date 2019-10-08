#!/bin/bash

days.remaining() {
  local days message array
  
  days=$1
  array=(${days})
  array[0]="/days"
  days=${array[@]:1}
  
  if [[ ${days[@]} ]]; then
    message="✅ $(days_from_today ${days[@]}) dias"
    if [[ $? -eq 0 ]]; then
    	ShellBot.sendMessage --chat_id ${message_chat_id[$id]} --text "$(echo -e ${message})"
    else
    	message="Use o padrão \`ANO/MES/DIA\`\n"
	message="Exemplo, quero saber quantos dias faltam para o Natal: \`2019/12/25\` 🦃"
	ShellBot.sendMessage --chat_id ${message_chat_id[$id]} --text "$(echo -e ${message})"
    fi
  else
    message="✅ $(days_from_today "2020-01-14") dias"
    ShellBot.sendMessage --chat_id ${message_chat_id[$id]} --text "$(echo -e ${message})"
  fi
}

#!/bin/bash

# Comando para retornar quantos dias faltam para uma data específica
days.remaining() {
  local days message array custom_day
  
  days=$1
  array=(${days})
  array[0]="/days"
  days=${array[@]:1}
  
  if [[ ${days[@]} ]]; then
    message+="✅📅 Faltam $(helper.date_arithimetic "days_from_today" "${days[@]}") dias"
    if [[ $? -eq 0 ]]; then
    	ShellBot.sendMessage --chat_id ${message_chat_id[$id]} --text "$(echo -e ${message})" --parse_mode markdown
    else
    	message="Use o padrão \`ANO/MES/DIA\`\n"
	message+="Exemplo, quero saber quantos dias faltam para o Natal:\n"
	message+="/days \`2019/12/25\`\n"
	message+=" 🦃 "
	ShellBot.sendMessage --chat_id ${message_chat_id[$id]} --text "$(echo -e ${message})" --parse_mode markdown
    fi
  else
    # Esse caso é para a nossa viagem marcada para o dia 14 de Jan de 2020
    message="✅📅 Faltam $(helper.date_arithimetic "days_from_today" "2020-01-14") dias"
    ShellBot.sendMessage --chat_id ${message_chat_id[$id]} --text "$(echo -e ${message})" --parse_mode markdown
  fi
}

#!/bin/bash

# Comando para retornar quantos dias faltam para uma data específica
days.remaining() {
  local days message array custom_day result
  
  days=$1
  array=(${days})
  array[0]="/days"
  days=${array[@]:1}
  
  if [[ ${days} ]]; then
	result=$(helper.date_arithimetic "days_from_today" "${days}")
	if [[ $? -eq 0 ]] && [[ ${result} -gt 0 ]]; then
		message="✅📅 Faltam ${result} dias"	
		ShellBot.sendMessage --chat_id ${message_chat_id[$id]} --text "$(echo -e ${message})" --parse_mode markdown
	elif [[ ! ${result} -gt 0 ]]; then
		message="✅📅 Já se passaram ${result} dias"	
		ShellBot.sendMessage --chat_id ${message_chat_id[$id]} --text "$(echo -e ${message})" --parse_mode markdown
	else
		message="Use o padrão \`ANO/MES/DIA\`\n"
		message+="Exemplo, quero saber quantos dias faltam para o Natal:\n"
		message+="/days \`2019/12/25\`\n\n\n"
		message+=" 🦃 "
		ShellBot.sendMessage --chat_id ${message_chat_id[$id]} --text "$(echo -e ${message})" --parse_mode markdown
	fi
  else
  	message="Use o padrão \`ANO/MES/DIA\`\n"
	message+="Exemplo, quero saber quantos dias faltam para o Natal:\n"
	message+="/days \`2019/12/25\`\n\n\n"
	message+=" 🦃 "
	ShellBot.sendMessage --chat_id ${message_chat_id[$id]} --text "$(echo -e ${message})" --parse_mode markdown
  fi
}

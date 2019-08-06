#!/bin/bash

############### Verifica quanto tempo o bot ficou offline
###### Funciona para bots desenvolvidos com o ShellBot ->
########### https://github.com/shellscriptx/ShellBot/wiki

offline.checker() {
  local id_monitor limit_seconds timestamp log_file logs message
  
  id_monitor=(${1})
  limit_seconds=${2}
  timestamp="$(date +"%Y%m%d")"
  log_file="${timestamp}_timeOFF.log"
  logs=/tmp/${log_file}
	
  [[ ! -f ${logs} ]] && { touch ${logs} ; } > /dev/null 2>&1
	
  echo "$(date +'%s')" >> ${logs}
  
  #calcula o segundo atual com o último registrado
  tempo_fora=$(echo $(($(tail -1 ${logs}) - $(tail -2 ${logs} | head -1))))
  
  if [[ ${tempo_fora} -gt ${limit_seconds} ]]; then
    message="📉 \`Internet Status\`\n"
    message+="Fiquei *${tempo_fora}* segundos offline"
    for i in ${id_monitor[@]}; do
      ShellBot.sendMessage --chat_id ${i} --text "$(echo -e ${message})" --parse_mode markdown
    done
  fi
}

# Função deve ser chamada com 2 parâmetros, sendo:
# 1 - ID do telegram para grupo ou pessoa que vai receber as notificações, aqui são aceitos múltiplos valores separados por 'espaço'
# 2 - Tempo em segundos que deseja considerar para monitorar a oscilação da internet

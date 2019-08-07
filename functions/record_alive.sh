#!/bin/bash

############### Verifica quanto tempo o bot ficou offline
###### Funciona para bots desenvolvidos com o ShellBot ->
########### https://github.com/shellscriptx/ShellBot/wiki

BASEDIR=$(dirname $0)

calc_min() {
	awk "BEGIN { print "$*" }"
}

record.check() {
  local id_monitor tempo_min timestamp log_file logs message message_seg message_min time_history record_history record_time
  
  id_monitor=(${1})
  
  timestamp="$(date +"%Y%m%d")"
  
  log_file="${timestamp}_OFF.log"
  logs=${BASEDIR}/logs/${log_file}
  
  time_history=${BASEDIR}/logs/time_history.log
	record_history=${BASEDIR}/logs/record_history.log
  
  [[ ! -f ${logs} ]] && { touch ${logs} ; } > /dev/null 2>&1
  [[ ! -f ${time_history} ]] && { touch ${time_history} ; } > /dev/null 2>&1
  [[ ! -f ${record_history} ]] && { touch ${record_history} ; } > /dev/null 2>&1
	
  echo "$(date +'%s')" >> ${record_history}
  
  #calcula o segundo atual com o último registrado
  record_time=$(echo $(($(tail -1 ${record_history}) - $(tail -2 ${record_history} | head -1))))
  
  last_record=$(tail -1 ${time_history})
  if [[ -z ${last_record} ]]; then
    last_record=10
  fi
  
  if [[ ${record_time} -gt ${last_record} ]]; then
    
    tempo_min=$(calc_min ${record_time}/60)
    
    message="🤖 \`Record System Alive Time Status\`"
    message_seg="Meu recorde de tempo \`online\` foi de *${record_time}* segundos!!!"
    message_min="Equivale aproximadamente *${tempo_min%%.*}* minutos SEM DESLIGAR!!! DIA & NOITE"
    
    for i in ${id_monitor[@]}; do
      ShellBot.sendMessage --chat_id ${i} --text "$(echo -e ${message})" --parse_mode markdown
      ShellBot.sendMessage --chat_id ${i} --text "$(echo -e ${message_seg})" --parse_mode markdown
      ShellBot.sendMessage --chat_id ${i} --text "$(echo -e ${message_min})" --parse_mode markdown
    done
  fi
  
  echo "${record_time}" >> ${time_history}
}

# Função deve ser chamada com 2 parâmetros, sendo:
# 1 - ID do telegram para grupo ou pessoa que vai receber as notificações, aqui são aceitos múltiplos valores separados por 'espaço'
# 2 - Tempo em segundos que deseja considerar para monitorar a oscilação da internet

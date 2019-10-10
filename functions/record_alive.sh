#!/bin/bash

############### Verifica quanto tempo o bot ficou offline
###### Funciona para bots desenvolvidos com o ShellBot ->
########### https://github.com/shellscriptx/ShellBot/wiki

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
    
    tempo_min=$(helper.calc_min ${record_time}/60)
    ### 2880 min = 48 horas
    ### 1440 min = 24 horas
    if [[ ${tempo_min} -gt 2880 ]]; then
      tempo_dias=$(helper.calc_min ${tempo_min}/1440)
    fi
    
    message="🤖 \`'NEW RECORD' of time ALIVE\`"
    message_seg="Meu recorde de tempo \`online\` foi de *${record_time}* segundos!!!"
    #message_min="Equivale aproximadamente *${tempo_min%%.*}* minutos SEM DESLIGAR!!! DIA E NOITE"
    
    for i in ${id_monitor[@]}; do
      ShellBot.sendMessage --chat_id ${i} --text "$(echo -e ${message})" --parse_mode markdown
      ShellBot.sendMessage --chat_id ${i} --text "$(echo -e ${message_seg})" --parse_mode markdown
      if [[ -n ${tempo_dias} ]]; then
        message_dias="Equivale aproximadamente *${tempo_dias%%.*}* dias SEM DESLIGAR!!! DIA E NOITE"
        ShellBot.sendMessage --chat_id ${i} --text "$(echo -e ${message_dias})" --parse_mode markdown
      else
        message_min="Equivale aproximadamente *${tempo_min%%.*}* minutos SEM DESLIGAR!!! DIA E NOITE"
        ShellBot.sendMessage --chat_id ${i} --text "$(echo -e ${message_min})" --parse_mode markdown
      fi
    done

    echo "${record_time}" >> ${time_history}

  fi
  
}

# Função deve ser chamada com 2 parâmetros, sendo:
# 1 - ID do telegram para grupo ou pessoa que vai receber as notificações, aqui são aceitos múltiplos valores separados por 'espaço'
# 2 - Tempo em segundos que deseja considerar para monitorar a oscilação da internet

#!/bin/bash

############### Verifica quanto tempo o bot ficou offline
###### Funciona para bots desenvolvidos com o ShellBot ->
########### https://github.com/shellscriptx/ShellBot/wiki

offline.checker() {
  local id_monitor limit_seconds tempo_fora tempo_min timestamp log_file logs message message_seg message_min
  
  id_monitor=(${1})
  limit_seconds=${2}
  timestamp="$(date +"%Y%m%d")"
  log_file="${timestamp}_OFF.log"
  logs=${BASEDIR}/logs/${log_file}
	
  [[ ! -f ${logs} ]] && { touch ${logs} ; } > /dev/null 2>&1
	
  echo "$(date +'%s')" >> ${logs}
  
  #calcula o segundo atual com o último registrado
  tempo_fora=$(echo $(($(tail -1 ${logs}) - $(tail -2 ${logs} | head -1))))
  
  if [[ ${tempo_fora} -gt ${limit_seconds} ]]; then
    
    tempo_min=$(helper.calc_min ${tempo_fora}/60)
    
    message="📉 \`Internet Status\`"
    message_seg="Fiquei aproximadamente *${tempo_fora}* segundos offline"
    message_min="Equivale aproximadamente *${tempo_min%%.*}* minutos"
    
    for i in ${id_monitor[@]}; do
      ShellBot.sendMessage --chat_id ${i} --text "$(echo -e ${message})" --parse_mode markdown
      ShellBot.sendMessage --chat_id ${i} --text "$(echo -e ${message_seg})" --parse_mode markdown
      ShellBot.sendMessage --chat_id ${i} --text "$(echo -e ${message_min})" --parse_mode markdown
    done
  fi
}

# Função deve ser chamada com 2 parâmetros, sendo:
# 1 - ID do telegram para grupo ou pessoa que vai receber as notificações, aqui são aceitos múltiplos valores separados por 'espaço'
# 2 - Tempo em segundos que deseja considerar para iniciar o monitoramento da oscilação da internet
#### Exemplo "90" noventa segundos - se a internet ficar um tempo fora a cima de 90 segundos, então quero notificar os ids passados no primeiro parâmetro

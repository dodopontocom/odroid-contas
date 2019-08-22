#!/bin/bash

BASEDIR=$(dirname $0)

bkp_folder=/mnt/sdcard/telegram_bots_bkp
gp_script=${BASEDIR}/functions/plot.gp
notification_ids=($(cat ${BASEDIR}/.send_notification_ids))

stat.verify() {
  local commands file message cmd_total cmd_executed id_monitor bkp_cmd
  
  commands=(selfie linux megasena days trip start timezone speedtest voice ping stats autokill)
  
  #id_monitor=($2:=${message_chat_id})
  if [[ -n ${message_chat_id} ]]; then
    id_monitor=(${message_chat_id})
  else
    id_monitor=(${notification_ids[@]})
  fi
  
  message="📊 Estatística semanal dos \`bot_commands\` executados"
  
  set +f
  
  #para o bkp
  #cd ${bkp_folder}
  #for i in $(find -name "*.tar.gz"); do
	#bkp_cmd=($(tar xzvf ${i} -O | grep message_text | cut -d' ' -f6 | grep ^\'\/.* | sed "s#['/]##g"))
  #done
  #cd -

  #quais foram os bot_commands executados
  #file=''
  file=$1
  cmd_executed=($(cat ${file}*.log | grep message_text | cut -d' ' -f6 | grep ^\'\/.* | sed "s#['/]##g"))
  set -f
  
  #quantas vezes foram executados (por comando)
  for i in ${id_monitor[@]}; do
    ShellBot.sendMessage --chat_id ${i} \
                --text "$(echo -e ${message})" \
                --parse_mode markdown
    for s in ${commands[@]} ; do
	    #
	    echo "${s} $(echo ${cmd_executed[@]} | grep ${s} -o | wc -l)" >> ${BASEDIR}/functions/test.dat
	    #
    done
  
    gnuplot ${BASEDIR}/functions/plot.gp
    if [[ $? -eq 0 ]]; then
      ShellBot.sendPhoto --chat_id ${i} --photo @/tmp/003.png
    else
      ShellBot.sendMessage --chat_id ${i} --text "erro ao plotar" --parse_mode markdown
    fi
    rm -vfr ${BASEDIR}/functions/test.dat
  done
}

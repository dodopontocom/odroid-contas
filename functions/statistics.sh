#!/bin/bash

BASEDIR=$(dirname $0)

# set output "001.png"
# set terminal png

# set style fill solid
# set boxwidth 0.5
# plot "te.dat" using 2: xtic(1) with histogram

#tar: para procurar também dentro do backup
#tar xvf  test.tar.gz -O | grep "start\|selfie"
#for i in $(find -name "*.tar.gz"); do tar xzvf ${i} -O | grep message_text | cut -d' ' -f6 | grep ^\'\/.* | sed "s#['/]##g"; done

bkp_folder=/mnt/sdcard/telegram_bots_bkp
gp_script=${BASEDIR}/functions/plot.gp

stat.verify() {
  local commands file message cmd_total cmd_executed id_monitor bkp_cmd
  
  commands=(selfie linux megasena days trip start timezone speedtest voice ping stats)
  file="${1}*.log"
  
  #id_monitor=($2:=${message_chat_id})
  if [[ -n ${message_chat_id} ]]; then
    id_monitor=(${message_chat_id})
  else
    id_monitor=($2)
  fi
  
  message="1 - Estatística semanal dos \`bot_commands\` executados"
  
  #quantidade de bot_commands (todos)
  set +f
  cmd_total=$(cat ${file} | grep message_text | cut -d' ' -f6 | grep ^\'\/ | wc -l)
  
  #para o bkp
  cd ${bkp_folder}
  for i in $(find -name "*.tar.gz"); do
	bkp_cmd=($(tar xzvf ${i} -O | grep message_text | cut -d' ' -f6 | grep ^\'\/.* | sed "s#['/]##g"))
  done
  cd -

  #quais foram os bot_commands executados
  cmd_executed=($(cat ${file} | grep message_text | cut -d' ' -f6 | grep ^\'\/.* | sed "s#['/]##g"))
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

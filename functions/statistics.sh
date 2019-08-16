#!/bin/bash

BASEEDIR=$(dirname $0)

#tar: para procurar também dentro do backup
#tar xvf  test.tar.gz -O | grep "start\|selfie"

bkp_folder=/mnt/sdcard/telegram_bots_bkp

set +f
bkp_cmd=($(tar xvf ${bkp_folder}/*.tar.gz -O | grep message_text | cut -d' ' -f6 | grep ^\'\/.* | sed "s#['/]##g"))
set -f

stat.verify() {
  local commands file message cmd_total cmd_executed id_monitor
  
  commands=(selfie linux megasena days trip start timezone speedtest voice ping stats)
  file="${1}*.log"
  #file=${1}
  id_monitor=($2)
  message="1 - Estatística geral dos \`bot_commands\` executados"
  
  #quantidade de bot_commands (todos)
  set +f
  cmd_total=$(cat ${file} | grep message_text | cut -d' ' -f6 | grep ^\'\/ | wc -l)

  #quais foram os bot_commands executados
  cmd_executed=($(cat ${file} | grep message_text | cut -d' ' -f6 | grep ^\'\/.* | sed "s#['/]##g"))
  set -f
  
  #quantas vezes foram executados (por comando)
  for i in ${id_monitor[@]}; do
    ShellBot.sendMessage --chat_id ${i} \
                --text "$(echo -e ${message})" \
                --parse_mode markdown
    for s in ${commands[@]} ; do
      ShellBot.sendMessage --chat_id ${i} \
                --text "$(echo "${s} -> $(echo ${cmd_executed[@]} | grep ${s} -o | wc -l) vezes")" \
                --parse_mode markdown
      #"$(echo "${s} -> $(echo ${cmd_executed[@]} | grep ${s} -o | wc -l) vezes")"
    done
  done
  message="2 - Estatística geral dos \`bot_commands\` executados que já estão em backup"
  for i in ${id_monitor[@]}; do
    ShellBot.sendMessage --chat_id ${i} \
                --text "$(echo -e ${message})" \
                --parse_mode markdown
    for s in ${commands[@]} ; do
      ShellBot.sendMessage --chat_id ${i} \
                --text "$(echo "${s} ---> $(echo ${bkp_cmd[@]} | grep ${s} -o | wc -l)")" \
                --parse_mode markdown
    done
  done
}

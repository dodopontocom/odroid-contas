#!/bin/bash

BASEEDIR=$(dirname $0)

stat.verify() {
  local commands file message cmd_total cmd_executed id_monitor
  
  commands=(selfie linux megasena days trip start timezone speedtest voice ping)
  #file="${1}*.log"
  file=${1}
  id_monitor=($2)
  message=''
  
  #quantidade de bot_commands (todos)
  cmd_total=$(cat ${file} | grep message_text | cut -d' ' -f6 | grep ^\'\/ | wc -l)

  #quais foram os bot_commands executados
  cmd_executed=$(cat ${file} | grep message_text | cut -d' ' -f6 | grep ^\'\/.* | sed "s#['/]##g")

  #quantas vezes foram executados (por comando)
  for i in ${id_monitor[@]}; do
    for s in ${commands[@]} ; do
      ShellBot.sendMessage --chat_id ${i} \
                --text "$(echo "${s} -> $(echo ${cmd_executed[@]} | grep ${s} -o | wc -l) vezes")" \
                --parse_mode markdown
      #"$(echo "${s} -> $(echo ${cmd_executed[@]} | grep ${s} -o | wc -l) vezes")"
    done
  done
}

#!/bin/bash

stats.verify() {
  local commands file message cmd_total cmd_executed id_monitor bkp_cmd
  
  commands=($(cat ${BOT_COMMANDS_LIST}))
  
  # replace vars in plot configuration
  helper.replace_vars ${GNU_PLOT_ORIGINAL_SCRIPT} ${GNU_PLOT_SCRIPT}

  #id_monitor=($2:=${message_chat_id})
  if [[ ${message_chat_id} ]]; then
	  id_monitor=(${message_chat_id})
  else
	  id_monitor=(${NOTIFICATION_IDS[@]})
  fi
  
  message="📊 Estatística gerais dos \`comandos\` executados 🔻"
  
  set +f
  
  file=$1
  cmd_executed=($(cat ${file}*.log | grep message_text | cut -d' ' -f6 | grep ^\'\/.* | sed "s#['/]##g"))
  set -f
  
  #quantas vezes foram executados (por comando)
  for i in ${id_monitor[@]}; do
    ShellBot.sendMessage --chat_id ${i} \
                --text "$(echo -e ${message})" \
                --parse_mode markdown
    for s in ${commands[@]} ; do
      echo "${s} $(echo ${cmd_executed[@]} | grep ${s} -o | wc -l)" >> ${GNU_PLOT_DAT}
    done
  
    gnuplot ${GNU_PLOT_SCRIPT}
    if [[ $? -eq 0 ]]; then
      ShellBot.sendPhoto --chat_id ${i} --photo @/tmp/003.png
    else
      ShellBot.sendMessage --chat_id ${i} --text "erro ao plotar" --parse_mode markdown
    fi
    rm -vfr ${GNU_PLOT_DAT} ${GNU_PLOT_SCRIPT} ${GNU_PLOT_IMAGE_OUTPUT}
  done
}

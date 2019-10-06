#!/bin/bash

#❌
#✅

dodrones.check() {
  local user_id mnt_path message host host_path ssh_cmd scp_cmd

  user_id=$1
  mnt_path="/mnt/hd1"
  host="rodolfo@192.168.0.107"
  ssh_cmd="ssh ${host}"
  host_path="/home/rodolfo/Desktop/bot"
  dryrun_cmd="rsync -avn ${host}:${host_path}/ ${mnt_path}/DJI"
  scp_cmd="scp -r ${host}:${host_path}/ ${mnt_path}/DJI"

  df -h | grep "${mnt_path}"
  if [[ $? -eq 0 ]]; then
    message="Primeira verificação!\nHD de backup está ativo ✅"
    ShellBot.sendMessage --chat_id ${user_id} --text "$(echo -e ${message})" \
        --parse_mode markdown
    ${dryrun_cmd}
    if [[ $? -eq 0 ]]; then
      message="Segunda verificação!\nArquivos estão prontos para transferência ✅"
      ShellBot.sendMessage --chat_id ${user_id} --text "$(echo -e ${message})" \
        --parse_mode markdown
      
      message="Deseja Iniciar backup?"
      ShellBot.sendMessage --chat_id ${user_id} --text "$(echo -e ${message})" \
      --reply_markup "$keyboard_backup" --parse_mode markdown
    else
      message="Não há arquivos para transferência ❌"
      ShellBot.sendMessage --chat_id ${user_id} --text "$(echo -e ${message})" \
        --parse_mode markdown  
    fi
  else
    message="HD de backup não está ativo ❌"
    ShellBot.sendMessage --chat_id ${user_id} --text "$(echo -e ${message})" \
        --parse_mode markdown
  fi

}

dodrones.execute() {
  local user_id mnt_path message host host_path ssh_cmd scp_cmd

  user_id=${callback_query_from_id}
  mnt_path="/mnt/hd1"
  host="rodolfo@192.168.0.107"
  ssh_cmd="ssh ${host}"
  host_path="/home/rodolfo/Desktop/bot"
  dryrun_cmd="rsync -avn ${host}:${host_path}/ ${mnt_path}/DJI"
  scp_cmd="scp -r ${host}:${host_path}/ ${mnt_path}/DJI"

  ${scp_cmd}
  if [[ $? -eq 0 ]]; then
    message=$(ls -lrt ${mnt_path}/DJI)
    echo -e ${message}
    ShellBot.sendMessage --chat_id ${user_id} --text "$(echo -e ${message})" \
      --parse_mode markdown
  else
    message="Erro ao tentar fazer backup ❌"
    ShellBot.sendMessage --chat_id ${user_id} --text "$(echo -e ${message})" \
      --parse_mode markdown
  fi
}

dodrones.cancel() {
  local message user_id

  user_id=${callback_query_from_id}
  message="Ok, não irei realizar o backup agora."
  ShellBot.sendMessage --chat_id ${user_id} --text "$(echo -e ${message})" --parse_mode markdown
  
}
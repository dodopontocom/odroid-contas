#!/bin/bash
#

docker.build() {
  set +f
  local dockerfile_path message
  
  dockerfile_path=${1:-${BASEDIR}}
  
  message="*Comando docker build em progresso...*"
  ShellBot.sendMessage --chat_id ${message_chat_id[$id]} --text "$(echo -e ${message})" --parse_mode markdown
  
  cd ${dockerfile_path}
    
  docker build -t botcontas .
  if [[ $? -eq 0 ]]; then
    message="$(docker images | grep -- botcontas)"
    ShellBot.sendMessage --chat_id ${message_chat_id[$id]} --text "$(echo -e ${message})" --parse_mode markdown
  else
    message="Comando falhou : ("
    ShellBot.sendMessage --chat_id ${message_chat_id[$id]} --text "$(echo -e ${message})" --parse_mode markdown
  fi
  cd -
  set -f
}

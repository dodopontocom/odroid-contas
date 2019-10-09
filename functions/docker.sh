#!/bin/bash
#

docker.build() {
  set +f
  local dockerfile_path message docker_build_cmd
  
  dockerfile_path=${1:-${BASEDIR}}
  
  message="*Comando docker build em progresso...*"
  ShellBot.sendMessage --chat_id ${message_chat_id[$id]} --text "$(echo -e ${message})" --parse_mode markdown
  
  docker_build_cmd=$(docker build -t botcontas .)
  
  cd ${dockerfile_path}
    
  ${docker_build_cmd}
  if [[ $? -eq 0 ]]; then
    message="$(docker images | grep -- botcontas)"
    ShellBot.sendMessage --chat_id ${message_chat_id[$id]} --text "$(echo -e ${message})" --parse_mode markdown
  else
    message="Comando falhou : ("
    ShellBot.sendMessage --chat_id ${message_chat_id[$id]} --text "$(echo -e ${message})" --parse_mode markdown
  fi
  set -f
}

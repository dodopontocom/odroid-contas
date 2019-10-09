#!/bin/bash
#

docker.build() {
  set +f
  local dockerfile_path message docker_build_cmd docker_image
  
  dockerfile_path=${1:-${BASEDIR}}
  docker_image="contas:$(git branch | grep \* | cut -d' ' -f2)"
  
  message="*Comando docker build em progresso...*"
  ShellBot.sendMessage --chat_id ${message_chat_id[$id]} --text "$(echo -e ${message})" --parse_mode markdown
  
  docker_build_cmd=$(docker build -t ${docker_image} .)
  
  cd ${dockerfile_path}
  ${docker_build_cmd}
  if [[ $? -eq 0 ]]; then
    message="$(docker images | grep -- "${docker_image}")"
    ShellBot.sendMessage --chat_id ${message_chat_id[$id]} --text "$(echo -e ${message})" --parse_mode markdown
  else
    message="Comando falhou : ("
    ShellBot.sendMessage --chat_id ${message_chat_id[$id]} --text "$(echo -e ${message})" --parse_mode markdown
  fi
  set -f
}

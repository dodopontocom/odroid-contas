#!/bin/bash

# Função de suporte
# Função para fazer commit em repositório que faz provisionamento de recursos na cloud do google

REPO_URL="https://github.com/dodopontocom/web-site.git"
TMP_REPO_PATH="/tmp/$(helper.random)"

circle.ci() {
  set +f
  local message cmd

  cmd=$1
  array=(${cmd})
  array[0]="/circleci"
  cmd=${array[@]:1}
  
  message="Fazendo o clone do repo..."
  ShellBot.sendMessage --chat_id ${message_chat_id[$id]} --text "$(echo -e ${message})" --parse_mode markdown
  git clone ${REPO_URL} ${TMP_REPO_PATH}
  
  echo "$(date)" >> ${TMP_REPO_PATH}/web-site/cloud/.telegram.bot
  cd ${TMP_REPO_PATH}/web-site/
  
  git add --all
  git commit -m "[${cmd}] - commit from odroid telegram bot"
  git push -u origin develop
  if [[ $? -e 0 ]]; then
    message="Commit realizado.\n"
    message+="https://app.circleci.com/pipelines/github/dodopontocom/web-site?branch=develop"
    ShellBot.sendMessage --chat_id ${message_chat_id[$id]} --text "$(echo -e ${message})" --parse_mode markdown
  else
    message="Não consegui atualizar o repositório..."
    ShellBot.sendMessage --chat_id ${message_chat_id[$id]} --text "$(echo -e ${message})" --parse_mode markdown
  fi
  
  set -f

}

#git --work-tree=${repo}/ \
#    --git-dir=${repo}/.git pull origin ${branch} | grep "Already up to date."

#!/bin/bash

# Função de suporte

# Faz o pull das atualizações do git da branch que estiver e depois mata o bot para ser reiniciado pelo cron
bot_reset.bot() {
  set +f
  local repo message

  repo="${BASEDIR}"
  branch=$(git branch | grep \* | cut -d' ' -f2)
  
  git --work-tree=${repo}/ \
      --git-dir=${repo}/.git pull origin ${branch} | grep "Already up to date."
  if [[ $? -ne 0 ]]; then
    message="Atualizações foram encontradas, reiniciando o bot..."
    ShellBot.sendMessage --chat_id ${message_chat_id[$id]} --text "$(echo -e ${message})" --parse_mode markdown
    killall contas.sh
  else
    message="Já estou na última versão, nada a fazer por agora!"
    ShellBot.sendMessage --chat_id ${message_chat_id[$id]} --text "$(echo -e ${message})" --parse_mode markdown
  fi
  
  set -f
}

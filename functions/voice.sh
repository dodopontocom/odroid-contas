#!/bin/bash
#

# Comando que transcreve o texto enviado para áudio
# usa a ferramenta 'espeak'
voice.convert() {
  local message array random_file_name
  
  message=$1
  array=(${message})
  array[0]="/voice"
  message=${array[@]:1}
  
  random_file_name=$(helper.random)

  if [[ "${message[@]}" ]]; then
    espeak -vpt -g10 "${message}}" --stdout > /tmp/${random_file_name}.ogg
    ShellBot.sendVoice --chat_id ${message_chat_id[$id]} --voice @/tmp/${random_file_name}.ogg
  else
    ShellBot.sendMessage --chat_id ${message_chat_id[$id]} --text "Please, envie um texto para ser sintetizado" --parse_mode markdown
    ShellBot.sendMessage --chat_id ${message_chat_id[$id]} --text '`/voice <texto qualquer>`' --parse_mode markdown
  fi
}

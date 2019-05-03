#!/bin/bash
#
BASEDIR=$(dirname $0)
txt=${BASEDIR}/texts/start.txt

voice.convert() {
  message=$1
  echo "${message}"
  file_path=/home/ubuntu
  file_name=${file_path}/voice.wav

  if [[ ! -z ${message} ]]; then
    docker run -i --rm -v ${file_path}:/data ozzyjohnson/tts bash -c 'espeak "${message}" --stdout > voice.wav'
    ShellBot.sendVoice --chat_id ${message_chat_id[$id]} --voice @${file_name}
  else
    ShellBot.sendMessage --chat_id ${message_chat_id[$id]} --text "Please, envie um texto" --parse_mode markdown
    ShellBot.sendMessage --chat_id ${message_chat_id[$id]} --text '`/voice <texto qualquer>`' --parse_mode markdown
  fi
}

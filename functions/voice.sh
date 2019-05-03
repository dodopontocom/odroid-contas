#!/bin/bash
#
BASEDIR=$(dirname $0)
txt=${BASEDIR}/texts/start.txt

voice.convert() {
  message=$1
  array=(${message})
  array[0]="/linux"
  message=${array[@]:1}

  if [[ ! -z ${message} ]]; then
    mkdir /tmp/voice
    docker run -i --rm -e "MESSAGE=$message" -v /tmp/voice/:/data -w /data ozzyjohnson/tts bash -c 'espeak "${MESSAGE}" --stdout > voice.wav'
    ShellBot.sendVoice --chat_id ${message_chat_id[$id]} --voice @/tmp/voice/voice.wav
  else
    ShellBot.sendMessage --chat_id ${message_chat_id[$id]} --text "Please, envie um texto" --parse_mode markdown
    ShellBot.sendMessage --chat_id ${message_chat_id[$id]} --text '`/voice <texto qualquer>`' --parse_mode markdown
  fi
}

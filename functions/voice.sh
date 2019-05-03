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
    docker run -i --rm -v /home/ubuntu:/data -w /data ozzyjohnson/tts bash -c 'espeak "test 1 2 3" --stdout > voice.ogg'
    ShellBot.sendVoice --chat_id ${message_chat_id[$id]} --voice @/home/ubuntu/voice.ogg
  else
    ShellBot.sendMessage --chat_id ${message_chat_id[$id]} --text "Please, envie um texto" --parse_mode markdown
    ShellBot.sendMessage --chat_id ${message_chat_id[$id]} --text '`/voice <texto qualquer>`' --parse_mode markdown
  fi
}

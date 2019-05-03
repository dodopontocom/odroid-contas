#!/bin/bash
#
BASEDIR=$(dirname $0)
txt=${BASEDIR}/texts/start.txt

voice.convert() {
  message=$1
  file_path=/home/ubuntu
  file_name=voice.wav

  if [[ ! -z ${message} ]]; then
    docker run \
    -i \
    --rm \
    -v ${file_pat}:/data \
    ozzyjohnson/tts \
    bash -c 'espeak "${message}" --stdout > ${file_name.wav}'
  else
    ShellBot.sendMessage --chat_id ${message_chat_id[$id]} --text "*Please, envie um texto `/speedtest <texto qualquer>`*" --parse_mode markdown
  fi
}

#!/bin/bash
#
BASEDIR=$(dirname $0)
txt=${BASEDIR}/texts/start.txt

voice.convert() {
  message=$1
  array=(${message})
  array[0]="/linux"
  message=${array[@]:1}

  file_path=/home/ubuntu
  file_name=${file_path}/voice.wav

  if [[ ! -z ${message} ]]; then
    #espeak -vpt+f5 --stdout "${voice_command}" > /tmp/voice.ogg
    echo "${message}"
    docker run -i --rm -v ${file_path}:/data -w /data ozzyjohnson/tts bash -c 'espeak "${message}" --stdout > voice.wav'
    ls -lrt ${file_name}
    ShellBot.sendVoice --chat_id ${message_chat_id[$id]} --voice @/root/file.wav
  else
    ShellBot.sendMessage --chat_id ${message_chat_id[$id]} --text "Please, envie um texto" --parse_mode markdown
    ShellBot.sendMessage --chat_id ${message_chat_id[$id]} --text '`/voice <texto qualquer>`' --parse_mode markdown
  fi
}

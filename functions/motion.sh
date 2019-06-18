#!/bin/bash
#
source ${BASEDIR}/functions/random.sh

speedtest.check() {
  local message random_file_name
  message="Aguarde alguns instantes, estou verificando a velocidade da minha internet..."
  random_file_name=$(random.helper)
  
  ShellBot.sendMessage --chat_id ${message_chat_id[$id]} --text "$(echo -e ${message})"
  
  docker run --rm -i python:alpine sh -c "pip install speedtest-cli ; speedtest-cli --bytes --simple" > /tmp/${random_file_name}.txt
  message=$(tail -3 /tmp/${random_file_name}.txt)
  ShellBot.sendMessage --chat_id ${message_chat_id[$id]} --text "$(echo -e ${message})"
}

day="$(date +%Y%m%d)"
detect_folder=/mnt/sdcard/motion/detect/$day
myId=11504381

motion.get() {
  local message tmp has_video
  
  has_video=($(find $detect_folder -name "*.avi"))
  echo $has_video
  
  if [[ ! -z $has_video ]]; then

    #dar um tempinho a mais para o vídeo poder ser concluido
    sleep 30
    message="*Motion Detected!!!*"

    for i in ${has_video[@]}; do
      ShellBot.sendMessage --chat_id $myId --text "$(echo -e ${message})" --parse_mode markdown
      ShellBot.sendVideo --chat_id $myId --video @$i
      tmp="/tmp/$(random.helper).avi"
      mv $i $tmp
    done

  fi
}

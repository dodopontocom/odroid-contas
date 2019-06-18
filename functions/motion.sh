#!/bin/bash
#
source ${BASEDIR}/functions/random.sh
myId=11504381

motion.get() {
  local message tmp has_video day detect_folder
  
  day="$(date +%Y%m%d)"
  detect_folder=/mnt/sdcard/motion/detect/$day
  
  has_video=($(find $detect_folder -name "*.avi"))
  
  if [[ ! -z $has_video ]]; then

    #dar um tempinho a mais para o vídeo poder ser concluido
    sleep 30
    message="*Motion Detected!!!*\n"
    message+="Enviando o(s) vídeo(s) em instantes..."

    for i in ${has_video[@]}; do
      ShellBot.sendMessage --chat_id $myId --text "$(echo -e ${message})" --parse_mode markdown
      ShellBot.sendVideo --chat_id $myId --video @$i
      tmp="/tmp/$(random.helper).avi"
      mv $i $tmp
    done

  fi
}

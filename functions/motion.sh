#!/bin/bash
#

MOTION_NOTIFICATION_IDS=(11504381 449542698)

motion.get() {
  local message tmp ziptmp has_video day detect_folder
  
  day="$(date +%Y%m%d)"
  detect_folder=${MOTION_DETECTED_PATH}/$day
  
  #has_video=($(find $detect_folder -name "*.avi"))
  find $detect_folder -name "*.jpg" > /dev/null 2>&1
  if [[ $? -eq 0 ]]; then
    has_jpg=($(find $detect_folder -name "*.jpg"))
  fi
  
  if [[ ! -z $has_jpg ]]; then

    #cat *.jpg | ffmpeg -f image2pipe -r 1 -vcodec mjpeg -i - -vcodec libx264 out.mp4
    #dar um tempinho a mais para o motion seja concluído
    sleep 30
    message="*Motion Detected!!!*\n"
    message+="Enviando o(s) vídeo(s) em instantes..."
    
    ziptmp="$(random.helper)"
    mkdir /tmp/$ziptmp
    zip /tmp/$ziptmp/$ziptmp.zip $has_jpg 
    
    cd /tmp/$ziptmp/
    unzip $ziptmp.zip
    #ffmpeg -start_number n -i *%d.jpg -vcodec mpeg4 /tmp/$ziptmp.avi
    cat ${has_jpg[@]} | ffmpeg -f image2pipe -r 1 -vcodec mjpeg -i - -vcodec libx264 /tmp/$ziptmp.mp4
    cd -
    rm -vfr ${has_jpg[@]}
    
    for u in ${MOTION_NOTIFICATION_IDS[@]}; do
      ShellBot.sendMessage --chat_id ${u} --text "$(echo -e ${message})" --parse_mode markdown
      ShellBot.sendVideo --chat_id ${u} --video @/tmp/$ziptmp.mp4
    done
    
  fi
  
  if [[ ! -z $has_video ]]; then

    #dar um tempinho a mais para o vídeo poder ser concluido
    sleep 30
    message="*Motion Detected!!!*\n"
    message+="Enviando o(s) vídeo(s) em instantes..."

    for i in ${has_video[@]}; do
      for u in ${MOTION_NOTIFICATION_IDS[@]}; do
        ShellBot.sendMessage --chat_id ${u} --text "$(echo -e ${message})" --parse_mode markdown
        ShellBot.sendVideo --chat_id ${u} --video @$i
        tmp="/tmp/$(random.helper).avi"
        mv $i $tmp
      done
    done

  fi
}

motion.start() {
  local message
  
  [[ "$(ps -w | grep motion)" ]] && killall motion
  motion
  if [[ $? -eq 0 ]]; then
    message="Monitoramento por câmera iniciado"
    ShellBot.sendMessage --chat_id ${message_chat_id[$id]} --text "$(echo -e ${message})"
  else
    message="Houve um problema ao iniciar o monitoramento"
    ShellBot.sendMessage --chat_id ${message_chat_id[$id]} --text "$(echo -e ${message})"
  fi 
}
  
motion.stop() {
  local message
  
  if [[ "$(ps -w | grep motion)" ]]; then
    killall motion
    message="Monitoramento foi desligago."
    ShellBot.sendMessage --chat_id ${message_chat_id[$id]} --text "$(echo -e ${message})" --parse_mode markdown
  else
    message="Monitoramento por câmera não foi iniciado\n"
    message+="use \`/motion on\` se deseja ligá-lo!"
    ShellBot.sendMessage --chat_id ${message_chat_id[$id]} --text "$(echo -e ${message})" --parse_mode markdown
  fi
}

motion.switch() {
    local cmd array message
    
    if [[ $(echo ${NOTIFICATION_IDS[@]} | grep -- "${message_chat_id[$id]}") ]]; then
      cmd=$1
      array=(${cmd})
      array[0]="/motion"
      cmd=${array[@]:1}
      
      if [[ -z ${cmd[@]} ]]; then
        message="Usage: ${array[0]} \`on\` ou \`off\`"
        ShellBot.sendMessage --chat_id ${message_chat_id[$id]} --text "$(echo -e ${message})" --parse_mode markdown
      fi

      if [[ "${cmd[@]}" == "on" ]]; then
        motion.start
      elif [[ "${cmd[@]}" == "off" ]]; then
        motion.stop
      fi
    else
      message="Você não tem permissão de executar este comando."
      ShellBot.sendMessage --chat_id ${message_chat_id[$id]} --text "$(echo -e ${message})" --parse_mode markdown
    fi
}

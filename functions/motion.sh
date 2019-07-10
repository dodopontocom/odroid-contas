#!/bin/bash
#
source ${BASEDIR}/functions/random.sh
myId=11504381

motion.get() {
  local message tmp ziptmp has_video day detect_folder
  
  day="$(date +%Y%m%d)"
  detect_folder=/mnt/sdcard/motion/detect/$day
  
  #has_video=($(find $detect_folder -name "*.avi"))
  has_jpg=($(find $detect_folder -name "*.jpg")) > /dev/null 2>&1
  
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
    
    ShellBot.sendMessage --chat_id $myId --text "$(echo -e ${message})" --parse_mode markdown
    ShellBot.sendVideo --chat_id $myId --video @/tmp/$ziptmp.mp4
    
  fi
  
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


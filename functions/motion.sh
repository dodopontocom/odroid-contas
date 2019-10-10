#!/bin/bash
#

# Função que trata quando a 'motion detected'
motion.get() {
  local message tmp ziptmp has_video day detect_folder
  
  day="$(date +%Y%m%d)"
  detect_folder=${MOTION_DETECTED_PATH}/$day
  
  # Procura por imagens na pasta onde o 'motion' as cria
  # Se houver imagens entao joga todas elas no array 'has_jpg'
  find $detect_folder -name "*.jpg" > /dev/null 2>&1
  if [[ $? -eq 0 ]]; then
    has_jpg=($(find $detect_folder -name "*.jpg"))
  fi
  
  if [[ "${has_jpg}" ]]; then
    sleep 30
    message="⚠️ *Atenção!* ⚠️\n"
    message+="Movimentação foi detectada\n"
    message+="Enviando o(s) vídeo(s) em instantes..."
    
    ziptmp="$(helper.random)"
    mkdir /tmp/$ziptmp
    zip /tmp/$ziptmp/$ziptmp.zip $has_jpg 
    
    cd /tmp/$ziptmp/
    unzip $ziptmp.zip
    
    # Transforma as imagens em um arquivo de vídeo
    cat ${has_jpg[@]} | ffmpeg -f image2pipe -r 1 -vcodec mjpeg -i - -vcodec libx264 /tmp/$ziptmp.mp4
    cd -
    rm -vfr ${has_jpg[@]}
    
    # Envia o vídeo para os IDS selecionados
    for u in ${MOTION_NOTIFICATION_IDS[@]}; do
      ShellBot.sendMessage --chat_id ${u} --text "$(echo -e ${message})" --parse_mode markdown
      ShellBot.sendVideo --chat_id ${u} --video @/tmp/$ziptmp.mp4
    done
    
  fi
}

# Inicia o monitoramento
motion.start() {
  local message
  
  [[ "$(ps -w | grep motion)" ]] && killall motion
  motion
  if [[ $? -eq 0 ]]; then
    message="Monitoramento por câmera iniciado"
    for u in ${MOTION_NOTIFICATION_IDS[@]}; do
      ShellBot.sendMessage --chat_id ${u} --text "$(echo -e ${message})"
    done
  else
    message="Houve um problema ao iniciar o monitoramento"
    ShellBot.sendMessage --chat_id ${message_chat_id[$id]} --text "$(echo -e ${message})"
  fi 
}

# Termina o monitoramento
motion.stop() {
  local message
  
  if [[ "$(ps -w | grep motion)" ]]; then
    killall motion
    message="Monitoramento foi desligado."
    for u in ${MOTION_NOTIFICATION_IDS[@]}; do
      ShellBot.sendMessage --chat_id ${u} --text "$(echo -e ${message})"
    done
  else
    message="Monitoramento por câmera não foi iniciado\n"
    message+="use \`/motion on\` se deseja ligá-lo!"
    ShellBot.sendMessage --chat_id ${message_chat_id[$id]} --text "$(echo -e ${message})" --parse_mode markdown
  fi
}

# Verifica se monitoramento está on ou off
motion.check() {
  local message
  
  ps -w | grep motion
  if [[ $? -eq 0 ]]; then
    message="Monitoramento está ligado!\n"
    message+="Para desligar digite: /motion off"
    ShellBot.sendMessage --chat_id ${message_chat_id[$id]} --text "$(echo -e ${message})" --parse_mode markdown
  else
    message="Monitoramento está desligado!\n"
    message+="Para ligar digite: /motion on"
    ShellBot.sendMessage --chat_id ${message_chat_id[$id]} --text "$(echo -e ${message})" --parse_mode markdown
  fi
}

# Trata e chama as funções de liga ou desliga
motion.switch() {
    local cmd array message
    
    if [[ $(echo ${MOTION_NOTIFICATION_IDS[@]} | grep -- "${message_chat_id[$id]}") ]]; then
      cmd=$1
      array=(${cmd})
      array[0]="/motion"
      cmd=${array[@]:1}
      
      if [[ -z ${cmd[@]} ]]; then
        motion.check
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

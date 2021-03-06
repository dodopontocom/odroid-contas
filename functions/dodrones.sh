#!/bin/bash

# Função de uso pessoal e experimental

#❌
#✅

# Verifica se o HD de backup está montado no odroid
dodrones.check() {
  local user_id message dryrun_cmd percentage_alert

  user_id=$1
  dryrun_cmd="rsync -avn ${DODRONES_HOST}:${DODRONES_HOST_PATH}/ ${DODRONES_DJI_PATH}"
  percentage_alert=$(df -k ${DODRONES_MOUNT_PATH} | awk '{print $5}' | egrep "[7-9][0-9]" | cut -c-2)

  df -h | grep "${DODRONES_MOUNT_PATH}"
  if [[ $? -eq 0 ]]; then
    message="Primeira verificação!\nHD de backup está ativo ✅"
    ShellBot.sendMessage --chat_id ${user_id} --text "$(echo -e ${message})" \
        --parse_mode markdown
    if [[ ${percentage_alert} -gt 75 ]]; then
      message="Apenas um alerta, ${DODRONES_MOUNT_PATH} está com uso de ${percentage_alert}%"
      ShellBot.sendMessage --chat_id ${user_id} --text "$(echo -e ${message})" \
        --parse_mode markdown
    fi

    ${dryrun_cmd}
    if [[ $? -eq 0 ]]; then
      message="Segunda verificação!\nArquivos estão prontos para transferência ✅"
      ShellBot.sendMessage --chat_id ${user_id} --text "$(echo -e ${message})" \
        --parse_mode markdown
      
      message="*Arquivos:*"
      ShellBot.sendMessage --chat_id ${user_id} --text "$(echo -e ${message})" \
        --parse_mode markdown
      ShellBot.sendMessage --chat_id ${user_id} --text "$(${dryrun_cmd})" \
        --parse_mode markdown

      message="Deseja Iniciar backup?"
      ShellBot.sendMessage --chat_id ${user_id} --text "$(echo -e ${message})" \
      --reply_markup "$keyboard_backup" --parse_mode markdown
    else
      message="Não há arquivos para transferência ❌\n"
      message+="Lembre-se de adicionar os arquivos em ${DODRONES_HOST_PATH}"
      ShellBot.sendMessage --chat_id ${user_id} --text "$(echo -e ${message})" \
        --parse_mode markdown  
    fi
  else
    message="❌ HD de backup não está montado ❌"
    ShellBot.sendMessage --chat_id ${user_id} --text "$(echo -e ${message})" \
        --parse_mode markdown
  fi

}

# Faz o back dos arquivos para o HD externo
# Deve-se colocar os arquivos em uma pasta chamada 'bot' assim: ~/Desktop/bot/<pastas e arquivos com as datas para facilitar>
dodrones.execute() {
  local user_id message scp_cmd

  # Enviar para mim apenas, pois é um comando bem exclusivo meu
  user_id=${NOTIFICATION_IDS[0]}

  scp_cmd="scp -r ${DODRONES_HOST}:${DODRONES_HOST_PATH}/ ${DODRONES_DJI_PATH}"

  message="Iniciando o backup, isso pode levar alguns minutos."
  ShellBot.sendMessage --chat_id ${user_id} --text "$(echo -e ${message})" \
    --parse_mode markdown
  
  ${scp_cmd}
  if [[ $? -eq 0 ]]; then
    message="✅ Arquivos enviados com sucesso, mostrando arquivos:"
    ShellBot.sendMessage --chat_id ${user_id} --text "$(echo -e ${message})" \
      --parse_mode markdown
    ShellBot.sendMessage --chat_id ${user_id} --text "$(ls -lrt ${DODRONES_DJI_DEST_PATH})" \
      --parse_mode markdown
  else
    message="Erro ao tentar fazer backup ❌"
    ShellBot.sendMessage --chat_id ${user_id} --text "$(echo -e ${message})" \
      --parse_mode markdown
  fi
}

# Função acionada quando é escolhido não fazer o backup
dodrones.cancel() {
  local message user_id

  # Enviar para mim apenas, pois é um comando bem exclusivo meu
  user_id=${NOTIFICATION_IDS[0]}
  message="Ok, não irei realizar o backup agora."
  ShellBot.sendMessage --chat_id ${user_id} --text "$(echo -e ${message})" --parse_mode markdown
  
}

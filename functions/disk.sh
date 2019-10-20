#!/bin/bash

# Função de suporte

# Avisa quando o diretório / está acima de X porcento do seu total

disk.check() {
  local cmd dir tens unity minimum
  
  dir=$1
  minimum=$2

  if [[ -d "${dir}" ]]; then
    result=$(df -k "${dir}" | awk '{print $5}' | egrep "[0-9]" | cut -c-2)
    if [[ ${result} -gt ${minimum} ]]; then
      echo ${result}
    fi
  fi

}

disk.warn() {
  local dir minimum message alert notifications_to

  notifications_to=$3

  if [[ "${notifications_to}" ]]; then
    dir=$1
    minimum=$2
    final_not_id=${notifications_to}
    dont_notify=true
  else
    disk=$1
    array=(${disk})
    array[0]="/disk"
    disk=(${array[@]:1})

    dir=${disk[0]}
    minimum=${disk[1]}

    final_not_id=${message_chat_id[$id]}
  fi

  alert=$(disk.check "${dir}" "${minimum}")

  if [[ "${alert}" ]]; then
    message="*Aviso de verificação de espaço em diretório!\n*"
    message+="Diretório: ${dir}\n"
    message+="Verificar quando estiver acima de ${minimum}% de espaço usado.\n"
    message+="Porcentagem atual é de *${alert}%*"
    ShellBot.sendMessage --chat_id ${final_not_id} --text "$(echo -e ${message})" --parse_mode markdown
  else
    message="Diretório está Ok!\n"
    message="Espaço livre está abaixo de *${minimum}%*"
    if [[ -z ${dont_notify} ]]; then
      ShellBot.sendMessage --chat_id ${final_not_id} --text "$(echo -e ${message})" --parse_mode markdown
    fi
  fi
}

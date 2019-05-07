#!/bin/bash
#
source ${BASEDIR}/functions/random.sh
source ${BASEDIR}/functions/iscreated.sh

contas.cmd() {
  ShellBot.sendMessage --chat_id ${message_chat_id[$id]} --text "Escolha uma opção" --reply_markup "$keyboard1"
}
contas.list() {
  local message user_folder this_month
  user_folder=${BASEDIR}/db/${callback_query_from_id}
  this_month="$(date +%b%Y).csv"

  message="Listando contas... Aguarde..."
  iscreated.helper -d "${user_folder}"
  ShellBot.answerCallbackQuery --callback_query_id ${callback_query_id[$id]} --text "$(echo -e ${message})"
  ShellBot.sendMessage --chat_id ${callback_query_message_chat_id[$id]} --text "$(cat ${user_folder}/${this_month})" --parse_mode markdown
}
contas.add() {
  echo add
}
contas.rm() {
  echo rm
}


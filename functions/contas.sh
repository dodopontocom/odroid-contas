#!/bin/bash
#
source ${BASEDIR}/functions/random.sh

contas.cmd() {
  ShellBot.sendMessage --chat_id ${message_chat_id[$id]} --text "Escolha uma opção" --reply_markup "$keyboard1"
}
contas.list() {
  local message
  message="*...Listando contas (aguarde)*"
  #ShellBot.answerCallbackQuery --callback_query_id ${callback_query_id[$id]} --text "aguarde..."
  #ShellBot.sendMessage --chat_id ${callback_query_message_chat_id[$id]} --text "$(echo -e ${message})" --parse_mode markdown
}
contas.add() {
  echo add
}
contas.rm() {
  echo rm
}


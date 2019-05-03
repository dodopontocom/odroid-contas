#!/bin/bash
#
BASEDIR=$(dirname $0)
source ${BASEDIR}/ShellBot.sh

btn_how() {
	ShellBot.sendMessage --chat_id ${message_chat_id[$id]} --text "*$(echo -e '*hello from _how*')"
	ShellBot.answerCallbackQuery --callback_query_id ${callback_query_id[$id]} \
					--text "TEST_HOW"
}
btn_hints() {
	ShellBot.sendMessage --chat_id ${message_chat_id[$id]} --text "*$(echo -e '*hello from _hints*')"
	ShellBot.answerCallbackQuery --callback_query_id ${callback_query_id[$id]} \
					--text "TEST_HINTS"
}

start.sendGreetings() {
  botao=''
  ShellBot.InlineKeyboardButton --button 'botao' --line 1 --text 'Como funciono...' --callback_data 'btn_how'
  ShellBot.InlineKeyboardButton --button 'botao' --line 2 --text 'Dicas...' --callback_data 'btn_hints'
  ShellBot.regHandleFunction --function btn_how --callback_data btn_how
  ShellBot.regHandleFunction --function btn_hints --callback_data btn_hints
  keyboard1="$(ShellBot.InlineKeyboardMarkup -b 'botao')"
  
  message="olá "
  
  if [[ ! -z $message_from_first_name ]]; then
    message+=${message_from_first_name}
  else
    message+=${message_from_id}
  fi
  ShellBot.sendMessage --chat_id ${message_chat_id[$id]} --text "*$(echo -e "${message}")*" --reply_markup "$keyboard1" --parse_mode markdown
}

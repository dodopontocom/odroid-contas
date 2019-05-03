#!/bin/bash
#
BASEDIR=$(dirname $0)

_how() {
	ShellBot.sendMessage --chat_id ${message_chat_id[$id]} --text "*$(echo -e '*hello from _how*'"
	ShellBot.answerCallbackQuery --callback_query_id ${callback_query_id[$id]} \
					--text "TEST_HOW"
}
_hints() {
	ShellBot.sendMessage --chat_id ${message_chat_id[$id]} --text "*$(echo -e '*hello from _hints*'"
	ShellBot.answerCallbackQuery --callback_query_id ${callback_query_id[$id]} \
					--text "TEST_HINTS"
}

start.sendGreetings() {
  botao=''
  ShellBot.InlineKeyboardButton --button 'botao' --line 1 --text 'Como funciono...' --callback_data 'btn_how'
  ShellBot.InlineKeyboardButton --button 'botao' --line 2 --text 'Dicas...' --callback_data 'btn_hints'
  ShellBot.regHandleFunction --function _how --callback_data btn_how
  ShellBot.regHandleFunction --function _hints --callback_data btn_hints
  keyboard1="$(ShellBot.InlineKeyboardMarkup -b 'botao')"
  
  message="olá "
  
  if [[ ! -z $message_from_first_name ]]; then
    message+=${message_from_first_name}
  else
    message+=${message_from_id}
  fi
  ShellBot.sendMessage --chat_id ${message_chat_id[$id]} --text "*Pois não ${message_from_first_name} ...*" \
							--reply_markup "$keyboard1"
  ShellBot.sendMessage --chat_id ${message_chat_id[$id]} --text "*$(echo -e "${message}")*" --reply_markup "$keyboard1"
}

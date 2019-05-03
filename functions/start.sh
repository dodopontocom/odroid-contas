#!/bin/bash
#
BASEDIR=$(dirname $0)
source ${BASEDIR}/functions/buttons.sh

start.sendGreetings() {
  botao=''
  ShellBot.InlineKeyboardButton --button 'botao' --line 1 --text 'Como funciono...' --callback_data 'btn_how'
  ShellBot.InlineKeyboardButton --button 'botao' --line 2 --text 'Dicas...' --callback_data 'btn_hints'
  ShellBot.regHandleFunction --function servo_function --callback_data btn_how
  ShellBot.regHandleFunction --function motion_function --callback_data btn_hints
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

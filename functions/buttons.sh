#!/bin/bash

BASEDIR=$(dirname $0)
source ${BASEDIR}/../ShellBot.sh

buttons.inLine() {
  botao=''

  ShellBot.InlineKeyboardButton --button 'botao' --line 1 --text 'Como funciono' --callback_data 'btn_how'
  ShellBot.InlineKeyboardButton --button 'botao' --line 2 --text 'Dicas' --callback_data 'btn_hints'

  ShellBot.regHandleFunction --function servo_function --callback_data btn_how
  ShellBot.regHandleFunction --function motion_function --callback_data btn_hints

  keyboard1="$(ShellBot.InlineKeyboardMarkup -b 'botao')"
}

#!/bin/bash
BASEDIR=$(dirname $0)
source ${BASEDIR}/ShellBot.sh

bills.list() {
    echo "list"
}
bills.add() {
    echo "add"
}
bills.rm() {
    echo "rm"
}

botao1=''
ShellBot.InlineKeyboardButton --button 'botao1' --line 1 --text 'Listar' --callback_data 'btn_list'
ShellBot.InlineKeyboardButton --button 'botao1' --line 2 --text 'Adicionar' --callback_data 'btn_add'
ShellBot.InlineKeyboardButton --button 'botao1' --line 3 --text 'Remover' --callback_data 'btn_rm'
ShellBot.regHandleFunction --function contas.list --callback_data btn_list
ShellBot.regHandleFunction --function contas.add --callback_data btn_add
ShellBot.regHandleFunction --function contas.rm --callback_data btn_rm
keyboard1="$(ShellBot.InlineKeyboardMarkup -b 'botao1')"
#!/bin/bash

contas.show_keyboard() {
    local message cada_conta
    
    botao_contas=''

    cada_conta=($(while read line; do echo "${line}" | cut -d',' -f2; done < ${BOT_CONTAS_LIST}))
    for c in ${cada_conta[@]}; do    
        ShellBot.InlineKeyboardButton --button 'botao_contas' --text "${c}" --callback_data 'item_conta' --line 1
    done

    keyboard_contas="$(ShellBot.InlineKeyboardMarkup -b 'botao_contas')"

    message="*Contas do Mês*"
    ShellBot.sendMessage --chat_id ${message_chat_id[$id]} \
                            --text "*${message}*" \
                            --parse_mode markdown \
                            --reply_markup "$keyboard_contas"

        
}

#!/bin/bash

contas.show_keyboard() {
    local message cada_conta
    
    botao_contas=''

    name_conta=($(while read line; do echo "${line}" | cut -d',' -f2; done < ${BOT_CONTAS_LIST}))
    status_conta=($(while read line; do echo "${line}" | cut -d',' -f3; done < ${BOT_CONTAS_LIST}))
    quant_contas=$(cat ${BOT_CONTAS_LIST} | wc -l)
    keyborad_line=(1 1 2 2 3 3 4 4 5 5 6 6 7 7 8 8 9 9 10 10 11 11 12 12 13 13 14 14 15 15 16 16 17 17 18 18 19 19 20 20)
    
    for c in ${!name_conta[@]}; do
        ShellBot.InlineKeyboardButton --button 'botao_contas' \
                                    --text "${name_conta[$c]} ${status_conta[$c]}" \
                                    --callback_data "contas.${name_conta[$c]}" \
                                    --line ${keyborad_line[$c]}
    done

    keyboard_contas="$(ShellBot.InlineKeyboardMarkup -b 'botao_contas')"

    message="Contas do Mês"
    ShellBot.sendMessage --chat_id ${message_chat_id[$id]} \
                            --text "*${message}*" \
                            --parse_mode markdown \
                            --reply_markup "$keyboard_contas"

        
}

contas.Moto() {
    echo moto
}
#!/bin/bash

contas.show_keyboard() {
    local message cada_conta
    
    botao_contas=''

    cada_conta=($(while read line; do echo "${line}" | cut -d',' -f2; done < ${BOT_CONTAS_LIST}))
    declare -A cada_linha
    quant_contas=$(cat ${BOT_CONTAS_LIST} | wc -l)
    for i in $(seq 1 ${quant_contas}); do
        if [[ ${i} -le 3 ]]; then
            cada_linha+=(['1']=${i})
        elif [[ ${i} -le 6 ]]; then
            cada_linha+=(['2']=${i})
        elif [[ ${i} -le 9 ]]; then
            cada_linha+=(['3']=${i})
        elif [[ ${i} -le 12 ]]; then
            cada_linha+=(['4']=${i})
        elif [[ ${i} -le 15 ]]; then
            cada_linha+=(['5']=${i})
        fi
    done
    echo "------------ ${cada_linha[@]}"
    for c in ${cada_conta[@]}; do
        ShellBot.InlineKeyboardButton --button 'botao_contas' --text "${c}" --callback_data 'item_conta' --line ${cada_linha["${c}"]}
    done

    keyboard_contas="$(ShellBot.InlineKeyboardMarkup -b 'botao_contas')"

    message="Contas do Mês"
    ShellBot.sendMessage --chat_id ${message_chat_id[$id]} \
                            --text "*${message}*" \
                            --parse_mode markdown \
                            --reply_markup "$keyboard_contas"

        
}

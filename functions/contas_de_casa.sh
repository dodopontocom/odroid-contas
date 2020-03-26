#!/bin/bash
# 🔟 0⃣ 9⃣ 8⃣ 7⃣ 6⃣ 5⃣ 4⃣ 3⃣ 2⃣ 1⃣ 🆘 ‼ ❗ 😁  👌



contas.show_keyboard() {
    local message cada_conta
    
    botao_contas=''

    #name_conta=($(while read line; do echo "${line}" | cut -d',' -f2; done < ${BOT_CONTAS_LIST}))
    name_conta=($(while read line; do echo "${line}"; done < ${BOT_CONTAS_LIST}))
    status_conta=($(while read line; do echo "${line}"; done < ${BOT_CONTAS_LIST}))
    quant_contas=$(cat ${BOT_CONTAS_LIST} | wc -l)
    count_down=(🔟 0⃣🆘 9⃣ 8⃣ 7⃣ 6⃣ 5⃣ 4⃣ 3⃣ 2⃣❗ 1⃣‼)
    keyborad_line=(1 1 2 2 3 3 4 4 5 5 6 6 7 7 8 8 9 9 10 10 11 11 12 12 13 13 14 14 15 15 16 16 17 17 18 18 19 19 20 20)
    
    for c in ${!name_conta[@]}; do
        ShellBot.InlineKeyboardButton --button 'botao_contas' \
                                    --text "$(echo ${name_conta[$c]}| cut -d',' -f2) $(echo ${status_conta[$c]} | cut -d',' -f3)" \
                                    --callback_data "contas.$(echo ${name_conta[$c]} | cut -d',' -f2)" \
                                    --line ${keyborad_line[$c]}
    done

    keyboard_contas="$(ShellBot.InlineKeyboardMarkup -b 'botao_contas')"

    message="Contas do Mês"
    ShellBot.sendMessage --chat_id ${message_chat_id[$id]} \
                            --text "*${message}*" \
                            --parse_mode markdown \
                            --reply_markup "$keyboard_contas"

        
}

contas.start() {
    case ${callback_query_data} in
        contas.Moto)
            helper.date_arithimetic "days_from_today" "$(cat ${BOT_CONTAS_LIST} | grep Moto | cut -d',' -f1)"
            ;;
        contas.Carro) echo Carro
            ;;
        contas.IPTU_APTO) echo IPTU_APTO
            ;;
        contas.IPTU_DALIAS)
            echo IPTU_DALIAS
            ;;
        contas.POXNET) echo POXNET
            ;;
        contas.LUZ) echo LUZ
            ;;
    esac
}
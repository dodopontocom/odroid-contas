#!/bin/bash
# 🔟 0⃣ 9⃣ 8⃣ 7⃣ 6⃣ 5⃣ 4⃣ 3⃣ 2⃣ 1⃣ 🆘 ‼ ❗ 😁  👌 🕐

COUNT=(0⃣🆘 1⃣‼ 2⃣❗ 3⃣ 4⃣ 5⃣ 6⃣ 7⃣ 8⃣ 9⃣ 🔟)
MESES=(0 Janeiro Fevereiro Março Abril Maio Junho Julho Agosto Setembro Outubro Novembro Dezembro)

CONTAS_ARR=($(cat ${BOT_CONTAS_LIST} | cut -d',' -f5))
CONTAS_SIM_ARR=($(cat ${BOT_CONTAS_LIST} | cut -d',' -f6))
CONTAS_NAO_ARR=($(cat ${BOT_CONTAS_LIST} | cut -d',' -f7))

contas.verifica_mes() {
    local mes_agora mes_contas is_payed
    
    mes_agora=$1
    
    while read line; do
        mes_contas=$(echo ${line} | cut -d'-' -f2)
        if [[ "${mes_agora}" != "${mes_contas}" ]] && [[ "$(echo ${line} | cut -d',' -f3)" != "0" ]]; then
        #se mes mudou e conta foi paga, entao mudar o vencimento para mes atual
            _date=$(echo ${line} | cut -d',' -f1)
            _day=$(echo ${line} | cut -d'-' -f3 | cut -d',' -f1)
            _new_date="$(date +%Y)-${mes_agora}-${_day}"
            _conta=$(echo ${line} | cut -d',' -f2)
            _zero=$(echo ${line} | cut -d',' -f3)
            sed -i "s/${_date},${_conta},${_zero},/${_new_date},${_conta},0,/" ${BOT_CONTAS_LIST}
        fi
    done < ${BOT_CONTAS_LIST}
}

contas.show_keyboard() {
    local message cada_conta days
    
    botao_contas=''

    name_conta=($(while read line; do echo "${line}"; done < ${BOT_CONTAS_LIST}))
    quant_contas=$(cat ${BOT_CONTAS_LIST} | wc -l)
    
    keyborad_line=(1 1 2 2 3 3 4 4 5 5 6 6 7 7 8 8 9 9 10 10 11 11 12 12 13 13 14 14 15 15 16 16 17 17 18 18 19 19 20 20)
    
    for c in ${!name_conta[@]}; do
        days=$(helper.date_arithimetic "days_from_today" "$(cat ${BOT_CONTAS_LIST} | grep $(echo ${name_conta[$c]} | cut -d',' -f2) | cut -d',' -f1)")
        is_payed="$(echo ${name_conta[$c]}| cut -d',' -f3)"
        if [[ "${is_payed}" != "0" ]]; then
            status_conta="👌"
        elif [[ ${days} -ge 0 ]] && [[ ${days} -le 10 ]]; then
            status_conta=${COUNT[$days]}
        elif [[ ${days} -ge 11 ]]; then
            status_conta="🕐"
        else
            status_conta="🕐❗"
        fi
        ShellBot.InlineKeyboardButton --button 'botao_contas' \
                                    --text "$(echo ${name_conta[$c]}| cut -d',' -f2) ${status_conta}" \
                                    --callback_data "contas.$(echo ${name_conta[$c]} | cut -d',' -f2)" \
                                    --line ${keyborad_line[$c]}
    done

    keyboard_contas="$(ShellBot.InlineKeyboardMarkup -b 'botao_contas')"

    mes=$(date +%m | sed 's/0//')
    message="Contas do Mês de ${MESES[$mes]}"
    ShellBot.sendMessage --chat_id ${message_chat_id[$id]} \
                            --text "*${message}*" \
                            --parse_mode markdown \
                            --reply_markup "$keyboard_contas"

        
}

contas.text_return() {
    local conta vencimento _days type_pay _is_payed pay_message _message

    conta=$1
    vencimento="$(cat ${BOT_CONTAS_LIST} | grep ${conta} | cut -d',' -f1)"
    _days=$(helper.date_arithimetic "days_from_today" "$(cat ${BOT_CONTAS_LIST} | grep ${conta} | cut -d',' -f1)")
    type_pay="$(cat ${BOT_CONTAS_LIST} | grep ${conta} | cut -d',' -f4)"
    _is_payed="$(cat ${BOT_CONTAS_LIST} | grep ${conta} | cut -d',' -f3)"
    if [[ "${_is_payed}" != "0" ]]; then
        pay_message="*Pago em:* ${_is_payed}.\n*Vencimento:* ${vencimento}"
    else
        pay_message="*A PAGAR*! Vence em: *${vencimento}*\nFalta(m) *${_days}* dia(s) para o vencimento"
    fi
        
    _message="*Conta:* ${conta} \n"
    _message+="${pay_message} \n"
    _message+="*Tipo de pagamento:* ${type_pay}"
    echo ${_message}

}

contas.yesno_button() {
    local conta _keyboard

    conta=$1
    _is_payed="$(cat ${BOT_CONTAS_LIST} | grep ${conta} | cut -d',' -f3)"
    if [[ ${_is_payed} == "0" ]]; then
        eval ${conta}=''
        ShellBot.InlineKeyboardButton --button "${conta}" \
                                --text "SIM" \
                                --callback_data "contas.${conta}SIM" \
                                --line 1
        ShellBot.InlineKeyboardButton --button "${conta}" \
                                --text "NAO" \
                                --callback_data "contas.${conta}NAO" \
                                --line 1
        _keyboard="$(ShellBot.InlineKeyboardMarkup -b ${conta})"

        message="DAR BAIXA NA CONTA (${conta}) ?"
        ShellBot.sendMessage --chat_id ${callback_query_message_chat_id[$id]} \
                        --text "*${message}*" \
                        --parse_mode markdown \
                        --reply_markup "$_keyboard"
    fi
}

contas.show_contas() {

    local days
    for c in ${CONTAS_ARR[@]}; do
        case ${callback_query_data} in
            ${c})
            message="$(contas.text_return ${c/*./})"
            ShellBot.answerCallbackQuery --callback_query_id ${callback_query_id[$id]}
            ShellBot.sendMessage --chat_id ${callback_query_message_chat_id[$id]} \
                                --text "$(echo -e ${message})" --parse_mode markdown

            contas.yesno_button "${c/*./}"

            ;;
        esac
    done
}
contas.yesno_buttons() {    
    for s in ${CONTAS_SIM_ARR[@]}; do
    set +f
        case ${callback_query_data} in
            ${s})
                today=$(date "+%Y-%m-%d")
                sed -i "s/$(echo ${s/*./} | sed 's/SIM//g' | sed 's/NAO//g'),0,/$(echo ${s/*./} | sed 's/SIM//g' | sed 's/NAO//g'),${today},/" ${BOT_CONTAS_LIST}
                message="*Registro efetuado com sucesso*\n"
                message+="Clique em contas novamente para conferir\n\n"
                message+="/contas"
                ShellBot.answerCallbackQuery --callback_query_id ${callback_query_id[$id]}
                ShellBot.sendMessage --chat_id ${callback_query_message_chat_id[$id]} \
                                    --text "$(echo -e ${message})" --parse_mode markdown
                        
            ;;
        esac
    set -f
    done
    
    for n in ${CONTAS_NAO_ARR[@]}; do
        case ${callback_query_data} in
            ${n})
                message="*Pagar mais tarde então* 😁"
                ShellBot.answerCallbackQuery --callback_query_id ${callback_query_id[$id]}
                ShellBot.sendMessage --chat_id ${callback_query_message_chat_id[$id]} \
                                    --text "$(echo -e ${message})" --parse_mode markdown
                            
            ;;
        esac
    done
}

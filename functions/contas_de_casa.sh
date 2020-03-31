#!/bin/bash
# 🔟 0⃣ 9⃣ 8⃣ 7⃣ 6⃣ 5⃣ 4⃣ 3⃣ 2⃣ 1⃣ 🆘 ‼ ❗ 😁  👌 🕐

COUNT=(0⃣🆘 1⃣‼ 2⃣❗ 3⃣ 4⃣ 5⃣ 6⃣ 7⃣ 8⃣ 9⃣ 🔟)
MESES=(0 Janeiro Fevereiro Março Abril Maio Junho Julho Agosto Setembro Outubro Novembro Dezembro)

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
        pay_message="Pago em ${_is_payed}.\n*Vencimento:* ${vencimento}"
    else
        pay_message="*A PAGAR*, vence em *${vencimento}*\nFalta(m) *${_days}* dias para o vencimento"
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

contas.start() {

    local days

    case ${callback_query_data} in
        contas.VIVOTSIM)
            today=$(date "+%Y-%m-%d")
            sed -i "s/VIVOT,0,/VIVOT,${today},/" ${BOT_CONTAS_LIST}
            message="*Registro efetuado com sucesso*\n"
            message+="Clique em contas novamente para conferir\n\n"
            message+="/contas"
            ShellBot.answerCallbackQuery --callback_query_id ${callback_query_id[$id]}
            ShellBot.sendMessage --chat_id ${callback_query_message_chat_id[$id]} \
                                --text "$(echo -e ${message})" --parse_mode markdown
                        
            ;;
        contas.VIVOTNAO)
            message="*Pagar mais tarde então* 😁"
            ShellBot.answerCallbackQuery --callback_query_id ${callback_query_id[$id]}
            ShellBot.sendMessage --chat_id ${callback_query_message_chat_id[$id]} \
                                --text "$(echo -e ${message})" --parse_mode markdown
                        
            ;;
        contas.CARROSIM)
            today=$(date "+%Y-%m-%d")
            sed -i "s/CARRO,0,/CARRO,${today},/" ${BOT_CONTAS_LIST}
            message="*Registro efetuado com sucesso*\n"
            message+="Clique em contas novamente para conferir\n\n"
            message+="/contas"
            ShellBot.answerCallbackQuery --callback_query_id ${callback_query_id[$id]}
            ShellBot.sendMessage --chat_id ${callback_query_message_chat_id[$id]} \
                                --text "$(echo -e ${message})" --parse_mode markdown
                        
            ;;
        contas.CARRONAO)
            message="*Pagar mais tarde então* 😁"
            ShellBot.answerCallbackQuery --callback_query_id ${callback_query_id[$id]}
            ShellBot.sendMessage --chat_id ${callback_query_message_chat_id[$id]} \
                                --text "$(echo -e ${message})" --parse_mode markdown
                        
            ;;
        contas.CARRO)
            
            message="$(contas.text_return CARRO)"
            ShellBot.answerCallbackQuery --callback_query_id ${callback_query_id[$id]}
            ShellBot.sendMessage --chat_id ${callback_query_message_chat_id[$id]} \
                                --text "$(echo -e ${message})" --parse_mode markdown

            contas.yesno_button "CARRO"
            
            ;;
    contas.SAAE)

            message="$(contas.text_return SAAE)"
            ShellBot.answerCallbackQuery --callback_query_id ${callback_query_id[$id]}
            ShellBot.sendMessage --chat_id ${callback_query_message_chat_id[$id]} \
                                --text "$(echo -e ${message})" --parse_mode markdown

            contas.yesno_button "SAAE"
            
            ;;
        contas.SAAESIM)
            today=$(date "+%Y-%m-%d")
            sed -i "s/SAAE,0,/SAAE,${today},/" ${BOT_CONTAS_LIST}
            message="*Registro efetuado com sucesso*\n"
            message+="Clique em contas novamente para conferir\n\n"
            message+="/contas"
            ShellBot.answerCallbackQuery --callback_query_id ${callback_query_id[$id]}
            ShellBot.sendMessage --chat_id ${callback_query_message_chat_id[$id]} \
                                --text "$(echo -e ${message})" --parse_mode markdown
                        
            ;;
        contas.SAAENAO)
            message="*Pagar mais tarde então* 😁"
            ShellBot.answerCallbackQuery --callback_query_id ${callback_query_id[$id]}
            ShellBot.sendMessage --chat_id ${callback_query_message_chat_id[$id]} \
                                --text "$(echo -e ${message})" --parse_mode markdown
                        
            ;;
        contas.IPTUV)
            
            message="$(contas.text_return IPTUV)"
            ShellBot.answerCallbackQuery --callback_query_id ${callback_query_id[$id]}
            ShellBot.sendMessage --chat_id ${callback_query_message_chat_id[$id]} \
                                --text "$(echo -e ${message})" --parse_mode markdown

            contas.yesno_button "IPTUV"
            
            ;;
            contas.IPTUVSIM)
            today=$(date "+%Y-%m-%d")
            sed -i "s/IPTUV,0,/IPTUV,${today},/" ${BOT_CONTAS_LIST}
            message="*Registro efetuado com sucesso*\n"
            message+="Clique em contas novamente para conferir\n\n"
            message+="/contas"
            ShellBot.answerCallbackQuery --callback_query_id ${callback_query_id[$id]}
            ShellBot.sendMessage --chat_id ${callback_query_message_chat_id[$id]} \
                                --text "$(echo -e ${message})" --parse_mode markdown
                        
            ;;
        contas.IPTUVNAO)
            message="*Pagar mais tarde então* 😁"
            ShellBot.answerCallbackQuery --callback_query_id ${callback_query_id[$id]}
            ShellBot.sendMessage --chat_id ${callback_query_message_chat_id[$id]} \
                                --text "$(echo -e ${message})" --parse_mode markdown
                        
            ;;
        contas.IPTUD)
            
            message="$(contas.text_return IPTUD)"
            ShellBot.answerCallbackQuery --callback_query_id ${callback_query_id[$id]}
            ShellBot.sendMessage --chat_id ${callback_query_message_chat_id[$id]} \
                                --text "$(echo -e ${message})" --parse_mode markdown

            contas.yesno_button "IPTUD"
            ;;
            contas.IPTUDSIM)
            today=$(date "+%Y-%m-%d")
            sed -i "s/IPTUD,0,/IPTUD,${today},/" ${BOT_CONTAS_LIST}
            message="*Registro efetuado com sucesso*\n"
            message+="Clique em contas novamente para conferir\n\n"
            message+="/contas"
            ShellBot.answerCallbackQuery --callback_query_id ${callback_query_id[$id]}
            ShellBot.sendMessage --chat_id ${callback_query_message_chat_id[$id]} \
                                --text "$(echo -e ${message})" --parse_mode markdown
                        
            ;;
        contas.IPTUDNAO)
            message="*Pagar mais tarde então* 😁"
            ShellBot.answerCallbackQuery --callback_query_id ${callback_query_id[$id]}
            ShellBot.sendMessage --chat_id ${callback_query_message_chat_id[$id]} \
                                --text "$(echo -e ${message})" --parse_mode markdown
                        
            ;;
        contas.POXNET)
            
            message="$(contas.text_return POXNET)"
            ShellBot.answerCallbackQuery --callback_query_id ${callback_query_id[$id]}
            ShellBot.sendMessage --chat_id ${callback_query_message_chat_id[$id]} \
                                --text "$(echo -e ${message})" --parse_mode markdown

            contas.yesno_button "POXNET"

            ;;
            contas.POXNETSIM)
            today=$(date "+%Y-%m-%d")
            sed -i "s/POXNET,0,/POXNET,${today},/" ${BOT_CONTAS_LIST}
            message="*Registro efetuado com sucesso*\n"
            message+="Clique em contas novamente para conferir\n\n"
            message+="/contas"
            ShellBot.answerCallbackQuery --callback_query_id ${callback_query_id[$id]}
            ShellBot.sendMessage --chat_id ${callback_query_message_chat_id[$id]} \
                                --text "$(echo -e ${message})" --parse_mode markdown
                        
            ;;
        contas.POXNETNAO)
            message="*Pagar mais tarde então* 😁"
            ShellBot.answerCallbackQuery --callback_query_id ${callback_query_id[$id]}
            ShellBot.sendMessage --chat_id ${callback_query_message_chat_id[$id]} \
                                --text "$(echo -e ${message})" --parse_mode markdown
                        
            ;;
        contas.CPFL)
    
            message="$(contas.text_return CPFL)"
            ShellBot.answerCallbackQuery --callback_query_id ${callback_query_id[$id]}
            ShellBot.sendMessage --chat_id ${callback_query_message_chat_id[$id]} \
                                --text "$(echo -e ${message})" --parse_mode markdown

            contas.yesno_button "CPFL"

            ;;
            contas.CPFLSIM)
            today=$(date "+%Y-%m-%d")
            sed -i "s/CPFL,0,/CPFL,${today},/" ${BOT_CONTAS_LIST}
            message="*Registro efetuado com sucesso*\n"
            message+="Clique em contas novamente para conferir\n\n"
            message+="/contas"
            ShellBot.answerCallbackQuery --callback_query_id ${callback_query_id[$id]}
            ShellBot.sendMessage --chat_id ${callback_query_message_chat_id[$id]} \
                                --text "$(echo -e ${message})" --parse_mode markdown
                        
            ;;
        contas.CPFLNAO)
            message="*Pagar mais tarde então* 😁"
            ShellBot.answerCallbackQuery --callback_query_id ${callback_query_id[$id]}
            ShellBot.sendMessage --chat_id ${callback_query_message_chat_id[$id]} \
                                --text "$(echo -e ${message})" --parse_mode markdown
                        
            ;;
        contas.NUBANKR)
    
            message="$(contas.text_return NUBANKR)"
            ShellBot.answerCallbackQuery --callback_query_id ${callback_query_id[$id]}
            ShellBot.sendMessage --chat_id ${callback_query_message_chat_id[$id]} \
                                --text "$(echo -e ${message})" --parse_mode markdown

            contas.yesno_button "NUBANKR"

            ;;
            contas.NUBANKRSIM)
            today=$(date "+%Y-%m-%d")
            sed -i "s/NUBANKR,0,/NUBANKR,${today},/" ${BOT_CONTAS_LIST}
            message="*Registro efetuado com sucesso*\n"
            message+="Clique em contas novamente para conferir\n\n"
            message+="/contas"
            ShellBot.answerCallbackQuery --callback_query_id ${callback_query_id[$id]}
            ShellBot.sendMessage --chat_id ${callback_query_message_chat_id[$id]} \
                                --text "$(echo -e ${message})" --parse_mode markdown
                        
            ;;
        contas.NUBANKRNAO)
            message="*Pagar mais tarde então* 😁"
            ShellBot.answerCallbackQuery --callback_query_id ${callback_query_id[$id]}
            ShellBot.sendMessage --chat_id ${callback_query_message_chat_id[$id]} \
                                --text "$(echo -e ${message})" --parse_mode markdown
                        
            ;;
        contas.NUBANKT)
    
            message="$(contas.text_return NUBANKT)"
            ShellBot.answerCallbackQuery --callback_query_id ${callback_query_id[$id]}
            ShellBot.sendMessage --chat_id ${callback_query_message_chat_id[$id]} \
                                --text "$(echo -e ${message})" --parse_mode markdown

            contas.yesno_button "NUBANKT"

            ;;
            contas.NUBANKTSIM)
            today=$(date "+%Y-%m-%d")
            sed -i "s/NUBANKT,0,/NUBANKT,${today},/" ${BOT_CONTAS_LIST}
            message="*Registro efetuado com sucesso*\n"
            message+="Clique em contas novamente para conferir\n\n"
            message+="/contas"
            ShellBot.answerCallbackQuery --callback_query_id ${callback_query_id[$id]}
            ShellBot.sendMessage --chat_id ${callback_query_message_chat_id[$id]} \
                                --text "$(echo -e ${message})" --parse_mode markdown
                        
            ;;
        contas.NUBANKTNAO)
            message="*Pagar mais tarde então* 😁"
            ShellBot.answerCallbackQuery --callback_query_id ${callback_query_id[$id]}
            ShellBot.sendMessage --chat_id ${callback_query_message_chat_id[$id]} \
                                --text "$(echo -e ${message})" --parse_mode markdown
                        
            ;;
        contas.RENNER)
    
            message="$(contas.text_return RENNER)"
            ShellBot.answerCallbackQuery --callback_query_id ${callback_query_id[$id]}
            ShellBot.sendMessage --chat_id ${callback_query_message_chat_id[$id]} \
                                --text "$(echo -e ${message})" --parse_mode markdown

            contas.yesno_button "RENNER"

            ;;
            contas.RENNERSIM)
            today=$(date "+%Y-%m-%d")
            sed -i "s/RENNER,0,/RENNER,${today},/" ${BOT_CONTAS_LIST}
            message="*Registro efetuado com sucesso*\n"
            message+="Clique em contas novamente para conferir\n\n"
            message+="/contas"
            ShellBot.answerCallbackQuery --callback_query_id ${callback_query_id[$id]}
            ShellBot.sendMessage --chat_id ${callback_query_message_chat_id[$id]} \
                                --text "$(echo -e ${message})" --parse_mode markdown
                        
            ;;
        contas.RENNERNAO)
            message="*Pagar mais tarde então* 😁"
            ShellBot.answerCallbackQuery --callback_query_id ${callback_query_id[$id]}
            ShellBot.sendMessage --chat_id ${callback_query_message_chat_id[$id]} \
                                --text "$(echo -e ${message})" --parse_mode markdown
                        
            ;;
        contas.VIVOT)
    
            message="$(contas.text_return VIVOT)"
            ShellBot.answerCallbackQuery --callback_query_id ${callback_query_id[$id]}
            ShellBot.sendMessage --chat_id ${callback_query_message_chat_id[$id]} \
                                --text "$(echo -e ${message})" --parse_mode markdown

            contas.yesno_button "VIVOT"

            ;;
            
        contas.VIVOR)
    
            message="$(contas.text_return VIVOR)"
            ShellBot.answerCallbackQuery --callback_query_id ${callback_query_id[$id]}
            ShellBot.sendMessage --chat_id ${callback_query_message_chat_id[$id]} \
                                --text "$(echo -e ${message})" --parse_mode markdown

            contas.yesno_button "VIVOR"

            ;;
            contas.VIVORSIM)
            today=$(date "+%Y-%m-%d")
            sed -i "s/VIVOR,0,/VIVOR,${today},/" ${BOT_CONTAS_LIST}
            message="*Registro efetuado com sucesso*\n"
            message+="Clique em contas novamente para conferir\n\n"
            message+="/contas"
            ShellBot.answerCallbackQuery --callback_query_id ${callback_query_id[$id]}
            ShellBot.sendMessage --chat_id ${callback_query_message_chat_id[$id]} \
                                --text "$(echo -e ${message})" --parse_mode markdown
                        
            ;;
        contas.VIVORNAO)
            message="*Pagar mais tarde então* 😁"
            ShellBot.answerCallbackQuery --callback_query_id ${callback_query_id[$id]}
            ShellBot.sendMessage --chat_id ${callback_query_message_chat_id[$id]} \
                                --text "$(echo -e ${message})" --parse_mode markdown
                        
            ;;
        contas.CARREFOUR)
    
            message="$(contas.text_return CARREFOUR)"
            ShellBot.answerCallbackQuery --callback_query_id ${callback_query_id[$id]}
            ShellBot.sendMessage --chat_id ${callback_query_message_chat_id[$id]} \
                                --text "$(echo -e ${message})" --parse_mode markdown

            contas.yesno_button "CARREFOUR"

            ;;
            contas.CARREFOURSIM)
            today=$(date "+%Y-%m-%d")
            sed -i "s/CARREFOUR,0,/CARREFOUR,${today},/" ${BOT_CONTAS_LIST}
            message="*Registro efetuado com sucesso*\n"
            message+="Clique em contas novamente para conferir\n\n"
            message+="/contas"
            ShellBot.answerCallbackQuery --callback_query_id ${callback_query_id[$id]}
            ShellBot.sendMessage --chat_id ${callback_query_message_chat_id[$id]} \
                                --text "$(echo -e ${message})" --parse_mode markdown
                        
            ;;
        contas.CARREFOURNAO)
            message="*Pagar mais tarde então* 😁"
            ShellBot.answerCallbackQuery --callback_query_id ${callback_query_id[$id]}
            ShellBot.sendMessage --chat_id ${callback_query_message_chat_id[$id]} \
                                --text "$(echo -e ${message})" --parse_mode markdown
                        
            ;;
        contas.IGTI)
    
            message="$(contas.text_return IGTI)"
            ShellBot.answerCallbackQuery --callback_query_id ${callback_query_id[$id]}
            ShellBot.sendMessage --chat_id ${callback_query_message_chat_id[$id]} \
                                --text "$(echo -e ${message})" --parse_mode markdown

            contas.yesno_button "IGTI"

            ;;
            contas.IGTISIM)
            today=$(date "+%Y-%m-%d")
            sed -i "s/IGTI,0,/IGTI,${today},/" ${BOT_CONTAS_LIST}
            message="*Registro efetuado com sucesso*\n"
            message+="Clique em contas novamente para conferir\n\n"
            message+="/contas"
            ShellBot.answerCallbackQuery --callback_query_id ${callback_query_id[$id]}
            ShellBot.sendMessage --chat_id ${callback_query_message_chat_id[$id]} \
                                --text "$(echo -e ${message})" --parse_mode markdown
                        
            ;;
        contas.IGTINAO)
            message="*Pagar mais tarde então* 😁"
            ShellBot.answerCallbackQuery --callback_query_id ${callback_query_id[$id]}
            ShellBot.sendMessage --chat_id ${callback_query_message_chat_id[$id]} \
                                --text "$(echo -e ${message})" --parse_mode markdown
                        
            ;;
        contas.ITAUR)
    
            message="$(contas.text_return ITAUR)"
            ShellBot.answerCallbackQuery --callback_query_id ${callback_query_id[$id]}
            ShellBot.sendMessage --chat_id ${callback_query_message_chat_id[$id]} \
                                --text "$(echo -e ${message})" --parse_mode markdown

            contas.yesno_button "ITAUR"

            ;;
            contas.ITAURSIM)
            today=$(date "+%Y-%m-%d")
            sed -i "s/ITAUR,0,/ITAUR,${today},/" ${BOT_CONTAS_LIST}
            message="*Registro efetuado com sucesso*\n"
            message+="Clique em contas novamente para conferir\n\n"
            message+="/contas"
            ShellBot.answerCallbackQuery --callback_query_id ${callback_query_id[$id]}
            ShellBot.sendMessage --chat_id ${callback_query_message_chat_id[$id]} \
                                --text "$(echo -e ${message})" --parse_mode markdown
                        
            ;;
        contas.ITAURNAO)
            message="*Pagar mais tarde então* 😁"
            ShellBot.answerCallbackQuery --callback_query_id ${callback_query_id[$id]}
            ShellBot.sendMessage --chat_id ${callback_query_message_chat_id[$id]} \
                                --text "$(echo -e ${message})" --parse_mode markdown
                        
            ;;
        contas.ITAUT)
    
            message="$(contas.text_return ITAUT)"
            ShellBot.answerCallbackQuery --callback_query_id ${callback_query_id[$id]}
            ShellBot.sendMessage --chat_id ${callback_query_message_chat_id[$id]} \
                                --text "$(echo -e ${message})" --parse_mode markdown

            contas.yesno_button "ITAUT"

            ;;
            contas.ITAUTSIM)
            today=$(date "+%Y-%m-%d")
            sed -i "s/ITAUT,0,/ITAUT,${today},/" ${BOT_CONTAS_LIST}
            message="*Registro efetuado com sucesso*\n"
            message+="Clique em contas novamente para conferir\n\n"
            message+="/contas"
            ShellBot.answerCallbackQuery --callback_query_id ${callback_query_id[$id]}
            ShellBot.sendMessage --chat_id ${callback_query_message_chat_id[$id]} \
                                --text "$(echo -e ${message})" --parse_mode markdown
                        
            ;;
        contas.ITAUTNAO)
            message="*Pagar mais tarde então* 😁"
            ShellBot.answerCallbackQuery --callback_query_id ${callback_query_id[$id]}
            ShellBot.sendMessage --chat_id ${callback_query_message_chat_id[$id]} \
                                --text "$(echo -e ${message})" --parse_mode markdown
                        
            ;;
        contas.NATURGY)
    
            message="$(contas.text_return NATURGY)"
            ShellBot.answerCallbackQuery --callback_query_id ${callback_query_id[$id]}
            ShellBot.sendMessage --chat_id ${callback_query_message_chat_id[$id]} \
                                --text "$(echo -e ${message})" --parse_mode markdown

            contas.yesno_button "NATURGY"

            ;;
            contas.NATURGYSIM)
            today=$(date "+%Y-%m-%d")
            sed -i "s/NATURGY,0,/NATURGY,${today},/" ${BOT_CONTAS_LIST}
            message="*Registro efetuado com sucesso*\n"
            message+="Clique em contas novamente para conferir\n\n"
            message+="/contas"
            ShellBot.answerCallbackQuery --callback_query_id ${callback_query_id[$id]}
            ShellBot.sendMessage --chat_id ${callback_query_message_chat_id[$id]} \
                                --text "$(echo -e ${message})" --parse_mode markdown
                        
            ;;
        contas.NATURGYNAO)
            message="*Pagar mais tarde então* 😁"
            ShellBot.answerCallbackQuery --callback_query_id ${callback_query_id[$id]}
            ShellBot.sendMessage --chat_id ${callback_query_message_chat_id[$id]} \
                                --text "$(echo -e ${message})" --parse_mode markdown
                        
            ;;
        contas.CONDOMINIOD)
    
            message="$(contas.text_return CONDOMINIOD)"
            ShellBot.answerCallbackQuery --callback_query_id ${callback_query_id[$id]}
            ShellBot.sendMessage --chat_id ${callback_query_message_chat_id[$id]} \
                                --text "$(echo -e ${message})" --parse_mode markdown

            contas.yesno_button "CONDOMINIOD"

            ;;
            contas.CONDOMINIODSIM)
            today=$(date "+%Y-%m-%d")
            sed -i "s/CONDOMINIOD,0,/CONDOMINIOD,${today},/" ${BOT_CONTAS_LIST}
            message="*Registro efetuado com sucesso*\n"
            message+="Clique em contas novamente para conferir\n\n"
            message+="/contas"
            ShellBot.answerCallbackQuery --callback_query_id ${callback_query_id[$id]}
            ShellBot.sendMessage --chat_id ${callback_query_message_chat_id[$id]} \
                                --text "$(echo -e ${message})" --parse_mode markdown
                        
            ;;
        contas.CONDOMINIODNAO)
            message="*Pagar mais tarde então* 😁"
            ShellBot.answerCallbackQuery --callback_query_id ${callback_query_id[$id]}
            ShellBot.sendMessage --chat_id ${callback_query_message_chat_id[$id]} \
                                --text "$(echo -e ${message})" --parse_mode markdown
                        
            ;;
        contas.CONDOMINIOV)
    
            message="$(contas.text_return CONDOMINIOV)"
            ShellBot.answerCallbackQuery --callback_query_id ${callback_query_id[$id]}
            ShellBot.sendMessage --chat_id ${callback_query_message_chat_id[$id]} \
                                --text "$(echo -e ${message})" --parse_mode markdown

            contas.yesno_button "CONDOMINIOV"

            ;;
            contas.CONDOMINIOVSIM)
            today=$(date "+%Y-%m-%d")
            sed -i "s/CONDOMINIOV,0,/CONDOMINIOV,${today},/" ${BOT_CONTAS_LIST}
            message="*Registro efetuado com sucesso*\n"
            message+="Clique em contas novamente para conferir\n\n"
            message+="/contas"
            ShellBot.answerCallbackQuery --callback_query_id ${callback_query_id[$id]}
            ShellBot.sendMessage --chat_id ${callback_query_message_chat_id[$id]} \
                                --text "$(echo -e ${message})" --parse_mode markdown
                        
            ;;
        contas.CONDOMINIOVNAO)
            message="*Pagar mais tarde então* 😁"
            ShellBot.answerCallbackQuery --callback_query_id ${callback_query_id[$id]}
            ShellBot.sendMessage --chat_id ${callback_query_message_chat_id[$id]} \
                                --text "$(echo -e ${message})" --parse_mode markdown
                        
            ;;
        contas.IPVA)
    
            message="$(contas.text_return IPVA)"
            ShellBot.answerCallbackQuery --callback_query_id ${callback_query_id[$id]}
            ShellBot.sendMessage --chat_id ${callback_query_message_chat_id[$id]} \
                                --text "$(echo -e ${message})" --parse_mode markdown

            contas.yesno_button "IPVA"

            ;;
            contas.IPVASIM)
            today=$(date "+%Y-%m-%d")
            sed -i "s/IPVA,0,/IPVA,${today},/" ${BOT_CONTAS_LIST}
            message="*Registro efetuado com sucesso*\n"
            message+="Clique em contas novamente para conferir\n\n"
            message+="/contas"
            ShellBot.answerCallbackQuery --callback_query_id ${callback_query_id[$id]}
            ShellBot.sendMessage --chat_id ${callback_query_message_chat_id[$id]} \
                                --text "$(echo -e ${message})" --parse_mode markdown
                        
            ;;
        contas.IPVANAO)
            message="*Pagar mais tarde então* 😁"
            ShellBot.answerCallbackQuery --callback_query_id ${callback_query_id[$id]}
            ShellBot.sendMessage --chat_id ${callback_query_message_chat_id[$id]} \
                                --text "$(echo -e ${message})" --parse_mode markdown
                        
            ;;
    esac
}

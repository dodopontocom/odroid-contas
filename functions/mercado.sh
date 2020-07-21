#!/bin/bash

_WARN="⚠️"
_OK="✅"
_LUPA="🔍"
_CART="🛒"

listar.compras(){
        local item botao_itens file_list
        item=$1
        
        file_list="${BOT_PRECOS_FILE}_ultima.log"

        if [[ ! -f "${file_list}_lock" ]]; then
            echo "${_WARN},${item}" >> ${file_list}
        else
            echo "${_WARN},${item}" >> ${file_list}_lock
        fi
                
        ShellBot.deleteMessage --chat_id ${message_chat_id[$id]} --message_id ${message_message_id[$id]}
}

listar.apagar(){
        
        local file_list item_to_save
        
        file_list="${BOT_PRECOS_FILE}_$(date +%Y%m%d).csv"
        item_to_save="${callback_query_message_text[$id]}"
        echo "${item_to_save}" >> ${file_list}

        ShellBot.deleteMessage  --chat_id ${callback_query_message_chat_id[$id]} \
                                --message_id ${callback_query_message_message_id[$id]}
        
        ShellBot.sendMessage --chat_id ${callback_query_message_chat_id[$id]} \
                              --text "$(echo -e ${item_to_save} ✅)" --parse_mode markdown
}

# procura no site do tenda atacado e retorna o primeiro resultado do produto e preço
listar.preco() {
  local product_name first_found product_price message

  product_name=${callback_query_message_text/ /%20}
  echo "site ---> ${TENDA_SUP_URL}/${product_name}"
  echo ${product_name}
  
  first_found="$(curl -sSS ${TENDA_SUP_URL}/${product_name} | grep "escaped-name" | cut -d'>' -f2 | cut -d'<' -f1 | head -1)"
  echo ${first_found}
  product_price="$(curl -sSS ${TENDA_SUP_URL}/${product_name} | grep -A11 "${first_found}" | tail -1 | sed "s:[\t ]::g")"

  echo ${product_price}

  if [[ ${first_found} ]] && [[ ${product_price} ]]; then
          message="Você pode encontrar ${product_name} no *\`TENDA ATACADISTA\`*\n\n"
          message+="*Produto/Marca:* ${first_found//[&#]/}\n\n"
          message+="*Preço:* ---> ${product_price}"

          ShellBot.sendMessage --chat_id ${callback_query_message_chat_id[$id]} \
                              --text "$(echo -e ${message})" --parse_mode markdown
  else
          message="Produto não encontrado..."
          ShellBot.sendMessage --chat_id ${callback_query_message_chat_id[$id]} \
                              --text "$(echo -e ${message})" --parse_mode markdown
  fi

}

listar.salvar() {
        local logs item secs_message expire_message_time secs_now
        
        logs=/tmp/itens.csv
        item=$1
        secs_message=$2
        expire_message_time=172800
        secs_now=$(date +%s)
        
        echo "${item},${secs_message}" >> ${logs}
                
        while read line ; do
        _secs_message=$(echo $line | cut -d',' -f2)
                if [[ $(bc <<< ${secs_now}-$_secs_message) -gt 172800 ]]; then
                        echo "${line}"
                        echo "Passou de 48 horas que a mensagem foi enviada"
                else
                        echo "${line}"
                        echo "Ainda não passou de 48 horas que a mensagem foi enviada"
                fi
        done < ${logs}
}

listar.go_shopping() {
    local file_list
    
    file_list="${BOT_PRECOS_FILE}_ultima.log"
    if [[ -f ${file_list} ]]; then
        mv ${file_list} ${file_list}_lock
        
        botao_go_shopping=''
    
        if [[ -f "${file_list}_lock" ]]; then
            count=1
            while read line; do
                rem=$(( ${count} % 3))
                if [[ ${rem} -eq 0 ]]; then
                    count=$((count+1))
                    ShellBot.InlineKeyboardButton --button 'botao_go_shopping' --text "$(echo ${line} | tr ',' ' ')" --callback_data "${line}" --line ${count}
                else
                    ShellBot.InlineKeyboardButton --button 'botao_go_shopping' --text "$(echo ${line} | tr ',' ' ')" --callback_data "${line}" --line ${count}                
                    count=$((count+1))
                fi
            done < ${file_list}_lock
        fi
        
        ShellBot.InlineKeyboardButton --button 'botao_go_shopping'\
            --text "${_CART} - Finalizar" \
            --callback_data "_concluir" \
            --line 999
        ShellBot.InlineKeyboardButton --button 'botao_go_shopping'\
            --text "-= Refresh =-" \
            --callback_data "Refresh" \
            --line 999

        keyboard_go_shopping="$(ShellBot.InlineKeyboardMarkup -b 'botao_go_shopping')"
        
        if [[ ${message_chat_id[$id]} ]]; then
            ShellBot.deleteMessage --chat_id ${message_chat_id[$id]} --message_id ${message_message_id[$id]}
            ShellBot.sendMessage --chat_id ${message_chat_id[$id]} \
                            --text "*LISTA COMPLETA*" \
                            --parse_mode markdown \
                            --reply_markup "$keyboard_go_shopping"
        else
            ShellBot.deleteMessage --chat_id ${callback_query_message_chat_id[$id]} --message_id ${callback_query_message_message_id[$id]}
            ShellBot.sendMessage --chat_id ${callback_query_message_chat_id[$id]} \
                            --text "*LISTA COMPLETA*" \
                            --parse_mode markdown \
                            --reply_markup "$keyboard_go_shopping"
        fi
    else
        message="Lista Vazia!"
        ShellBot.deleteMessage --chat_id ${message_chat_id[$id]} --message_id ${message_message_id[$id]}
        ShellBot.sendMessage --chat_id ${message_chat_id[$id]} \
                            --text "$(echo -e ${message})" \
                            -- parse_mode markdown
    fi      
}

listar.go_botoes() {
    local file_list float_message count

    count=1
    file_list="${BOT_PRECOS_FILE}_ultima.log"
    
    botao_edit_shopping=''

    if [[ -f "${file_list}_lock" ]]; then
        if [[ "$(echo ${callback_query_data[$id]} | grep ${_WARN})" ]]; then
            sed -i "s/${callback_query_data}/${_OK},${callback_query_data##*,}/" ${file_list}_lock
            float_message="item comprado"
        fi
        if [[ "$(echo ${callback_query_data[$id]} | grep ${_OK})" ]]; then
            sed -i "s/${callback_query_data}/${_WARN},${callback_query_data##*,}/" ${file_list}_lock
            float_message="Ops..."
        fi
        
        count=1
        while read line; do
            rem=$(( ${count} % 3))
            if [[ ${rem} -eq 0 ]]; then
                count=$((count+1))
                ShellBot.InlineKeyboardButton --button 'botao_edit_shopping' \
                    --text "$(echo ${line} | tr ',' ' ')" \
                    --callback_data "${line}" --line ${count}
            else
                ShellBot.InlineKeyboardButton --button 'botao_edit_shopping' \
                    --text "$(echo ${line} | tr ',' ' ')" \
                    --callback_data "${line}" --line ${count}                
                count=$((count+1))
            fi
        done < ${file_list}_lock
    fi
    
    ShellBot.InlineKeyboardButton --button 'botao_edit_shopping' \
        --text "${_CART} - Finalizar" \
        --callback_data "_concluir" \
        --line 999
    ShellBot.InlineKeyboardButton --button 'botao_edit_shopping' \
        --text "-= Refresh =-" \
        --callback_data "Refresh" \
        --line 999

    keyboard_edit_shopping="$(ShellBot.InlineKeyboardMarkup -b 'botao_edit_shopping')"

    ShellBot.answerCallbackQuery --callback_query_id ${callback_query_id[$id]} --text "${float_message}"
    ShellBot.editMessageReplyMarkup --chat_id ${callback_query_message_chat_id[$id]} \
                        --message_id ${callback_query_message_message_id[$id]} \
                        --reply_markup "$keyboard_edit_shopping"
}

listar.concluir() {
    local file_list
    
    file_list="${BOT_PRECOS_FILE}_ultima.log"

    botao_confirmar=''

    ShellBot.InlineKeyboardButton --button 'botao_confirmar' \
        --text "SIM" \
        --callback_data "_concluir_sim" \
        --line 1

    ShellBot.InlineKeyboardButton --button 'botao_confirmar' \
        --text "NÃO" \
        --callback_data "_concluir_nao" \
        --line 1
        
    keyboard_confirmar="$(ShellBot.InlineKeyboardMarkup -b 'botao_confirmar')"
    
    # ShellBot.answerCallbackQuery --callback_query_id ${callback_query_id[$id]} \
    #         --text "Compra finalizada..."
    
    ShellBot.deleteMessage --chat_id ${callback_query_message_chat_id[$id]} \
                        --message_id ${callback_query_message_message_id[$id]}
    
    ShellBot.sendMessage --chat_id ${callback_query_message_chat_id[$id]} \
                        --text "*Deseja mesmo finalizar a compra?*" \
                        --parse_mode markdown \
                        --reply_markup "$keyboard_confirmar"
    
    # ShellBot.sendMessage --chat_id ${callback_query_message_chat_id[$id]} \
    #                         --text "*Chega por hoje!*" \
    #                         --parse_mode markdown

}

listar.sim() {

    ShellBot.deleteMessage --chat_id ${callback_query_message_chat_id[$id]} --message_id ${callback_query_message_message_id[$id]}    
    message="Valor Total da Compra:"
  	ShellBot.sendMessage --chat_id ${callback_query_message_chat_id[$id]} --text "$(echo -e ${message})" \
        				--reply_markup "$(ShellBot.ForceReply)"
}

listar.valor_total() {
    local file_list doc total _chat_id

    total=$1
    file_list="${BOT_PRECOS_FILE}_ultima.log"
    doc=${BOT_PRECOS_FILE}compras_$(date +%Y%m%d_%H%M%S).csv

    mv ${file_list}_lock ${doc}

    ShellBot.deleteMessage --chat_id ${message_reply_to_message_chat_id[$id]} \
                        --message_id ${message_reply_to_message_message_id[$id]}

    echo "Total,${total//,/.}" >> ${doc}

    ShellBot.sendMessage --chat_id ${message_reply_to_message_chat_id[$id]} \
                        --text "*Resumo da compra realizado em $(date +%d) do $(date +%m)*" \
                        --parse_mode markdown
    ShellBot.sendDocument --chat_id ${message_reply_to_message_chat_id[$id]} \
							--document @${doc}
}


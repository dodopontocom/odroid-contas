#!/bin/bash

listar.compras(){
        local item botao_itens file_list
        item=$1
        
        file_list="${BOT_PRECOS_FILE}_ultima.log"
        
        #salvar item em lista para consulta posterior
        #listar.salvar "${item}" "$(date +%s)"
        
        botao_itens=''
        ShellBot.InlineKeyboardButton --button 'botao_itens' --text "✅" --callback_data 'item_comprado' --line 1
        ShellBot.InlineKeyboardButton --button 'botao_itens' --text "preços 🔍" --callback_data 'item_valor' --line 1
        keyboard_itens="$(ShellBot.InlineKeyboardMarkup -b 'botao_itens')"

        ShellBot.deleteMessage --chat_id ${message_chat_id[$id]} --message_id ${message_message_id[$id]}
        ShellBot.sendMessage    --chat_id ${message_chat_id[$id]} \
                                --text "*${item}*" \
                                --parse_mode markdown \
                                --reply_markup "$keyboard_itens"

        if [[ ! -f "${file_list}_lock" ]]; then
            echo "${item}" >> ${file_list}
        else
            echo "${item}" >> ${file_list}_fly
        fi
}

listar.apagar(){
        
        local file_list item_to_save
        
        file_list="${BOT_PRECOS_FILE}_$(date +%Y%m%d).csv"
        item_to_save="${callback_query_message_text[$id]}"
        echo "${item_to_save}" >> ${file_list}
        ShellBot.answerCallbackQuery --callback_query_id ${callback_query_id[$id]}
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

          ShellBot.answerCallbackQuery --callback_query_id ${callback_query_id[$id]}
          ShellBot.sendMessage --chat_id ${callback_query_message_chat_id[$id]} \
                              --text "$(echo -e ${message})" --parse_mode markdown
  else
          message="Produto não encontrado..."
          ShellBot.answerCallbackQuery --callback_query_id ${callback_query_id[$id]}
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

listar.go() {
    local file_list
    
    file_list="${BOT_PRECOS_FILE}_ultima.log"
    if [[ -f ${file_list} ]]; then
        mv ${file_list} ${file_list}_lock
    fi


    botao_gogogo=''
    
    if [[ -f "${file_list}_lock" ]]; then
        while read line; done
            ShellBot.InlineKeyboardButton --button 'botao_gogogo' --text "${line}" --callback_data 'ir_compras' --line 1
        done < ${file_list}_lock
    fi
    if [[ -f "${file_list}_fly" ]]; then
        while read line; done
            ShellBot.InlineKeyboardButton --button 'botao_gogogo' --text "${line}" --callback_data 'ir_compras' --line 1
        done < ${file_list}_fly
    fi
    keyboard_gogogo="$(ShellBot.InlineKeyboardMarkup -b 'botao_gogogo')"

    ShellBot.sendMessage --chat_id ${message_chat_id[$id]} \
                         --text "*LISTA COMPLETA*" \
                         --parse_mode markdown \
                         --reply_markup "$keyboard_gogogo"
}

listar.go_botoes() {
    echo "------"
}


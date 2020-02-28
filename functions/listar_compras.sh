#!/bin/bash

#botao_itens=''
#ShellBot.InlineKeyboardButton --button 'botao_itens' --text "${item} ✅" --callback_data 'item_comprado' --line 1
#ShellBot.InlineKeyboardButton --button 'botao_itens' --text "preços 🔍" --callback_data 'item_valor' --line 1
#keyboard_itens="$(ShellBot.InlineKeyboardMarkup -b 'botao_itens')"

listar.compras(){
        local item
        item=$1
        
        botao_itens=''
        ShellBot.InlineKeyboardButton --button 'botao_itens' --text "${item} ✅" --callback_data 'item_comprado' --line 1
        ShellBot.InlineKeyboardButton --button 'botao_itens' --text "preços 🔍" --callback_data 'item_valor' --line 1
        keyboard_itens="$(ShellBot.InlineKeyboardMarkup -b 'botao_itens')"

        ShellBot.deleteMessage --chat_id ${message_chat_id[$id]} --message_id ${message_message_id[$id]}
        ShellBot.sendMessage    --chat_id ${message_chat_id[$id]} \
                                ##--text "*${item}*" \
                                --parse_mode markdown \
                                #--reply_markup "$keyboard_compras"
                                --reply_markup "$keyboard_itens"
}

listar.apagar(){
        
        ShellBot.answerCallbackQuery --callback_query_id ${callback_query_id[$id]}
        ShellBot.deleteMessage  --chat_id ${callback_query_message_chat_id[$id]} \
                                --message_id ${callback_query_message_message_id[$id]}
}

listar.precos(){

        ShellBot.answerCallbackQuery --callback_query_id ${callback_query_id[$id]}
        ShellBot.sendMessage  --chat_id ${callback_query_message_chat_id[$id]} \
      				--text "Opção em construção..."
}

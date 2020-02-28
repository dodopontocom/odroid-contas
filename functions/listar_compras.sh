#!/bin/bash

listar.compras(){
        local item
        item=$1

        ShellBot.deleteMessage --chat_id ${message_chat_id[$id]} --message_id ${message_message_id[$id]}
        ShellBot.sendMessage    --chat_id ${message_chat_id[$id]} \
                                --text "*${item}*" \
                                --parse_mode markdown \
                                --reply_markup "$keyboard_compras"
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

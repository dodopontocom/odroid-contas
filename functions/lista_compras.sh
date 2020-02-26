#!/bin/bash

function exibir_lista(){
        local botao=

        # Cria o botão 'voltar'.
        ShellBot.InlineKeyboardButton --button botao --text '📝' --callback_data 'item_comprado' --line 1
        ShellBot.InlineKeyboardButton --button botao --text '👎' --callback_data 'btn_voltar' --line 1
        ShellBot.InlineKeyboardButton --button botao --text 'precos 🔍' --callback_data 'btn_voltar' --line 1
        # Anexa o botão a mensagem.
        ShellBot.sendMessage    --chat_id ${message_chat_id[$id]} \
                --text "*$(tail -1 list.txt)*" \
                                --parse_mode markdown \
                                --reply_markup "$(ShellBot.InlineKeyboardMarkup --button botao)"
}

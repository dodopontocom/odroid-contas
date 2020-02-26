#!/bin/bash

function exibir_lista(){
        local botao item
        botao=
        item=$1

        # Cria o botão 'voltar'.
        ShellBot.InlineKeyboardButton --button botao --text '📝' --callback_data 'item_comprado' --line 1
        ShellBot.InlineKeyboardButton --button botao --text '👎' --callback_data 'item_cancelar' --line 1
        ShellBot.InlineKeyboardButton --button botao --text 'precos 🔍' --callback_data 'item_valor' --line 1
        # Anexa o botão a mensagem.
        ShellBot.sendMessage    --chat_id ${message_chat_id[$id]} \
                --text "*${item}*" \
                                --parse_mode markdown \
                                --reply_markup "$(ShellBot.InlineKeyboardMarkup --button botao)"
}

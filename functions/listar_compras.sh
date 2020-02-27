#!/bin/bash

listar.compras(){
        local item
        item=$1

        ShellBot.sendMessage    --chat_id ${message_chat_id[$id]} \
                                --text "*${item}*" \
                                --parse_mode markdown \
                                --reply_markup "$keyboard_compras"
}

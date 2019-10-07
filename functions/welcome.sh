#!/bin/bash

# boas vindas

welcome.msg() {
	local message

	message="🆔 [@${message_new_chat_member_username[$id]:-null}]\n"
    	message+="🗣 Olá *${message_new_chat_member_first_name[$id]}*"'!!\n\n'
    	message+="Seja bem-vindo(a) ao *${message_chat_title[$id]}*.\n\n"
    	message+='`Se precisar de ajuda ou informações sobre meus comandos, é só me chamar no privado.`'"[@$(ShellBot.username)]"

	ShellBot.sendMessage --chat_id ${message_chat_id[$id]} \
		--text "$(echo -e ${message})" --parse_mode markdown

	return 0	
}

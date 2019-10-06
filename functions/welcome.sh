#!/bin/bash

# boas vindas

welcome.msg() {
	local msg

	# Texto da mensagem
	msg="🆔 [@${message_new_chat_member_username[$id]:-null}]\n"
    msg+="🗣 Olá *${message_new_chat_member_first_name[$id]}*"'!!\n\n'
    msg+="Seja bem-vindo(a) ao *${message_chat_title[$id]}*.\n\n"
    msg+='`Se precisar de ajuda ou informações sobre meus comandos, é só me chamar no privado.`'"[@$(ShellBot.username)]"

	# Envia a mensagem de boas vindas.
	ShellBot.sendMessage --chat_id ${message_chat_id[$id]} \
							--text "$(echo -e $msg)" \
							--parse_mode markdown

	return 0	
}

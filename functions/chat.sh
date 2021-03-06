#!/bin/bash
#

# Verifica se o modo falante está on ou off e liga ou desliga ele
chat.switch() {
	local status array message chat_file

	chat_file="/tmp/${message_chat_id[$id]}_chat.on"

	status=$1
	array=(${status})
	array[0]="/chat"
	status=${array[@]:1}
	
	if [[ -z ${status[@]} ]]; then
		message="Usage: ${array[0]} \`on\` ou \`off\`"
		ShellBot.sendMessage --chat_id ${message_chat_id[$id]} --text "$(echo -e ${message})" --parse_mode markdown
      	fi

	if [[ "${status[@]}" == "on" ]]; then
		if [[ -f ${chat_file} ]]; then
			message="Modo falante ligado!"
			ShellBot.sendMessage --chat_id ${message_chat_id[$id]} --text "$(echo -e ${message})" --parse_mode markdown
		else
			touch ${chat_file}
			message="Modo falante ligado!"
			ShellBot.sendMessage --chat_id ${message_chat_id[$id]} --text "$(echo -e ${message})" --parse_mode markdown
		fi
	elif [[ "${status[@]}" == "off" ]]; then
		if [[ -f ${chat_file} ]]; then
			rm -f ${chat_file}
			message="Modo falante desligado!"
			ShellBot.sendMessage --chat_id ${message_chat_id[$id]} --text "$(echo -e ${message})" --parse_mode markdown
		
		else
			message="Modo falante desligado!"
			ShellBot.sendMessage --chat_id ${message_chat_id[$id]} --text "$(echo -e ${message})" --parse_mode markdown
		fi
	fi
}

# Enviar as conversas quando o usuário envia uma mensagem que não seja um 'bot command'
# O texto é totalmente aleatório
chat.hi() {
	local random_number message chat_file

	chat_file="/tmp/${message_chat_id[$id]}_chat.on"
	
	random_number=$(helper.random ${CHAT_SIMPLE_REPLY})
	
	if [[ -f ${chat_file} ]]; then
		message=$(sed -n "${random_number}p" < ${CHAT_SIMPLE_REPLY})
		ShellBot.sendMessage --chat_id ${message_chat_id[$id]} --text "$(echo -e ${message})" --parse_mode markdown
	fi
}

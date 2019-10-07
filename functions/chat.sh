#!/bin/bash
#

chat_file=/tmp/chat.on

chat.switch
	local status array message

	status=$1
	array=(${status})
	array[0]="/chat"
	status=${array[@]:1}
	
	if [[ ${status[@]} = "on" ]]; then
		if [[ -f ${chat_file} ]]; then
			message="Modo falante ligado!"
			ShellBot.sendMessage --chat_id ${message_chat_id[$id]} --text "$(echo -e ${message})" --parse_mode markdown
		else
			touch ${chat_file}
			message="Modo falante ligado!"
			ShellBot.sendMessage --chat_id ${message_chat_id[$id]} --text "$(echo -e ${message})" --parse_mode markdown
		fi
	elif [[ ${status[@]} = "off" ]]; then
		if [[ -f ${chat_file} ]]; then
			rm -f ${chat_file}
			message="Modo falante desligado!"
			ShellBot.sendMessage --chat_id ${message_chat_id[$id]} --text "$(echo -e ${message})" --parse_mode markdown
		else
			message="Modo falante desligado!"
			ShellBot.sendMessage --chat_id ${message_chat_id[$id]} --text "$(echo -e ${message})" --parse_mode markdown
	fi
}

chat.hi() {
	local words random_number message
	
	words=${BASEDIR}/texts/words.txt
	random_number=$(random.helper ${words})
	
	if [[ -f ${chat_file} ]]; then
		message=$(sed -n "${random_number}p" < ${words})
		ShellBot.sendMessage --chat_id ${message_chat_id[$id]} --text "$(echo -e ${message})" --parse_mode markdown
	fi
}

#!/bin/bash
#
BASEDIR=$(dirname $0)
reminders=${BASEDIR}/texts/europe_todo.txt

source ${BASEDIR}/functions/random.sh

europe_todo_random.message() {
	local message
	r_amount=$(random.helper ${reminders})
	message=$(sed -n "${r_amount}p" < ${reminders})
	if [[ $(echo ${message} | grep -E "\|") ]]; then
  		ShellBot.sendMessage --chat_id ${message_chat_id[$id]} --text "$(echo -e ${message} | cut -d'|' -f1)" --parse_mode markdown
		ShellBot.sendMessage --chat_id ${message_chat_id[$id]} --text "$(echo -e ${message} | cut -d'|' -f2)" --parse_mode markdown
	else
		ShellBot.sendMessage --chat_id ${message_chat_id[$id]} --text "$(echo -e ${message})" --parse_mode markdown
	fi
}

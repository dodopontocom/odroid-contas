#!/bin/bash
#
#❌
#✅
#✖

timezone.place() {
	local array apiUrl place message
	place=$1
	array=(${place})
  	array[0]="/timezone"
  	place=${array[@]:1}
	apiUrl="http://worldtimeapi.org/api/timezone/Europe/${place^}.txt"
	
	message="${place^} ✅ "
	message+="\`$(curl -s ${apiUrl} | grep ^datetime | cut -d'T' -f2 | cut -d'.' -f1)\`"

	ShellBot.sendMessage --chat_id ${message_chat_id[$id]} --text "$(echo -e ${message})" --parse_mode markdown
}

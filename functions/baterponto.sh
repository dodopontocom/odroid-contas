#!/bin/bash
#

baterponto.apply() {
  local message opt array random_file_name
  opt=$1
  array=(${opt})
  array[0]="/baterponto"
  opt=${array[@]:1}
  case ${opt} in
		'start')
            message="Bom trabalho"
        		ShellBot.sendMessage --chat_id ${message_chat_id[$id]} --text "$(echo -e ${message})" --parse_mode markdown
			;;
		'lunch')
        		message="Bom almoço"
        		ShellBot.sendMessage --chat_id ${message_chat_id[$id]} --text "$(echo -e ${message})" --parse_mode markdown
			;;
    'back')
        		message="Bom trabalho"
        		ShellBot.sendMessage --chat_id ${message_chat_id[$id]} --text "$(echo -e ${message})" --parse_mode markdown
			;;
    'bye')
        		message="Bom retorno"
        		ShellBot.sendMessage --chat_id ${message_chat_id[$id]} --text "$(echo -e ${message})" --parse_mode markdown
			;;
		'')
            message="opa"
        		ShellBot.sendMessage --chat_id ${message_chat_id[$id]} --text "$(echo -e ${message})" --parse_mode markdown
        
      			;;
  	esac
}

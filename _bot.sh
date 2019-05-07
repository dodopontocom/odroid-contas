#!/bin/bash
#

# Importando API
BASEDIR=$(dirname $0)
source ${BASEDIR}/ShellBot.sh
source ${BASEDIR}/functions/start.sh
source ${BASEDIR}/functions/speedtest.sh
source ${BASEDIR}/functions/voice.sh
source ${BASEDIR}/functions/alarm.sh
source ${BASEDIR}/functions/batercartao.sh
source ${BASEDIR}/functions/linux.sh
source ${BASEDIR}/functions/selfie.sh
source ${BASEDIR}/functions/ping.sh
source ${BASEDIR}/functions/contas.sh
source ${BASEDIR}/functions/chat.sh
source ${BASEDIR}/functions/europe_todo.sh
source ${BASEDIR}/functions/test.sh

######################################################################################
#source <(cat ${BASEDIR}/functions/*.sh)
#for f in ${BASEDIR}/functions/*.sh; do source $f; done
######################################################################################

logs=${BASEDIR}/logs

# Token do bot
bot_token=$(cat ${BASEDIR}/.token)

# Inicializando o bot
ShellBot.init --token "$bot_token" --monitor --flush

############### keyboard para o comando contas #######################################
botao1=''
ShellBot.InlineKeyboardButton --button 'botao1' --line 1 --text 'Listar' --callback_data 'btn_list'
ShellBot.InlineKeyboardButton --button 'botao1' --line 1 --text 'Adicionar' --callback_data 'btn_add'
ShellBot.InlineKeyboardButton --button 'botao1' --line 1 --text 'Remover' --callback_data 'btn_rm'
ShellBot.regHandleFunction --function contas.list --callback_data 'btn_list'
ShellBot.regHandleFunction --function contas.add --callback_data btn_add
ShellBot.regHandleFunction --function contas.rm --callback_data btn_rm
keyboard1="$(ShellBot.InlineKeyboardMarkup -b 'botao1')"
#######################################################################################

while :
do
	
	ShellBot.getUpdates --limit 100 --offset $(ShellBot.OffsetNext) --timeout 30
	
	for id in $(ShellBot.ListUpdates)
	do
	(
		ShellBot.watchHandle --callback_data ${callback_query_data[$id]}
		if [[ ${message_entities_type[$id]} == bot_command ]]; then
			if [[ "$(echo ${message_text[$id]%%@*} | grep "^\/start" )" ]]; then
				start.sendGreetings
			fi
			if [[ "$(echo ${message_text[$id]%%@*} | grep "^\/speedtest" )" ]]; then
				speedtest.check
			fi
			if [[ "$(echo ${message_text[$id]%%@*} | grep "^\/voice" )" ]]; then
				voice.convert "${message_text[$id]}"
			fi
			if [[ "$(echo ${message_text[$id]%%@*} | grep "^\/alarm" )" ]]; then
				alarm.set
			fi
			if [[ "$(echo ${message_text[$id]%%@*} | grep "^\/batercartao" )" ]]; then
				batercartao.apply
			fi
			if [[ "$(echo ${message_text[$id]%%@*} | grep "^\/linux" )" ]]; then
				linux.cmd "${message_text[$id]}"
			fi
			if [[ "$(echo ${message_text[$id]%%@*} | grep "^\/selfie" )" ]]; then
				selfie.send
			fi
			if [[ "$(echo ${message_text[$id]%%@*} | grep "^\/ping" )" ]]; then
				ping.pong
			fi
			if [[ "$(echo ${message_text[$id]%%@*} | grep "^\/contas" )" ]]; then
				contas.cmd
			fi
			if [[ "$(echo ${message_text[$id]%%@*} | grep "^\/reminder" )" ]]; then
				europe_todo_random.message
			fi
		else
			chat.hi
		fi
	) & 
	done
done
#FIM

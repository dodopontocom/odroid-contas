#!/bin/bash
#
sleep 10

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
source ${BASEDIR}/functions/trip.sh
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
ShellBot.regHandleFunction --function contas.list --callback_data btn_list
ShellBot.regHandleFunction --function contas.add --callback_data btn_add
ShellBot.regHandleFunction --function contas.rm --callback_data btn_rm
keyboard1="$(ShellBot.InlineKeyboardMarkup -b 'botao1')"
#######################################################################################
#❌
#✅
############### keyboard para o comando trip #######################################
botao2=''
ShellBot.InlineKeyboardButton --button 'botao2' --line 1 --text 'Listar Todos' --callback_data 'btn_trip_list'
ShellBot.InlineKeyboardButton --button 'botao2' --line 2 --text 'Listar ✅' --callback_data 'btn_trip_done'
ShellBot.InlineKeyboardButton --button 'botao2' --line 2 --text 'Listar ❌' --callback_data 'btn_trip_pending'
ShellBot.InlineKeyboardButton --button 'botao2' --line 4 --text 'Listar Passagens ✅' --callback_data 'btn_trip_passagensV'
ShellBot.InlineKeyboardButton --button 'botao2' --line 4 --text 'Listar Passagens ❌' --callback_data 'btn_trip_passagensX'
ShellBot.InlineKeyboardButton --button 'botao2' --line 5 --text 'Listar Trem ✅' --callback_data 'btn_trip_tremV'
ShellBot.InlineKeyboardButton --button 'botao2' --line 5 --text 'Listar Trem ❌' --callback_data 'btn_trip_tremX'
ShellBot.InlineKeyboardButton --button 'botao2' --line 6 --text 'Listar Compras ✅' --callback_data 'btn_trip_comprarV'
ShellBot.InlineKeyboardButton --button 'botao2' --line 6 --text 'Listar Compras ❌' --callback_data 'btn_trip_comprarX'
ShellBot.InlineKeyboardButton --button 'botao2' --line 7 --text 'Listar Outros ✅' --callback_data 'btn_trip_outrosV'
ShellBot.InlineKeyboardButton --button 'botao2' --line 7 --text 'Listar Outros ❌' --callback_data 'btn_trip_outrosX'
ShellBot.regHandleFunction --function list.all --callback_data btn_trip_list
ShellBot.regHandleFunction --function list.done --callback_data btn_trip_done
ShellBot.regHandleFunction --function list.pending --callback_data btn_trip_pending
ShellBot.regHandleFunction --function list.search --callback_data btn_trip_passagensV
ShellBot.regHandleFunction --function list.search --callback_data btn_trip_passagensX
ShellBot.regHandleFunction --function list.search --callback_data btn_trip_tremV
ShellBot.regHandleFunction --function list.search --callback_data btn_trip_tremX
ShellBot.regHandleFunction --function list.search --callback_data btn_trip_comprarV
ShellBot.regHandleFunction --function list.search --callback_data btn_trip_comprarX
ShellBot.regHandleFunction --function list.search --callback_data btn_trip_outrosV
ShellBot.regHandleFunction --function list.search --callback_data btn_trip_outrosX
keyboard_trip_checklist="$(ShellBot.InlineKeyboardMarkup -b 'botao2')"
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
				selfie.shot
			fi
			if [[ "$(echo ${message_text[$id]%%@*} | grep "^\/ping" )" ]]; then
				ping.pong
			fi
			if [[ "$(echo ${message_text[$id]%%@*} | grep "^\/contas" )" ]]; then
				contas.cmd "${message_text[$id]}"
			fi
			if [[ "$(echo ${message_text[$id]%%@*} | grep "^\/reminder" )" ]]; then
				europe_todo_random.message
			fi
			if [[ "$(echo ${message_text[$id]%%@*} | grep "^\/trip" )" ]]; then
				trip.checklist "${message_text[$id]}"
			fi
		else
			chat.hi
		fi
	) & 
	done
done
#FIM

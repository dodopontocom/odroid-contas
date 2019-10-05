#!/bin/bash
#
sleep 7

# Importando API
BASEDIR=$(dirname $0)

# Validando variáveis necessárias
source ${BASEDIR}/functions/utils.sh

logs=${BASEDIR}/logs
notification_ids=($(cat ${BASEDIR}/.send_notification_ids))

# Token do bot
bot_token=${TELEGRAM_TOKEN}

# Inicializando o bot
ShellBot.init --token "$bot_token" --monitor --flush

message="Fui reiniciado"
for i in ${notification_ids[@]}; do
	ShellBot.sendMessage --chat_id ${i} --text "$(echo -e ${message})"
done
#######################Enviar estatísticas de comandos
#stat.verify "/home/odroid/telegram_bots_logs/contas_20190813-142401-qtlqdyekhfwtwsob.log" "$(echo ${notification_ids[@]})"
stat.verify "/home/odroid/telegram_bots_logs/contas_" "$(echo ${notification_ids[@]})"
####################################################
#######################Checar recorde de tempo 'vivo'
record.check "$(echo ${notification_ids[@]})"
####################################################

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
	
	############### verifica se ficou offline ########################################################################
	offline.checker "$(echo ${notification_ids[@]})" "90"
	##################################################################################################################
	
	#verifica se há arquivos avi do software motion e envia para mim
	motion.get

	for id in $(ShellBot.ListUpdates)
	do
	(
		ShellBot.watchHandle --callback_data ${callback_query_data[$id]}

		[[ ${message_new_chat_member_id[$id]} ]] && welcome.msg

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
			if [[ "$(echo ${message_text[$id]%%@*} | grep "^\/linux" )" ]]; then
				linux.cmd "${message_text[$id]}"
			fi
			if [[ "$(echo ${message_text[$id]%%@*} | grep "^\/selfie" )" ]]; then
				selfie.shot
			fi
			if [[ "$(echo ${message_text[$id]%%@*} | grep "^\/ping" )" ]]; then
				ping.pong
			fi
			if [[ "$(echo ${message_text[$id]%%@*} | grep "^\/trip" )" ]]; then
				trip.checklist "${message_text[$id]}"
			fi
			if [[ "$(echo ${message_text[$id]%%@*} | grep "^\/timezone" )" ]]; then
				timezone.place "${message_text[$id]}"
			fi
			if [[ "$(echo ${message_text[$id]%%@*} | grep "^\/days" )" ]]; then
				daysRemain="✅ $(days_from_today "2020-01-14") dias"
				ShellBot.sendMessage --chat_id ${message_chat_id[$id]} --text "$(echo -e ${daysRemain})"
			fi
			if [[ "$(echo ${message_text[$id]%%@*} | grep "^\/megasena" )" ]]; then
				lotomania.sena				
			fi
			if [[ "$(echo ${message_text[$id]%%@*} | grep "^\/stats" )" ]]; then
				stat.verify "/home/odroid/telegram_bots_logs/contas_"
			fi
			if [[ "$(echo ${message_text[$id]%%@*} | grep "^\/autokill" )" ]]; then
				set +f
				git --work-tree=/home/odroid/odroid-contas/ \
					--git-dir=/home/odroid/odroid-contas/.git pull origin develop
				killall contas.sh			
				set -f
			fi
		#else
		#	chat.hi
		fi
	) & 
	done
done
#FIM

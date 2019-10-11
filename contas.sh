#!/bin/bash
#

BASEDIR=$(dirname $0)

# Importante utils, script que contem o setup de inicialização do bot
source ${BASEDIR}/functions/utils.sh

#<TODO> jogar essa var em definitions
logs=${BASEDIR}/logs

# Inicializando o bot
ShellBot.init --token "${TELEGRAM_TOKEN}" --monitor --flush

# Envia notificação de que o bot foi reiniciado
for i in ${NOTIFICATION_IDS[@]}; do
	ShellBot.sendMessage --chat_id ${i} --text "🤖 Fui reiniciado ☝️"
done

################## Enviar estatísticas de comandos ##################
stats.verify ${STATS_LOG_PATH} "$(echo ${NOTIFICATION_IDS[@]})"
#####################################################################

####### Verificar recorde de tempo 'vivo' #######
record.check "$(echo ${NOTIFICATION_IDS[@]})"
#################################################

############ Botão para admins aceitarem usuários executarem comandos linux ###################
botao1=''

ShellBot.InlineKeyboardButton --button 'botao1' --line 1 --text 'SIM' --callback_data 'btn_s'
ShellBot.InlineKeyboardButton --button 'botao1' --line 1 --text 'NAO' --callback_data 'btn_n'

ShellBot.regHandleFunction --function linux.add --callback_data btn_s
ShellBot.regHandleFunction --function linux.reject --callback_data btn_n

keyboard_accept="$(ShellBot.InlineKeyboardMarkup -b 'botao1')"
###############################################################################################

######## revogar acessos ao comando linux ########
[[ -f ${TMP_PEDIDO} ]] && rm -rfv ${TMP_PEDIDO}
##################################################

################################################ keyboard para o comando trip ################################################
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
################################################################################################################################

############################## Botao para fazer backup dos arquivos dodrones ##############################
botao3=''

ShellBot.InlineKeyboardButton --button 'botao3' --line 1 --text 'SIM' --callback_data 'btn_dodrones_yes'
ShellBot.InlineKeyboardButton --button 'botao3' --line 1 --text 'NAO' --callback_data 'btn_dodrones_no'

ShellBot.regHandleFunction --function dodrones.execute --callback_data btn_dodrones_yes
ShellBot.regHandleFunction --function dodrones.cancel --callback_data btn_dodrones_no

keyboard_backup="$(ShellBot.InlineKeyboardMarkup -b 'botao3')"
##########################################################################################################

while :
do	
	ShellBot.getUpdates --limit 100 --offset $(ShellBot.OffsetNext) --timeout 30
	
	############### Verifica se o bot ficou offline #############################
	offline.checker "$(echo ${NOTIFICATION_IDS[@]})" "90"
	#############################################################################
	
	### verifica se há arquivos avi do software motion e envia para os admins ###
	motion.get
	#############################################################################

	for id in $(ShellBot.ListUpdates)
	do
	(
		ShellBot.watchHandle --callback_data ${callback_query_data[$id]}
		
		### Envia mensagem de boas vindas para novos usuários de grupo ###
		[[ ${message_new_chat_member_id[$id]} ]] && helper.welcome_message
		##################################################################

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
			if [[ "$(echo ${message_text[$id]%%@*} | grep "^\/chat" )" ]]; then
				chat.switch "${message_text[$id]}"
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
				days.remaining "${message_text[$id]}"
			fi
			if [[ "$(echo ${message_text[$id]%%@*} | grep "^\/megasena" )" ]]; then
				lotomania.sena				
			fi
			if [[ "$(echo ${message_text[$id]%%@*} | grep "^\/stats" )" ]]; then
				stats.verify ${STATS_LOG_PATH}
			fi
			if [[ "$(echo ${message_text[$id]%%@*} | grep "^\/restartbot" )" ]]; then
				restart.bot
			fi
			if [[ "$(echo ${message_text[$id]%%@*} | grep "^\/dodrones" )" ]]; then
				dodrones.check "${message_chat_id[$id]}"
			fi
			if [[ "$(echo ${message_text[$id]%%@*} | grep "^\/dockerbuild" )" ]]; then
				docker.build
			fi
			if [[ "$(echo ${message_text[$id]%%@*} | grep "^\/motion" )" ]]; then
				motion.switch "${message_text[$id]}"
			fi
			#### Comandos apenas para nossa viagem de Janeiro
			if [[ "$(echo ${message_text[$id]%%@*} | grep "^\/madri" )" ]]; then
				message="$(cat ${BASEDIR}/texts/trip_cities.csv | grep Madri | cut -d',' -f1)\n"
				message+="*$(cat ${BASEDIR}/texts/trip_cities.csv | grep Madri | cut -d',' -f2)*\n"
				message+="$(cat ${BASEDIR}/texts/trip_cities.csv | grep Madri | cut -d',' -f3)\n"
				message+="$(cat ${BASEDIR}/texts/trip_cities.csv | grep Madri | cut -d',' -f4)"
				ShellBot.sendMessage --chat_id ${message_chat_id[$id]} --text "$(echo -e ${message})" --parse_mode markdown
			fi
			if [[ "$(echo ${message_text[$id]%%@*} | grep "^\/dublin" )" ]]; then
				message="$(cat ${BASEDIR}/texts/trip_cities.csv | grep Dublin | cut -d',' -f1)\n"
				message+="*$(cat ${BASEDIR}/texts/trip_cities.csv | grep Dublin | cut -d',' -f2)*\n"
				message+="$(cat ${BASEDIR}/texts/trip_cities.csv | grep Dublin | cut -d',' -f3)\n"
				message+="$(cat ${BASEDIR}/texts/trip_cities.csv | grep Dublin | cut -d',' -f4)"
				ShellBot.sendMessage --chat_id ${message_chat_id[$id]} --text "$(echo -e ${message})" --parse_mode markdown
			fi
			if [[ "$(echo ${message_text[$id]%%@*} | grep "^\/liverpool" )" ]]; then
				message="$(cat ${BASEDIR}/texts/trip_cities.csv | grep Liverpool | cut -d',' -f1)\n"
				message+="*$(cat ${BASEDIR}/texts/trip_cities.csv | grep Liverpool | cut -d',' -f2)*\n"
				message+="$(cat ${BASEDIR}/texts/trip_cities.csv | grep Liverpool | cut -d',' -f3)\n"
				message+="$(cat ${BASEDIR}/texts/trip_cities.csv | grep Liverpool | cut -d',' -f4)"
				ShellBot.sendMessage --chat_id ${message_chat_id[$id]} --text "$(echo -e ${message})" --parse_mode markdown
			fi
			if [[ "$(echo ${message_text[$id]%%@*} | grep "^\/londres" )" ]]; then
				message="$(cat ${BASEDIR}/texts/trip_cities.csv | grep Londres | cut -d',' -f1)\n"
				message+="*$(cat ${BASEDIR}/texts/trip_cities.csv | grep Londres | cut -d',' -f2)*\n"
				message+="$(cat ${BASEDIR}/texts/trip_cities.csv | grep Londres | cut -d',' -f3)\n"
				message+="$(cat ${BASEDIR}/texts/trip_cities.csv | grep Londres | cut -d',' -f4)"
				ShellBot.sendMessage --chat_id ${message_chat_id[$id]} --text "$(echo -e ${message})" --parse_mode markdown
			fi
			if [[ "$(echo ${message_text[$id]%%@*} | grep "^\/berlim" )" ]]; then
				message="$(cat ${BASEDIR}/texts/trip_cities.csv | grep Berlim | cut -d',' -f1)\n"
				message+="*$(cat ${BASEDIR}/texts/trip_cities.csv | grep Berlim | cut -d',' -f2)*\n"
				message+="$(cat ${BASEDIR}/texts/trip_cities.csv | grep Berlim | cut -d',' -f3)\n"
				message+="$(cat ${BASEDIR}/texts/trip_cities.csv | grep Berlim | cut -d',' -f4)"
				ShellBot.sendMessage --chat_id ${message_chat_id[$id]} --text "$(echo -e ${message})" --parse_mode markdown
			fi
			if [[ "$(echo ${message_text[$id]%%@*} | grep "^\/amsterdam" )" ]]; then
				message="$(cat ${BASEDIR}/texts/trip_cities.csv | grep Amsterdam | cut -d',' -f1)\n"
				message+="*$(cat ${BASEDIR}/texts/trip_cities.csv | grep Amsterdam | cut -d',' -f2)*\n"
				message+="$(cat ${BASEDIR}/texts/trip_cities.csv | grep Amsterdam | cut -d',' -f3)\n"
				message+="$(cat ${BASEDIR}/texts/trip_cities.csv | grep Amsterdam | cut -d',' -f4)"
				ShellBot.sendMessage --chat_id ${message_chat_id[$id]} --text "$(echo -e ${message})" --parse_mode markdown
			fi
			if [[ "$(echo ${message_text[$id]%%@*} | grep "^\/bruxelas" )" ]]; then
				message="$(cat ${BASEDIR}/texts/trip_cities.csv | grep Bruxelas | cut -d',' -f1)\n"
				message+="*$(cat ${BASEDIR}/texts/trip_cities.csv | grep Bruxelas | cut -d',' -f2)*\n"
				message+="$(cat ${BASEDIR}/texts/trip_cities.csv | grep Bruxelas | cut -d',' -f3)\n"
				message+="$(cat ${BASEDIR}/texts/trip_cities.csv | grep Bruxelas | cut -d',' -f4)"
				ShellBot.sendMessage --chat_id ${message_chat_id[$id]} --text "$(echo -e ${message})" --parse_mode markdown
			fi
			if [[ "$(echo ${message_text[$id]%%@*} | grep "^\/paris" )" ]]; then
				message="$(cat ${BASEDIR}/texts/trip_cities.csv | grep Paris | cut -d',' -f1)\n"
				message+="*$(cat ${BASEDIR}/texts/trip_cities.csv | grep Paris | cut -d',' -f2)*\n"
				message+="$(cat ${BASEDIR}/texts/trip_cities.csv | grep Paris | cut -d',' -f3)\n"
				message+="$(cat ${BASEDIR}/texts/trip_cities.csv | grep Paris | cut -d',' -f4)"
				ShellBot.sendMessage --chat_id ${message_chat_id[$id]} --text "$(echo -e ${message})" --parse_mode markdown
			fi
			if [[ "$(echo ${message_text[$id]%%@*} | grep "^\/veneza" )" ]]; then
				message="$(cat ${BASEDIR}/texts/trip_cities.csv | grep Venesa | cut -d',' -f1)\n"
				message+="*$(cat ${BASEDIR}/texts/trip_cities.csv | grep Venesa | cut -d',' -f2)*\n"
				message+="$(cat ${BASEDIR}/texts/trip_cities.csv | grep Venesa | cut -d',' -f3)\n"
				message+="$(cat ${BASEDIR}/texts/trip_cities.csv | grep Venesa | cut -d',' -f4)"
				ShellBot.sendMessage --chat_id ${message_chat_id[$id]} --text "$(echo -e ${message})" --parse_mode markdown
			fi
			if [[ "$(echo ${message_text[$id]%%@*} | grep "^\/roma" )" ]]; then
				message="$(cat ${BASEDIR}/texts/trip_cities.csv | grep Roma | cut -d',' -f1)\n"
				message+="*$(cat ${BASEDIR}/texts/trip_cities.csv | grep Roma | cut -d',' -f2)*\n"
				message+="$(cat ${BASEDIR}/texts/trip_cities.csv | grep Roma | cut -d',' -f3)\n"
				message+="$(cat ${BASEDIR}/texts/trip_cities.csv | grep Roma | cut -d',' -f4)"
				ShellBot.sendMessage --chat_id ${message_chat_id[$id]} --text "$(echo -e ${message})" --parse_mode markdown
			fi
		else
			# Conversa aleatória com o bot #
			chat.hi
			################################
		fi
	) & 
	done
done

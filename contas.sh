#!/bin/bash
#
#
#
export BASEDIR="$(cd $(dirname ${BASH_SOURCE[0]}) >/dev/null 2>&1 && pwd)"
# Importante utils, script que contem o setup de inicialização do bot
source ${BASEDIR}/functions/utils.sh

#<TODO> jogar essa var em definitions
logs=${BASEDIR}/logs

# Envia notificação de que o bot foi reiniciado
for i in ${NOTIFICATION_IDS[@]}; do
	ShellBot.sendMessage --chat_id ${i} --text "🤖 Bot reiniciado ☝️"
done

#### contas: Criar os itens dos cases dinamicamente
_CONTAS_ARR=($(cat ${BOT_CONTAS_LIST} | cut -d',' -f5))
_CONTAS_SIM_ARR=($(cat ${BOT_CONTAS_LIST} | cut -d',' -f6))
_CONTAS_NAO_ARR=($(cat ${BOT_CONTAS_LIST} | cut -d',' -f7))
#####################################################################

################## Enviar estatísticas de comandos ##################
#stats.verify ${STATS_LOG_PATH} "$(echo ${NOTIFICATION_IDS[@]})"
#####################################################################

####### Verificar recorde de tempo 'vivo' #######
#record.check "$(echo ${NOTIFICATION_IDS[@]})"
#################################################

while :
do
	ShellBot.getUpdates --limit 100 --offset $(ShellBot.OffsetNext) --timeout 30
	
	
	################## verificar se virou o mes para atualizar contas ##################
	contas.verifica_mes $(date "+%m")
	#####################################################################
	
	################## verificar espaço em disco ( / ) ##################
	#disk.warn "/" "90" ${NOTIFICATION_IDS[0]}
	#####################################################################

	############### Verifica se o bot ficou offline #############################
	#offline.checker "$(echo ${NOTIFICATION_IDS[@]})" "90"
	#############################################################################

	### verifica se há arquivos avi do software motion e envia para os admins ###
	#motion.get
	#############################################################################

	for id in $(ShellBot.ListUpdates)
	do
	(
		ShellBot.watchHandle --callback_data ${callback_query_data[$id]}

		### Envia mensagem de boas vindas para novos usuários de grupo ###
		[[ ${message_new_chat_member_id[$id]} ]] && helper.welcome_message
		##################################################################
		if [[ ${message_chat_id} == "${PRECOS_GROUP_ID}" ]] && [[ ${message_entities_type[$id]} != bot_command ]] && [[ -z ${callback_query_data[$id]} ]]; then
			listar.compras "${message_text}"
		else
			chat.hi
		fi
		case ${callback_query_data[$id]} in
			pdfgrep.reply_itatiba) pdfgrep.reply_itatiba ;;
			item_comprado) listar.apagar ;;
			item_valor) listar.preco ;;

			'lotodicas.sena'|'lotodicas.lotofacil'|'lotodicas.quina'|'lotodicas.duplasena' \
					|'lotodicas.lotomania'|'lotodicas.timemania'|'lotodicas.diasorte') lotodicas.get ;;

		esac
		for c in ${_CONTAS_ARR[@]}; do
			case ${callback_query_data[$id]} in
				${c}) contas.show_contas ;;
			esac
		done
		for s in ${_CONTAS_SIM_ARR[@]}; do
			case ${callback_query_data[$id]} in
				${s}) contas.yesno_buttons ;;
			esac
		done
		for n in ${_CONTAS_NAO_ARR[@]}; do
			case ${callback_query_data[$id]} in
				${n}) contas.yesno_buttons ;;
			esac
		done
		
		if [[ ${message_reply_to_message_message_id[$id]} ]]; then
			case ${message_reply_to_message_text[$id]} in
				'Pesquisa Itatiba:')
					pdfgrep.itatiba "${message_text[$id]}"
				;;
				'Pesquisa Cerquilho:')
					pdfgrep.cerquilho "${message_text[$id]}"
				;;
			esac
		fi
		
		if [[ ${message_entities_type[$id]} == bot_command ]]; then
			if [[ "$(echo ${message_text[$id]%%@*} | grep "^\/construtora" )" ]]; then
				site.upload
			fi
			if [[ "$(echo ${message_text[$id]%%@*} | grep "^\/circleci" )" ]]; then
				circleci.commit "${message_text[$id]}"
			fi
			if [[ "$(echo ${message_text[$id]%%@*} | grep "^\/cidades" )" ]]; then
				pdfgrep.keyboard
			fi
			if [[ "$(echo ${message_text[$id]%%@*} | grep "^\/contas" )" ]]; then
				contas.show_keyboard
			fi
			if [[ "$(echo ${message_text[$id]%%@*} | grep "^\/concursos" )" ]]; then
				pdfgrep.informativo
			fi
			if [[ "$(echo ${message_text[$id]%%@*} | grep "^\/loterias" )" ]]; then
				lotodicas.keyboards
			fi
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
			if [[ "$(echo ${message_text[$id]%%@*} | grep "^\/botreset" )" ]]; then
				bot_reset.bot
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
			if [[ "$(echo ${message_text[$id]%%@*} | grep "^\/servo" )" ]]; then
				servo.play "${message_text[$id]}"
			fi
			if [[ "$(echo ${message_text[$id]%%@*} | grep "^\/disk" )" ]]; then
				disk.warn "${message_text[$id]}"
			fi
			if [[ "$(echo ${message_text[$id]%%@*} | grep "^\/botip" )" ]]; then
                               my_ip.get
                        fi

			#### Comandos apenas para nossa viagem de Janeiro
			#if [[ "$(echo ${message_text[$id]%%@*} | grep "^\/cidades" )" ]]; then
			#	trip.all_cities
			#fi
			if [[ "$(echo ${message_text[$id]%%@*} | grep "^\/madri" )" ]]; then
				trip.cities Madri
			fi
			if [[ "$(echo ${message_text[$id]%%@*} | grep "^\/dublin" )" ]]; then
				trip.cities Dublin
			fi
			if [[ "$(echo ${message_text[$id]%%@*} | grep "^\/liverpool" )" ]]; then
				trip.cities Liverpool
			fi
			if [[ "$(echo ${message_text[$id]%%@*} | grep "^\/londres" )" ]]; then
				trip.cities Londres
			fi
			if [[ "$(echo ${message_text[$id]%%@*} | grep "^\/berlim" )" ]]; then
				trip.cities Berlim
			fi
			if [[ "$(echo ${message_text[$id]%%@*} | grep "^\/amsterdam" )" ]]; then
				trip.cities Amsterdam
			fi
			if [[ "$(echo ${message_text[$id]%%@*} | grep "^\/bruxelas" )" ]]; then
				trip.cities Bruxelas
			fi
			if [[ "$(echo ${message_text[$id]%%@*} | grep "^\/paris" )" ]]; then
				trip.cities Paris
			fi
			if [[ "$(echo ${message_text[$id]%%@*} | grep "^\/veneza" )" ]]; then
				trip.cities Veneza
			fi
			if [[ "$(echo ${message_text[$id]%%@*} | grep "^\/roma" )" ]]; then
				trip.cities Roma
			fi
			if [[ "$(echo ${message_text[$id]%%@*} | grep "^\/baggage" )" ]]; then
				trip.baggage
			fi
			
		#else
		#	# Conversa aleatória com o bot #
		#	#chat.hi
		#	if [[ ${message_chat_id} == "${PRECOS_GROUP_ID}" ]]; then
		#		product.search
		#	else
		#		chat.hi
		#	fi
		#	################################
		fi
	) &
	done
done

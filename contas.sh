#!/bin/bash
#
export BASEDIR="$(cd $(dirname ${BASH_SOURCE[0]}) >/dev/null 2>&1 && pwd)"

source ${BASEDIR}/.definitions.sh
#source ${BASEDIR}/functions/init.sh

#TBOTLIB
source ${BASEDIR}/tbotlib.sh

tbotlib.use.WelcomeMessage
tbotlib.use.BooleanInlineButton

# Fazer source das urls para uso da função de busca nos editais
#source ${BASEDIR}/configs/pdfgrep_urls.sh
# Fazer source da API só depois de baixá-la
#source ${BASEDIR}/configs/keyboards.sh

#<TODO> jogar essa var em definitions
# logs=${BASEDIR}/logs

# Envia notificação de que o bot foi reiniciado
# for i in ${NOTIFICATION_IDS[@]}; do
# 	ShellBot.sendMessage --chat_id ${i} --text "🤖 Bot reiniciado ☝️"
# done

#### contas: Criar os itens dos cases dinamicamente
# _CONTAS_ARR=($(cat ${BOT_CONTAS_LIST} | cut -d',' -f5))
# _CONTAS_SIM_ARR=($(cat ${BOT_CONTAS_LIST} | cut -d',' -f6))
# _CONTAS_NAO_ARR=($(cat ${BOT_CONTAS_LIST} | cut -d',' -f7))
#####################################################################

################## Enviar estatísticas de comandos ##################
#stats.verify ${STATS_LOG_PATH} "$(echo ${NOTIFICATION_IDS[@]})"
#####################################################################

####### Verificar recorde de tempo 'vivo' #######
#record.check "$(echo ${NOTIFICATION_IDS[@]})"
#################################################

motion_button="motion_camera_switch"

while :
do
	ShellBot.getUpdates --limit 100 --offset $(ShellBot.OffsetNext) --timeout 30

	for id in $(ShellBot.ListUpdates)
	do
	(
		ShellBot.watchHandle --callback_data ${callback_query_data[$id]}

        [[ ${message_new_chat_member_id[$id]} ]] && WelcomeMessage.send --short --message "I like you"
		
        case ${callback_query_data[$id]} in
            tick_to_false.bool_1) tick_to_false.bool_button bool_1 ;;
            tick_to_true.bool_1) tick_to_true.bool_button bool_1 ;;
		esac
		
		if [[ ${message_entities_type[$id]} == bot_command ]]; then
			if [[ "$(echo ${message_text[$id]%%@*} | grep "^\/switch" )" ]]; then
				BooleanInlineButton.init --true-value "ON" --false-value "OFF" --button-name "bool_1"
            fi
		fi
	) &
	done
done
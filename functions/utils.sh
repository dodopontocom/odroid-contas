#!/bin/bash

# Script que carrega as configurações iniciais do bot

################################# START - Carregando todas as funções #################################
test -f ${BASEDIR}/.definitions.sh && source ${BASEDIR}/.definitions.sh
source ${BASEDIR}/functions/helper.sh

source ${BASEDIR}/functions/start.sh
source ${BASEDIR}/functions/speedtest.sh
source ${BASEDIR}/functions/voice.sh
source ${BASEDIR}/functions/linux.sh
source ${BASEDIR}/functions/selfie.sh
source ${BASEDIR}/functions/ping.sh
source ${BASEDIR}/functions/chat.sh
source ${BASEDIR}/functions/trip.sh
source ${BASEDIR}/functions/motion.sh
source ${BASEDIR}/functions/timezone.sh
source ${BASEDIR}/functions/offline.sh
source ${BASEDIR}/functions/lotomania.sh
source ${BASEDIR}/functions/record_alive.sh
source ${BASEDIR}/functions/stats.sh
source ${BASEDIR}/functions/bot_reset.sh
source ${BASEDIR}/functions/dodrones.sh
source ${BASEDIR}/functions/docker.sh
source ${BASEDIR}/functions/days_remaining.sh
source ${BASEDIR}/functions/servo_play.sh
source ${BASEDIR}/functions/disk.sh
source ${BASEDIR}/functions/options.sh
################################# END - Carregando todas as funções #################################

# Saber se tem o telegram token e ao menos um id de adminitrador exportado como variável de ambiente do sistema
# Essas variáveis devem ser setadas no arquivo .definitions.sh
helper.validate_vars TELEGRAM_TOKEN NOTIFICATION_IDS

helper.get_api
exitOnError "Erro ao tentar baixar API ShellBot" $?

# Fazer source da API só depois de baixá-la
source ${BASEDIR}/ShellBot.sh

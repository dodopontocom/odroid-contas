#!/bin/bash

# Exit utils.sh on any error
#set -e

source ${BASEDIR}/.definitions.sh

source ${BASEDIR}/functions/start.sh
source ${BASEDIR}/functions/speedtest.sh
source ${BASEDIR}/functions/voice.sh
source ${BASEDIR}/functions/linux.sh
source ${BASEDIR}/functions/selfie.sh
source ${BASEDIR}/functions/ping.sh
source ${BASEDIR}/functions/chat.sh
source ${BASEDIR}/functions/trip.sh
source ${BASEDIR}/functions/motion.sh
source ${BASEDIR}/functions/welcome.sh
source ${BASEDIR}/functions/timezone.sh
source ${BASEDIR}/functions/date_arithmetic.sh
source ${BASEDIR}/functions/offline.sh
source ${BASEDIR}/functions/lotomania.sh
source ${BASEDIR}/functions/record_alive.sh
source ${BASEDIR}/functions/stats.sh
source ${BASEDIR}/functions/random.sh
source ${BASEDIR}/functions/shell_api.sh
source ${BASEDIR}/functions/var_utils.sh
source ${BASEDIR}/functions/restart_bot.sh
source ${BASEDIR}/functions/accept_linux.sh
source ${BASEDIR}/functions/dodrones.sh

# temp vars usadas no comando /linux
tmp_pedido="/tmp/pedido_cadastro.log"
tmp_pedido_temp="/tmp/temp_pedido_cadastro.log"

# Primeira verificação de todas é saber se tem o token exportado variável de ambiente do sistema
validate.vars TELEGRAM_TOKEN NOTIFICATION_IDS

# Sempre pegar a última versão do ShellBot API
# <TODO> Avisar que houve nova versao e deixar o usuário baixar por ele mesmo , evita possíveis erros em ter a api atualizada dinamicamente
dinamic.api

# Fazer source da API só depois de baixá-la
source ${BASEDIR}/ShellBot.sh

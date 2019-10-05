#!/bin/bash

source ${BASEDIR}/.definitions.sh

source ${BASEDIR}/ShellBot.sh

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
source ${BASEDIR}/functions/statistics.sh
source ${BASEDIR}/functions/random.sh
source ${BASEDIR}/functions/validate_vars.sh
source ${BASEDIR}/functions/shell_api.sh


# Primeira verificação de todas é saber se tem o token exportado variável de ambiente do sistema
validateVars TELEGRAM_TOKEN

# Sempre pegar a última versão do ShellBot API
# <TODO> Avisar que houve nova versao e deixar o usuário baixar por ele mesmo , evita possíveis erros em ter a api atualizada dinamicamente
api.dinamic

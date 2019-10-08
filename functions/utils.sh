#!/bin/bash

################################# START - VARIÁVEIS GLOBAIS #################################
export PENDING_PEDIDO="/tmp/pedido.pending"
export TMP_PEDIDO="/tmp/pedido_cadastro.log"
export BOT_BKP_PATH="/mnt/sdcard/telegram_bots_bkp"

export CHAT_SIMPLE_REPLY="${BASEDIR}/texts/words.txt"
export CENTRAL_OF_MESSAGES_FILE="${BASEDIR}/texts/central_of_messages.txt"
export BOT_COMMANDS_LIST="${BASEDIR}/texts/commands_list.txt"

export DODRONES_MOUNT_PATH="/mnt/hd1"
export DODRONES_HOST="rodolfo@192.168.0.107"
export DODRONES_HOST_PATH="/home/rodolfo/Desktop/bot"

export API_GIT_URL="https://github.com/shellscriptx/shellbot.git"
export LOTOMANIA_API_URL="https://www.lotodicas.com.br/api"
export TIMEZONE_API_URL="http://worldtimeapi.org/api/timezone"

export MOTION_DETECTED_PATH="/mnt/sdcard/motion/detect"

export TRIP_CHECKLIST_FILE="${BASEDIR}/texts/trip_checklist.csv"

export GNU_PLOT_ORIGINAL_SCRIPT="${BASEDIR}/configurations/original_plot.gp"
export GNU_PLOT_SCRIPT="${BASEDIR}/configurations/plot.gp"
export GNU_PLOT_IMAGE_OUTPUT="/tmp/temp_plot_image.png"
export GNU_PLOT_DAT="${BASEDIR}/configurations/test.dat"
################################# END - VARIÁVEIS GLOBAIS #################################

################################# START - Carregando todas as funções #################################
source ${BASEDIR}/.definitions.sh
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
source ${BASEDIR}/functions/welcome.sh
source ${BASEDIR}/functions/timezone.sh
source ${BASEDIR}/functions/date_arithmetic.sh
source ${BASEDIR}/functions/offline.sh
source ${BASEDIR}/functions/lotomania.sh
source ${BASEDIR}/functions/record_alive.sh
source ${BASEDIR}/functions/stats.sh
source ${BASEDIR}/functions/random.sh
source ${BASEDIR}/functions/shell_api.sh
source ${BASEDIR}/functions/restart_bot.sh
source ${BASEDIR}/functions/dodrones.sh
source ${BASEDIR}/functions/days_remaining.sh
################################# END - Carregando todas as funções #################################

# Saber se tem o telegram token e ao menos um id de adminitrador exportado como variável de ambiente do sistema
# Essas variáveis devem ser setadas no arquivo .definitions.sh
helper.validate_vars TELEGRAM_TOKEN NOTIFICATION_IDS

# Sempre pegar a última versão do ShellBot API
# <TODO> Avisar que houve nova versao e deixar o usuário baixar por ele mesmo , evita possíveis erros em ter a api atualizada dinamicamente
dinamic.api
exitOnError "Erro ao tentar baixar API ShellBot"

# Fazer source da API só depois de baixá-la
source ${BASEDIR}/ShellBot.sh

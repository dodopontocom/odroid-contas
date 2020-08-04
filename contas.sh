#!/bin/bash
#
export BASEDIR="$(cd $(dirname ${BASH_SOURCE[0]}) >/dev/null 2>&1 && pwd)"

source ${BASEDIR}/.definitions.sh
#source ${BASEDIR}/functions/init.sh

#TBOTLIB
source ${BASEDIR}/tbotlib.sh

tbotlib.use.WelcomeMessage
tbotlib.use.BooleanInlineButton

motion_button="motion_camera_switch"
#BooleanInlineButton.init --command "botao" --true-value "ON" --false-value "OFF" --button-name "${motion_button}"

tbotlib.polling
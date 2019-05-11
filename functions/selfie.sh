#!/bin/bash
#
source ${BASEDIR}/functions/random.sh

selfie.shot() {
  local message random_file_name
  random_file_name=$(random.helper)
  message="*tirando uma foto 🤳*"
  
  ShellBot.sendMessage --chat_id ${message_chat_id[$id]} --text "$(echo -e ${message})" --parse_mode markdown
  
  #start motion
  #save the photo in tmp folder with the random name
  # https://www.raspberrypi.org/documentation/usage/webcams/
  # fswebcam -r 1280x720 /tmp/${random_file_name}.jpg
  #stop motion
  
  ShellBot.sendPhoto --chat_id ${message_chat_id[$id]} --photo @/tmp/${random_file_name}.jpg
}

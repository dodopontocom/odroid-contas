#!/bin/bash

source ${BASEDIR}/ShellBot.sh
ShellBot.init --token "${TELEGRAM_TOKEN}" --monitor --flush

############ Botão para admins aceitarem usuários executarem comandos linux ###################
botao1=''

ShellBot.InlineKeyboardButton --button 'botao1' --line 1 --text 'SIM' --callback_data 'btn_s'
ShellBot.InlineKeyboardButton --button 'botao1' --line 1 --text 'NAO' --callback_data 'btn_n'

ShellBot.regHandleFunction --function linux.add --callback_data btn_s
ShellBot.regHandleFunction --function linux.reject --callback_data btn_n

keyboard_accept="$(ShellBot.InlineKeyboardMarkup -b 'botao1')"
###############################################################################################
############ LOTERIAS ##############
loto=''

ShellBot.InlineKeyboardButton --button 'loto' --line 1 --text 'MEGASENA' --callback_data 'lotodicas.sena'
ShellBot.InlineKeyboardButton --button 'loto' --line 1 --text 'LOTOFACIL' --callback_data 'lotodicas.lotofacil'
ShellBot.InlineKeyboardButton --button 'loto' --line 2 --text 'QUINA' --callback_data 'lotodicas.quina'
ShellBot.InlineKeyboardButton --button 'loto' --line 2 --text 'DUPLASENA' --callback_data 'lotodicas.duplasena'
ShellBot.InlineKeyboardButton --button 'loto' --line 3 --text 'LOTOMANIA' --callback_data 'lotodicas.lotomania'
ShellBot.InlineKeyboardButton --button 'loto' --line 3 --text 'TIMEMANIA' --callback_data 'lotodicas.timemania'
ShellBot.InlineKeyboardButton --button 'loto' --line 4 --text 'DIA DE SORTE' --callback_data 'lotodicas.diasorte'
keyboard_loto="$(ShellBot.InlineKeyboardMarkup -b 'loto')"
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

############################## Botao de enviar localização da estação/aeroporto ##############################
btn_GRU=''
ShellBot.InlineKeyboardButton --button 'btn_GRU' --line 1 --text 'GRU AIRPORT 📍' --callback_data 'btn_GRU' --url 'https://goo.gl/maps/goUycSPdkwYHPupq5'
ShellBot.InlineKeyboardButton --button 'btn_GRU' --line 1 --text 'MADRI HOSTEL 📍' --callback_data 'btn_MAD_HOST' --url 'https://goo.gl/maps/QpFB36uCSKnSbrD7A'
ShellBot.regHandleFunction --function trip.btn_GRU --callback_data btn_GRU
ShellBot.regHandleFunction --function trip.btn_GRU --callback_data btn_MAD_HOST
keyboard_GRU="$(ShellBot.InlineKeyboardMarkup -b 'btn_GRU')"

btn_DUB=''
ShellBot.InlineKeyboardButton --button 'btn_DUB' --line 1 --text 'MADRI AIRPORT 📍' --callback_data 'btn_DUB_MAD' --url 'https://goo.gl/maps/iB6SeNpfm3yTuJ6L6'
ShellBot.InlineKeyboardButton --button 'btn_DUB' --line 1 --text 'DUBLIN HOSTEL 📍' --callback_data 'btn_DUB_HOST' --url 'https://goo.gl/maps/DUdGUuJsH3VUBy4F6'
ShellBot.regHandleFunction --function trip.btn_DUB --callback_data btn_DUB
ShellBot.regHandleFunction --function trip.btn_DUB --callback_data btn_DUB_HOST
keyboard_DUB="$(ShellBot.InlineKeyboardMarkup -b 'btn_DUB')"

btn_LIV=''
ShellBot.InlineKeyboardButton --button 'btn_LIV' --line 1 --text 'DUBLIN AIRPORT 📍' --callback_data 'btn_LIV_DUB' --url 'https://goo.gl/maps/Yh8bqZuCiT8Z6tGD9'
ShellBot.regHandleFunction --function trip.btn_LIV --callback_data btn_LIV
keyboard_LIV="$(ShellBot.InlineKeyboardMarkup -b 'btn_LIV')"

btn_LON=''
ShellBot.InlineKeyboardButton --button 'btn_LON' --line 1 --text 'LIVERPOOL BUS ST 📍' --callback_data 'btn_LON_LIV' --url 'https://goo.gl/maps/gNitbuX1jcJ4bwX58'
ShellBot.InlineKeyboardButton --button 'btn_LON' --line 1 --text 'LONDON HOSTEL 📍' --callback_data 'btn_LON_HOST' --url 'https://goo.gl/maps/N1zZdajWEmk66Lvi7'
ShellBot.regHandleFunction --function trip.btn_LON --callback_data btn_LON_LIV
ShellBot.regHandleFunction --function trip.btn_LON --callback_data btn_LON_HOST
keyboard_LON="$(ShellBot.InlineKeyboardMarkup -b 'btn_LON')"

btn_BER=''
ShellBot.InlineKeyboardButton --button 'btn_BER' --line 1 --text 'LONDON AIRPORT 📍' --callback_data 'btn_BER_LON' --url 'https://goo.gl/maps/G6XZe7AaDZ8b3txC8'
#ShellBot.InlineKeyboardButton --button 'btn_BER' --line 1 --text 'BERLIN HOSTEL 📍' --callback_data 'btn_BER_HOST' --url 'https://goo.gl/maps/RmQpsF3ZiuT29sUeA'
ShellBot.regHandleFunction --function trip.btn_BER --callback_data btn_BER_LON
ShellBot.regHandleFunction --function trip.btn_BER --callback_data btn_BER_HOST
keyboard_BER="$(ShellBot.InlineKeyboardMarkup -b 'btn_BER')"

btn_AMS=''
ShellBot.InlineKeyboardButton --button 'btn_AMS' --line 1 --text 'BERLIN TRAIN STATION 📍' --callback_data 'btn_AMS_BER' --url 'https://goo.gl/maps/AbqQTgnkLHrpYVNV7'
ShellBot.InlineKeyboardButton --button 'btn_AMS' --line 1 --text 'AMSTERDAM HOSTEL 📍' --callback_data 'btn_AMS_HOST' --url 'https://goo.gl/maps/2ou2Xa4HRq5WAcEw7'
ShellBot.regHandleFunction --function trip.btn_AMS --callback_data btn_AMS_BER
ShellBot.regHandleFunction --function trip.btn_AMS --callback_data btn_AMS_HOST
keyboard_AMS="$(ShellBot.InlineKeyboardMarkup -b 'btn_AMS')"

btn_BRU=''
ShellBot.InlineKeyboardButton --button 'btn_BRU' --line 1 --text 'AMSTERDAM STATION 📍' --callback_data 'btn_BRU_AMS' --url 'https://goo.gl/maps/4gqNYBJuUJeCFLcS8'
ShellBot.InlineKeyboardButton --button 'btn_BRU' --line 2 --text 'BRUXELAS STATION 📍' --callback_data 'btn_BRU_STAT' --url 'https://goo.gl/maps/iB6SeNpfm3yTuJ6L6'
ShellBot.InlineKeyboardButton --button 'btn_BRU' --line 2 --text 'BRUGES HOSTEL 📍' --callback_data 'btn_BRUG_HOST' --url 'https://goo.gl/maps/ixKdV72SpJUczpDW9'
ShellBot.InlineKeyboardButton --button 'btn_BRU' --line 3 --text 'ERICs HOUSE 📍' --callback_data 'btn_ERIC' --url 'https://goo.gl/maps/iB6SeNpfm3yTuJ6L6'
ShellBot.regHandleFunction --function trip.btn_BRU --callback_data btn_BRU_AMS
ShellBot.regHandleFunction --function trip.btn_BRU --callback_data btn_BRU_STAT
ShellBot.regHandleFunction --function trip.btn_BRU --callback_data btn_BRUG_HOST
ShellBot.regHandleFunction --function trip.btn_BRU --callback_data btn_ERIC
keyboard_BRU="$(ShellBot.InlineKeyboardMarkup -b 'btn_BRU')"

btn_PAR=''
ShellBot.InlineKeyboardButton --button 'btn_PAR' --line 1 --text 'BRUXELAS STATION 📍' --callback_data 'btn_PAR_BRU' --url 'https://goo.gl/maps/iB6SeNpfm3yTuJ6L6'
ShellBot.InlineKeyboardButton --button 'btn_PAR' --line 1 --text 'PARIS HOSTEL 📍' --callback_data 'btn_PAR_HOST' --url 'https://goo.gl/maps/myRmXNz5zzaDw95d7'
ShellBot.regHandleFunction --function trip.btn_PAR --callback_data btn_PAR_BRU
ShellBot.regHandleFunction --function trip.btn_PAR --callback_data btn_PAR_HOST
keyboard_PAR="$(ShellBot.InlineKeyboardMarkup -b 'btn_PAR')"

btn_VEN=''
ShellBot.InlineKeyboardButton --button 'btn_VEN' --line 1 --text 'PARIS AIRPORT 📍' --callback_data 'btn_VEN_PAR' --url 'https://goo.gl/maps/3jUf1d7FJ1iNGnUX9'
ShellBot.InlineKeyboardButton --button 'btn_VEN' --line 1 --text 'VENEZA HOSTEL 📍' --callback_data 'btn_VEN_HOST' --url 'https://goo.gl/maps/iHPGTUDP2uChgyhP8'
ShellBot.regHandleFunction --function trip.btn_VEN --callback_data btn_VEN_PAR
ShellBot.regHandleFunction --function trip.btn_VEN --callback_data btn_VEN_HOST
keyboard_VEN="$(ShellBot.InlineKeyboardMarkup -b 'btn_VEN')"

btn_ROM=''
ShellBot.InlineKeyboardButton --button 'btn_ROM' --line 1 --text 'VENEZA STATION 📍' --callback_data 'btn_ROM_VEN' --url 'https://goo.gl/maps/bz95S8tgnj1V1UnY6'
ShellBot.InlineKeyboardButton --button 'btn_ROM' --line 1 --text 'ROME HOSTEL 📍' --callback_data 'btn_ROM_HOST' --url 'https://g.page/AlessandroDowntown?share'
ShellBot.InlineKeyboardButton --button 'btn_ROM' --line 2 --text 'ROME AIRPORT 📍' --callback_data 'btn_ROM_AIRPORT' --url 'https://goo.gl/maps/sDMKrFNZHeobuUTc8'
ShellBot.InlineKeyboardButton --button 'btn_ROM' --line 2 --text 'CASA!!! 📍' --callback_data 'btn_DALIAS' --url 'https://goo.gl/maps/iJxa8Y6Mzd69pufU9'
ShellBot.regHandleFunction --function trip.btn_ROM --callback_data btn_ROM_VEN
ShellBot.regHandleFunction --function trip.btn_ROM --callback_data btn_ROM_HOST
ShellBot.regHandleFunction --function trip.btn_ROM --callback_data btn_ROM_AIRPORT
ShellBot.regHandleFunction --function trip.btn_ROM --callback_data btn_DALIAS
keyboard_ROM="$(ShellBot.InlineKeyboardMarkup -b 'btn_ROM')"
##########################################################################################################

###########################DIÁRIO DE ITATIBA BOT#######################################
btn_cidades=''
ShellBot.InlineKeyboardButton --button 'btn_cidades' --text "Itatiba" --callback_data 'pdfgrep.itatiba' --line 1
ShellBot.InlineKeyboardButton --button 'btn_cidades' --text "Jundiaí" --callback_data 'pdfgrep.jundiai' --line 1
keyboard_cidades="$(ShellBot.InlineKeyboardMarkup -b 'btn_cidades')"
################################################################################################
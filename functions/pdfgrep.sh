#!/bin/bash

pdfgrep.keyboard() {
	ShellBot.sendMessage --chat_id ${message_chat_id[$id]} \
					--text "*Cidades disponíveis para consulta*" \
					--parse_mode markdown \
					--reply_markup "$keyboard_cidades"
}

pdfgrep.reply_itatiba() {
	local message
	message="Agora você deve informar a pesquisa que deseja realizar no edital"
	message="Pesquisa:"
  	ShellBot.sendMessage --chat_id ${callback_query_message_chat_id[$id]} --text "$(echo -e ${message})" \
        --reply_markup "$(ShellBot.ForceReply)"
}

pdfgrep.itatiba() {
	local cidade message pattern _chat_id
	
    pattern=$1	
    cidade="Itatiba"

	if [[ ${callback_query_message_chat_id[$id]} ]]; then
		_chat_id=${callback_query_message_chat_id[$id]}
	else
		_chat_id=${message_chat_id[$id]}
	fi
    
	pasta_pdf="/tmp/$(helper.random)/${cidade}"
	if [[ ! -d "${pasta_pdf}" ]]; then
		mkdir -p ${pasta_pdf}
	fi
	
	if [[ ${pattern} ]]; then
		pdf_save=${pasta_pdf}/${cidade}_$(date +%Y%m%d).pdf
		wget -q --spider ${itatiba_url}
		if [[ "$?" -ne "0" ]]; then
			message="\`AVISO ${cidade} \`- hoje não houve edital no diário oficial!"
			ShellBot.sendMessage --chat_id ${_chat_id} \
								--text "$(echo -e ${message})" --parse_mode markdown
			
		else
			wget -O ${pdf_save} ${itatiba_url}
			chmod 777 ${pdf_save}; /usr/bin/pdfgrep -i "${pattern}" ${pdf_save}
			exc=$(echo $?)
			if [[ "${exc}" -eq "0" ]]; then
				message="\`AVISO ${cidade} \`- Corra ver no site, '${pattern}' foi citado no edital de hoje!!!\n"
				message+="Estou enviando o PDF para você poder confirmar..."
				ShellBot.sendMessage --chat_id ${_chat_id} \
								--text "$(echo -e ${message})" --parse_mode markdown
				ShellBot.sendDocument --chat_id ${_chat_id} \
								--document @${pdf_save}
			else
				message="\`AVISO ${cidade} \`- O padrão '${pattern}' não foi citado no edital de hoje"
				ShellBot.sendMessage --chat_id ${_chat_id} \
								--text "$(echo -e ${message})" --parse_mode markdown
			fi

		fi	
	else
		message="Informe um padrão a ser pesquisado:\n"
		ShellBot.sendMessage --chat_id ${_chat_id} \
							--text "$(echo -e ${message})" --parse_mode markdown
	fi
	rm -vfr ${pasta_pdf}
}
pdfgrep.boituva() {
	local url cidade send_ids
	
	url=$1
	cidade=$2
    send_ids=(${3})
	
	pasta_pdf=${pasta_destino}/${cidade}
    if [[ ! -d "${pasta_pdf}" ]]; then
        mkdir ${pasta_pdf}
    fi
	
	pdf_save=${pasta_pdf}/${cidade}_$(date +%Y%m%d).pdf
        anoMesDia="$(date +%Y-%m-%d)"
        pdfs=($(curl -s ${url} | grep -E -o "${anoMesDia}.*\.pdf" | cut -d'>' -f2))
        if [[ -z ${pdfs[@]} ]]; then
                sendMessageBot "AVISO ${cidade} - hoje não houve registro no diário oficial" "$3"
        else
			for i in $(echo ${pdfs[@]}); do
					
				wget -O ${pdf_save} $i
				chmod 777 ${pdf_save}; /usr/bin/pdfgrep -i "${pattern}" ${pdf_save}
				exc=$(echo $?)
				echo "se igual a zero entao achou  (((( ${exc} ))) "
				if [[ "${exc}" -eq "0" ]]; then
					sendMessageBot "AVISO ${cidade} - Corra ver no site, seu nome foi citado no edital de hoje!!!" "${send_ids[@]}"
					sendMessageBot "estou enviando o PDF para você poder confirmar..." "${send_ids[@]}"
					sendDocumentBot "${pdf_save}" "${send_ids[@]}"
				else
					sendMessageBot "AVISO ${cidade} - Seu nome não foi citado no edital de hoje" "${send_ids[@]}"
					sendMessageBot "estou enviando o PDF para você poder confirmar..." "${send_ids[@]}"
					sendDocumentBot "${pdf_save}" "${send_ids[@]}"
				fi
			done
        fi
        rm -vfr ${pasta_pdf}

}
pdfgrep.jundiai() {
	local cidade send_ids
	
	url=$1
	diaMesAno="$(date +%d-%m-%Y)"
	cidade=$2
    send_ids=(${3})
	
	pasta_pdf=${pasta_destino}/${cidade}
	if [[ ! -d "${pasta_pdf}" ]]; then
		mkdir ${pasta_pdf}
	fi
    
	pdf_save="${pasta_pdf}/${cidade}_$(date +%Y%m%d).pdf"
	counter=($(curl -s ${url} | grep -E "${diaMesAno//-/\/}" | grep -v span | grep -E -o "\ [0-9]{4}\ " | tr -d ' '))
	if [[ -z ${counter[@]} ]]; then
		sendMessageBot "AVISO ${cidade} - hoje não houve registro no diário oficial" "$3"
	else
		echo "counter --- ${counter[@]}"
		for i in $(echo ${counter[@]}); do
			echo "counter i ----- $i"
			jundiai="https://imprensaoficial.jundiai.sp.gov.br/edicao-$i/"
			jundiaiExtra="https://imprensaoficial.jundiai.sp.gov.br/edicao-extra-$i/"

			pdfName=$(curl -s ${jundiai} | grep "${counter[$i]}" | grep -E "\.pdf" | cut -d'"' -f2)
			if [[ -z ${pdfName} ]]; then
					pdfName=$(curl -s ${jundiaiExtra} | grep "$i" | grep -E "\.pdf" | cut -d'"' -f2)
			fi
			echo "procurando pelo edital de Jundiai --- url: ${url}"
			wget -q --spider ${pdfName}
			if [[ "$?" -ne "0" ]]; then
				sendMessageBot "AVISO ${cidade} - hoje não houve registro no diário oficial" "$3"
			else
				wget -O ${pdf_save} ${pdfName}
				chmod 777 ${pdf_save}; /usr/bin/pdfgrep -i "${pattern}" ${pdf_save}
				exc=$(echo $?)
				echo "se igual a zero entao achou  (((( ${exc} ))) "
				if [[ "${exc}" -eq "0" ]]; then
					sendMessageBot "AVISO ${cidade} - Corra ver no site, seu nome foi citado no edital de hoje!!!" "${send_ids[@]}"
					sendMessageBot "estou enviando o PDF para você poder confirmar..." "${send_ids[@]}"
					sendDocumentBot "${pdf_save}" "${send_ids[@]}"
				else
					sendMessageBot "AVISO ${cidade} - Seu nome não foi citado no edital de hoje" "${send_ids[@]}"
					sendMessageBot "estou enviando o PDF para você poder confirmar..." "${send_ids[@]}"
					sendDocumentBot "${pdf_save}" "${send_ids[@]}"
				fi
			fi
		done
    fi
	rm -vfr ${pasta_pdf}

}
pdfgrep.jandira() {
	local cidade send_ids
	
	cidade=$2
	send_ids=(${3})
	
        pasta_pdf=${pasta_destino}/${cidade}
        if [[ ! -d "${pasta_pdf}" ]]; then
                mkdir ${pasta_pdf}
        fi
	pdf_save=${pasta_pdf}/${cidade}_$(date +%Y%m%d).pdf
        jandira_pdfs=($(curl -s ${jandira_url} | grep -E "$(date +%Y-%m-%d)" | grep -E -o "jopej_$(date +%Y)_ed_[0-9]{4}\.pdf" | sort -u))
        if [[ -z ${jandira_pdfs[@]} ]]; then
                sendMessageBot "AVISO ${cidade} - hoje não houve registro no diário oficial" "$3"
        else
                for i in $(echo ${jandira_pdfs[@]}); do
                        wget -O ${pdf_save} $i
			chmod 777 ${pdf_save}; /usr/bin/pdfgrep -i "${pattern}" ${pdf_save}
			exc=$(echo $?)
			if [[ "${exc}" -eq "0" ]]; then
				sendMessageBot "AVISO ${cidade} - Corra ver no site, seu nome foi citado no edital de hoje!!!" "${send_ids[@]}"
				sendMessageBot "estou enviando o PDF para você poder confirmar..." "${send_ids[@]}"
				sendDocumentBot "${pdf_save}" "${send_ids[@]}"
				else
					sendMessageBot "AVISO ${cidade} - Seu nome não foi citado no edital de hoje" "${send_ids[@]}"
					sendMessageBot "estou enviando o PDF para você poder confirmar..." "${send_ids[@]}"
					sendDocumentBot "${pdf_save}" "${send_ids[@]}"
			fi
                done
        fi
        rm -vfr ${pasta_pdf}
}
pdfgrep.barueri() {
        local url cidade send_ids
	
	diaMesAno="$(date +%d-%m-%Y)"
        url=$1
	cidade=$2
	send_ids=(${3})
        
	diaAno="$(date +%d%y)"
        pasta_pdf=${pasta_destino}/${cidade}
        if [[ ! -d "${pasta_pdf}" ]]; then
                mkdir ${pasta_pdf}
        fi
	pdf_save=${pasta_pdf}/${cidade}_$(date +%Y%m%d).pdf
        pdf=($(curl -s ${url} | grep servicos | grep JOB | grep "ACESSAR JORNAL" | cut -d'"' -f4 | head -4))
        flag=0
        for i in $(echo ${pdf[@]}); do
                echo "--------------- $i"
                if [[ "$(echo $i | grep -E -o '[0-9]{2}.*[a-zA-Z][-/_]' | tr -d '_/a-zA-Z' | tr -d '-' | sed 's/^....//' | sed 's/2019/19/' | sed 's/^0*//')" == "$(echo ${diaAno} | sed 's/^0*//')" ]]; then
                        wget -O ${pdf_save} $i
			chmod 777 ${pdf_save}; /usr/bin/pdfgrep -i "${pattern}" ${pdf_save}
			exc=$(echo $?)
			if [[ "${exc}" -eq "0" ]]; then
				sendMessageBot "AVISO ${cidade} - Corra ver no site, seu nome foi citado no edital de hoje!!!" "$3"
				sendMessageBot "estou enviando o PDF para você poder confirmar..." "$3"
				sendDocumentBot "${pdf_save}" "$3"
				else
					sendMessageBot "AVISO ${cidade} - Seu nome não foi citado no edital de hoje" "${send_ids[@]}"
					sendMessageBot "estou enviando o PDF para você poder confirmar..." "${send_ids[@]}"
					sendDocumentBot "${pdf_save}" "${send_ids[@]}"
			fi
                        else
                                flag=$((flag+1))
                fi
        done
        if [[ "${flag}" -eq "4" ]]; then
                sendMessageBot "AVISO ${cidade} - hoje não houve registro no diário oficial" "${send_ids[@]}"
        fi
        rm -vfr ${pasta_pdf}
}
pdfgrep.aracoiaba() {
	local cidade send_ids
	
	cidade=$2
	send_ids=(${3})
        
	pasta_pdf=${pasta_destino}/${cidade}
        if [[ ! -d "${pasta_pdf}" ]]; then
                mkdir ${pasta_pdf}
        fi
	
        diaMesAno="$(date +%d%m%Y)"
        url=$1
	pdf_save=${pasta_pdf}/${cidade}_$(date +%Y%m%d).pdf
        pdf="$(curl -s ${url} | grep -E "EDICAO" | grep -E "${diaMesAno}" | cut -d'"' -f4)"
        if [[ -z ${pdf} ]]; then
                sendMessageBot "AVISO ${cidade} - hoje não houve registro no diário oficial" "$3"
        else
                wget -q --spider ${pdf}
                if [[ "$?" -ne "0" ]]; then
                        sendMessageBot "AVISO ${cidade} - hoje não houve registro no diário oficial" "$3"
                else
                        wget -O ${pdf_save} $i
			chmod 777 ${pdf_save}; /usr/bin/pdfgrep -i "${pattern}" ${pdf_save}
			exc=$(echo $?)
			if [[ "${exc}" -eq "0" ]]; then
				sendMessageBot "AVISO ${cidade} - Corra ver no site, seu nome foi citado no edital de hoje!!!" "${send_ids[@]}"
				sendMessageBot "estou enviando o PDF para você poder confirmar..." "${send_ids[@]}"
				sendDocumentBot "${pdf_save}" "${send_ids[@]}"
				else
					sendMessageBot "AVISO ${cidade} - Seu nome não foi citado no edital de hoje" "${send_ids[@]}"
					sendMessageBot "estou enviando o PDF para você poder confirmar..." "${send_ids[@]}"
					sendDocumentBot "${pdf_save}" "${send_ids[@]}"
			fi
                fi
        fi
        rm -vfr ${pasta_pdf}
}
pdfgrep.fieb() {
	local cidade pasta_pdf url pdf_save diaMesAno new_url send_ids
	
	cidade=$2
	send_ids=(${3})
	
        pasta_pdf=${pasta_destino}/${cidade}
        if [[ ! -d "${pasta_pdf}" ]]; then
                mkdir ${pasta_pdf}
        fi
        url=$1
        pdf_save=${pasta_pdf}/${cidade}_$(date +%Y%m%d).pdf
        diaMesAno="$(date +%d/%m/%Y)"
	
        new_url=($(curl -s ${url} | grep -E -B1 "${diaMesAno}" | grep href | cut -d'"' -f2))
        echo "++++++++++++++++ ${new_url[@]}"
        if [[ -z ${new_url[@]} ]]; then
		sendMessageBot "AVISO ${cidade} - hoje não houve registro no diário oficial" "$3"

        else
                for i in $(echo ${new_url[@]}); do
                        pdf=$(curl -s ${i} | grep -E "$(date +%Y)\/$(date +%m)" | grep -E "\.pdf" | head -1 | grep iframe | cut -d'"' -f2)
			
                        wget -O ${pdf_save} ${pdf}
			chmod 777 ${pdf_save}; /usr/bin/pdfgrep -i "${pattern}" ${pdf_save}
			exc=$(echo $?)
			if [[ "${exc}" -eq "0" ]]; then
				sendMessageBot "AVISO ${cidade} - Corra ver no site, seu nome foi citado no edital de hoje!!!" "$3"
				sendMessageBot "estou enviando o PDF para você poder confirmar..." "${send_ids[@]}"
				sendDocumentBot "${pdf_save}" "${send_ids[@]}"
				else
					sendMessageBot "AVISO ${cidade} - Seu nome não foi citado no edital de hoje" "${send_ids[@]}"
					sendMessageBot "estou enviando o PDF para você poder confirmar..." "${send_ids[@]}"
					sendDocumentBot "${pdf_save}" "${send_ids[@]}"
			fi
                done
        fi
        rm -vfr ${pasta_pdf}
}
pdfgrep.campinas() {
	local url cidade send_ids pdf_save extra_date extra_pdf
	
	url=$1
	cidade=$2
	send_ids=(${3})
	extra_date=$(date +%Y-%m-%d)
	extra_pdf="${url}arquivos/dom-extra/dom-extra-${extra_date}.pdf"
	
	pasta_pdf=${pasta_destino}/${cidade}
        if [[ ! -d "${pasta_pdf}" ]]; then
                mkdir ${pasta_pdf}
        fi
	
	pdf_save=${pasta_pdf}/${cidade}_$(date +%Y%m%d).pdf
	extra_pdf_save=${pasta_pdf}/EXTRA_${cidade}_$(date +%Y%m%d).pdf
	
	#Primeira verificação para saber se houve edital extra do dia
	wget -O ${extra_pdf_save} ${url_final}
	exc=$(echo $?)
	if [[ "${exc}" -eq "0" ]]; then
		chmod 777 ${extra_pdf_save}; /usr/bin/pdfgrep -i "${pattern}" ${extra_pdf_save}
		exc=$(echo $?)
		if [[ "${exc}" -eq "0" ]]; then
			sendMessageBot "AVISO ${cidade} - Corra ver no site, seu nome foi citado no edital de hoje!!!" "$3 449542698"
			sendMessageBot "estou enviando o PDF para você poder confirmar..." "${send_ids[@]}"
			sendDocumentBot "${extra_pdf_save}" "${send_ids[@]}"
			sendMessageBot "RUN Forest, RUN!!!" "${send_ids[@]}"
			else
				sendMessageBot "AVISO ${cidade} - Seu nome não foi citado no edital extra de hoje" "${send_ids[@]}"
				sendMessageBot "estou enviando o PDF para você poder confirmar..." "${send_ids[@]}"
				sendDocumentBot "${extra_pdf_save}" "${send_ids[@]}"
		fi
	else
		sendMessageBot "Não houve edital EXTRA de ${cidade} hoje" "${send_ids[@]}"
	fi
	
	#Segunda verificação se houve edital normal no dia
	pdf_day=$(curl -sS ${url} | grep -E -o "uploads/pdf/[0-9].*.pdf")
	if [[ ${pdf_day} ]]; then
		url_final="${url}${pdf_day}"
		wget -O ${pdf_save} ${url_final}
		chmod 777 ${pdf_save}; /usr/bin/pdfgrep -i "${pattern}" ${pdf_save}
		exc=$(echo $?)
		if [[ "${exc}" -eq "0" ]]; then
			sendMessageBot "AVISO ${cidade} - Corra ver no site, seu nome foi citado no edital de hoje!!!" "$3"
			sendMessageBot "estou enviando o PDF para você poder confirmar..." "$3"
			sendDocumentBot "${pdf_save}" "$3"
			sendMessageBot "RUN Forest, RUN..." "$3"
			else
				sendMessageBot "AVISO ${cidade} - Seu nome não foi citado no edital de hoje" "$3"
				sendMessageBot "estou enviando o PDF para você poder confirmar..." "$3"
				sendDocumentBot "${pdf_save}" "$3"
		fi
	fi

}

pdfgrep.cerquilho() {
	local cidade url_base check_not_found send_ids
	
	url_base=$1
	cidade=$2
	send_ids=(${3})
	check_not_found=false
	
	for i in $(seq 74 99); do
		url="${url_base}${i}/"
		pdf_file="/tmp/$(cat /dev/urandom | tr -cd 'a-f0-9' | head -c 16).pdf"
		
		wget --quiet -O ${pdf_file} ${url}
		chmod 777 ${pdf_file}
		/usr/bin/pdfgrep -i "${pattern}" ${pdf_file}
		if [[ "$?" -eq "0" ]]; then	
			sendMessageBot "AVISO ${cidade} - Corra ver no site, seu nome foi citado no edital de hoje!!!" "$3"
			sendMessageBot "estou enviando o PDF para você poder confirmar..." "${send_ids[@]}"
			sendDocumentBot "${pdf_file}" "${send_ids[@]}"
			check_not_found=false
			break
		else
			check_not_found=true
		fi
		
		pdf_file=''
		url=''
	
	done
	if [[ "${check_not_found}" == "true" ]]; then
		sendMessageBot "AVISO ${cidade} - Hoje não houve edital de Nomeação" "${send_ids[@]}"
	fi
}

#!/bin/bash

source ${BASEDIR}/.definitions.sh

validateVars() {
	vars_list=($@)
	for v in $(echo ${vars_list[@]}); do
		export | grep ${v} > /dev/null
		result=$?
		if [[ ${result} -ne 0 ]]; then
			echo "Dependency of ${v} is missing"
			echo "Exiting..."
			exit -1
		fi
	done
}

validateVars TELEGRAM_TOKEN

#!/bin/bash

export.ids() {
        local ids_file=$1

        if [[ -f ${ids_file} ]]; then
                export NOTIFICATION_IDS=($(cat ${ids_file}))
        else
                echo "Id file not found"
                exit -1
fi
}

validate.vars() {
        local vars_list=($@)
        
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


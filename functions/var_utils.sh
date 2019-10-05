#!/bin/bash

export.ids() {
        local ids_file
        ids_file=$1
        export NOTIFICATION_IDS=($(cat ${ids_file}))
}

validate.vars() {
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


#!/bin/bash
#

random.helper() {
	local file
	file=$1
	amount=$(cat ${file} | wc -l)
	r_amount=$(shuf -i 1-${amount} -n 1)
	echo "${r_amount}"
}

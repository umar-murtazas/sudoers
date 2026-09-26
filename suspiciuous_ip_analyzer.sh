#!/bin/bash

printf " ================= IP Analyzer ==================== \n"

read -p "enter the file u want to read : " usr_file		#1
printf "[+] log file : "$usr_file" \n"

if [ -z "$usr_file" ]; then
	echo "file is empty"
else
#	cat "$usr_file" | cut -d' ' -f1 | tr '\n' ' '		#3 replace \n with space

	read -a data <<< $(cat "$usr_file" | cut -d' ' -f1 | tr '\n' ' ')		#2 read -a only takes stdin so to force the stdout inside the read we used <<< (here string) that takes ur data and feeds it inside tehe stdin
	echo "[+] IPs discovered : ${data}"

#	echo $(("${#data[@]}" +1 ))		#4 write +1 inside both brackets not after one $(( ... ) +1 )
fi

#total length
echo "[+] total requests : ${#data[@]}"

#detect duplicates
for (( i=0; i<${#data[@]}; i++ ))
do
	max_count=0
	for (( j=i+1; j<${#data[@]}; j++ ))   	#5 use i+1 else u will get duplicate results
	do
		if [ "$i" -eq "$j" ]; then
			continue
		elif [ "${data[i]}" == "${data[j]}" ]; then
			duplicate="${data[j]}"
			echo "duplicate ip found : "$duplicate" at indices : "$i" and "$j" "
			((duplicate_count++))
		fi
	done
	most_frequent=""
	if [ "$duplicate_count" -gt "$max_count" ]; then
		max_count=$duplicate_count
		most_frequent="${data[i]}"
	fi
done

echo " [!] most frequent IP : "$most_frequent"		-> "$max_count" "
echo "duplication frequency : "$duplicate_count""






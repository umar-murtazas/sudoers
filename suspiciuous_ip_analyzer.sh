#!/bin/bash

# -------------------------------------------- things used ------------------------------------------- #
## 1) "tr '\n' ' '" replace newlines with space.
## 2) "<<<" feeds stdout to things that expect stdin. e.g -> "grep hell0 <<< "hello world" oR echo "hello world" | grep "hello" is the same. "
## 3) "(( ))" arthematic evalution diff from "$(( ))", evalutation only evalutes the answer, doesnt return anything other then boolean asnwers and thats why are mostly used inside if loop conditions,
# we also dont need any referencing inside of it. we can normally write : "(( i = i + 1 ))"
## 4) here only the middle consitions produces True/False that runs the loop.
# ------------------------------------------- problems ---------------------------------------------- #
## i) when reading inside an array use the -a after the prompt.
## ii) read expects stdin while $() produces stdout so for this use <<< that stdin your stdout into the cmd.
## iii) in arthematic expansions dont write values after one brackets write it inside both "$(( ... ))"

printf " ================= IP Analyzer ==================== \n"

read -p "enter the file u want to read : " usr_file	#i	#1
printf "[+] log file : "$usr_file" \n"

if [ -z "$usr_file" ]; then
	echo "file is empty"
else
#	cat "$usr_file" | cut -d' ' -f1 | tr '\n' ' '

	read -a data <<< $(cat "$usr_file" | cut -d' ' -f1 | tr '\n' ' ')	#ii	#2
	echo "[+] IPs discovered : ${data}"

#	echo $(("${#data[@]}" +1 ))		#iii
fi

#total length
echo "[+] total requests : ${#data[@]}"

#detect duplicates
for (( i=0; i<${#data[@]}; i++ ))	#4
do
	max_count=0
	for (( j=i+1; j<${#data[@]}; j++ ))   	#3
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

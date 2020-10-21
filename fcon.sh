#!/bin/bash

if [[ $1 == '' ]]; then
	echo "missing domain"
	exit 1
fi

domain=$1
curr_dir=$(pwd)
output_path=$curr_dir/output/$domain
data_path=$curr_dir/data
tool_path=$curr_dir/tools
if [ -d "$output_path" ]; then
	echo "known target"
else
	mkdir -p "$output_path"
fi	

printf "Gathering IP Range.\\n"
echo "$domain" | cut -d "." -f 1 | metabigor net --org -o "$output_path"/ipranges

printf "Running amass.\\n"
amass enum --passive -d "$domain" -o "$output_path"/amass_subs &>/dev/null

printf "Running subfinder.\\n"
subfinder -d "$domain" -t 20 -o "$output_path"/subfinder_subs

printf "Running gobuster.\\n"
#gobuster dns --wildcard -q -t 100 -d "$domain" -w "$data_path"/commonspeak2.txt -o "$output_path"/go_subs		
#cat "$output_path"/go_subs | cut -d ' ' -f 2 >> "$output_path"/subdomains
#rm "$output_path"/go_subs

cat "$output_path"/amass_subs >> "$output_path"/subdomains
cat "$output_path"/subfinder_subs >> "$output_path"/subdomains
#rm "$output_path"/amass_subs
#rm "$output_path"/subfinder_subs


sort "$output_path"/subdomains | uniq > "$output_path"/final_subdomains

printf "Running httpx: .\\n"
cat "$output_path"/final_subdomains | httpx -silent -o "$output_path"/active_subdomains

printf "Subdomain Portscanning.\\n"
naabu -iL "$output_path"/active_subdomains -o "$output_path"/subdomain_ports

printf "IP Portscanning.\\n"
naabu -iL "$output_path"/ipranges -o "$output_path"/ipranges_ports

printf "Screenshoting Active Subdomains: .\\n"
cat "$output_path"/active_subdomains | aquatone -out "$output_path"/aquatone/.

printf "Directory Bruteforcing: .\\n"
python3 "$tool_path"/dirsearch/dirsearch.py -l "$output_path"/active_subdomains -t 100 -e txt,html,php --simple-report="$output_path"/dirserach_output

printf "done.\\n"
date

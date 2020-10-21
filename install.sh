#!/bin/bash

curr_dir=$(pwd)
data_path=$curr_dir/data
tool_path=$curr_dir/tools

mkdir -p $data_path 2>/dev/null
mkdir -p $tool_path 2>/dev/null

echo -e "\033[1;32m[+] Installing metabigor \033[1;37m"
go get -u github.com/j3ssie/metabigor

echo -e "\033[1;32m[+] Installing amass \033[1;37m"
sudo snap install amass

echo -e "\033[1;32m[+] Installing subfinder \033[1;37m"
GO111MODULE=on go get -u  github.com/projectdiscovery/subfinder/v2/cmd/subfinder

echo -e "\033[1;32m[+] Installing gobuster \033[1;37m"
go get -u github.com/OJ/gobuster

echo -e "\033[1;32m[+] Installing httpx \033[1;37m"
GO111MODULE=auto go get -u  github.com/projectdiscovery/httpx/cmd/httpx

echo -e "\033[1;32m[+] Installing naabu \033[1;37m"
GO111MODULE=on go get -u  github.com/projectdiscovery/naabu/v2/cmd/naabu

echo -e "\033[1;32m[+] Installing chromium \033[1;37m"
sudo apt-get install chromium -y

echo -e "\033[1;32m[+] Installing aquatone \033[1;37m"
go get -u github.com/michenriksen/aquatone

echo -e "\033[1;32m[+] Installing dirsearch \033[1;37m"
cd $tool_path
git clone https://github.com/maurosoria/dirsearch.git
cd $curr_dir

echo -e "\033[1;32m[+] Downloading commonspeak wordlist \033[1;37m"
wget -q -O $data_path/commonspeak2.txt https://raw.githubusercontent.com/assetnote/commonspeak2-wordlists/master/subdomains/subdomains.txt
cd $curr_dir

#!/bin/env bash
black="\e[30m"
red="\033[31m"
green="\033[32m"
yellow="\033[33m"
blue="\033[34m"
purple="\033[35m"
cyan="\033[36m"
white="\033[37m"
background="\033[0m"
AFHOME="$(cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd)"
OldHOME=$(grep AFHOME ${AFHOME}/Manage/config)
sed -i "s|${OldHOME}|AFHOME=$AFHOME|g" ${AFHOME}/Manage/config
echo -e ${blue}[${green}*${blue}] AFMCSS根目录已更改为 ${yellow}$AFHOME${background}
Command="bash ${AFHOME}/Manage/Main.sh $AFHOME"
if [ -e /usr/local/bin/afmc ];then
  rm /usr/local/bin/afmc
fi
touch /usr/local/bin/afmc
echo ${Command} > /usr/local/bin/afmc
chmod +x /usr/local/bin/afmc



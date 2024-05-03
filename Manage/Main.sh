#!/bin/env bash
AFHOME=$1
source $AFHOME/Manage/config

ManageServerMenu(){
ServerCore="$1"
ServerName="$2"
cd $AFHOME/Server/${ServerName}
bash $AFHOME/Manage/${ServerCore}/manage $AFHOME ${ServerName}
}
UpdateServerMenu(){
ServerCore="$1"
ServerName="$2"
cd $AFHOME/Server/${ServerName}
bash $AFHOME/Manage/${ServerCore}/update $AFHOME ${ServerName}
}
JREInstall(){
cd $AFHOME/Server/
bash $AFHOME/Manage/JREInstall
}

Menu(){
ManageServer(){
ServerName=
if ls $AFHOME/Server/* > /dev/null 2>&1
then
  i=0
  for MinecraftServer in $(ls $AFHOME/Server)
  do
    ((i++))
    ServerName="${ServerName} ${i} ${MinecraftServer}"
  done
else
  ScreenSizeMsgbox
  whiptail --title "AFMCSS" \
  --msgbox "未创建服务器" ${HEIGHT} ${WIDTH}
  return
fi
ScreenSizeMenu
Number=$(whiptail \
--title "AFMCSS" \
--menu "您想要管理哪个服务器？" \
${HEIGHT} ${WIDTH} ${OPTION} \
${ServerName} \
3>&1 1>&2 2>&3)
feedback=$?
if [ ${feedback} == 1 ]
then
  return
fi
ServerName=$(ls -1 $AFHOME/Server | sed -n "${Number}p")
if [[ ${ServerName} == "BDS"* ]]
then
  ManageServerMenu BDS ${ServerName}
elif [[ ${ServerName} == "Java"* ]]
then
  ManageServerMenu BDS ${ServerName}
elif [[ ${ServerName} == "Spigot"* ]]
then
  ManageServerMenu Spigot ${ServerName}
elif [[ ${ServerName} == "Paper"* ]]
then
  ManageServerMenu Paper ${ServerName}
elif [[ ${ServerName} == "Purpur"* ]]
then
  ManageServerMenu Purpur ${ServerName}
else
  whiptail --title "AFMCSS" \
  --msgbox "[错误] 服务器名称不规范" ${HEIGHT} ${WIDTH}
  return
fi
cd $AFHOME
}

CreateServer(){
ServerName=
# https://zh.minecraft.wiki/w/定制服务器
if [ -d $AFHOME/Server ];then
  MinecraftServer=$(ls $AFHOME/Server)
fi
ScreenSizeMenu
# https://minecraft.wiki/w/Bedrock_Dedicated_Server
# https://mcversions.net/
# https://getbukkit.org/download/spigot
# https://spongepowered.org/downloads/
# https://papermc.io/downloads/paper
# https://purpurmc.org/
# https://files.minecraftforge.net/net/minecraftforge/forge
# "4" "🍄 Minecraft-Sponge" \
# "7" "🍃 Minecraft-Forge" \
# "2" "🌸 Minecraft-Java" \
# "3" "🍁 Minecraft-Spigot" \
# "4" "🌼 Minecraft-Paper" \
# "5" "🌷 Minecraft-Purpur" \

Number=$(whiptail \
--title "创建服务器" \
--menu "您想要选择哪个服务器核心？" \
${HEIGHT} ${WIDTH} ${OPTION} \
"1" "🍀 Minecraft-BDS" \
"0" "🍥 返回脚本主菜单" \
3>&1 1>&2 2>&3)
feedback=$?
if [ ${feedback} == 1 ]
then
  return
fi
case ${Number} in
  1)
    ServerCore="BDS"
    ;;
  2)
    ServerCore="Java"
    ;;
  # 3)
    # ServerCore="Sponge"
    # ScreenSizeMsgbox
    # if $(whiptail --title "MCServer-Spigot" \
    # --yes-button "SpongeVanilla" \
    # --no-button "SpongeForge" \
    # --yesno "请选择您的Spigot类型" \
    # ${HEIGHT} ${WIDTH})
    # then
      # SpongeCore="SpongeVanilla"
    # else
      # SpongeCore="SpongeForge"
    # fi
    # ;;
  3)
    ServerCore="Spigot"
    ;;
  4)
    ServerCore="Paper"
    ;;
  5)
    ServerCore="Purpur"
    ;;
  # 6)
  #   ServerCore="Forge"
  #   ;;
  0)
    return
    ;;
esac
ScreenSizeMsgbox
if ! ServerName=$(whiptail --title "创建服务器"  \
--yes-button "确认" \
--no-button "返回" \
--inputbox "请输入您的服务器名称: " ${HEIGHT} ${WIDTH} \
3>&1 1>&2 2>&3)
then
  return
fi
ServerName=$(echo ${ServerName} | sed 's/ //g')
if [ -d $AFHOME/Server/${ServerCore}-${ServerName} ]
then
  whiptail --title "AFMCSS" \
  --msgbox "${ServerCore}-${ServerName} [已存在]" ${HEIGHT} ${WIDTH}
  return
fi
mkdir -p $AFHOME/Server/${ServerCore}-${ServerName}
cd $AFHOME/Server/${ServerCore}-${ServerName}
if bash $AFHOME/Manage/${ServerCore}/install $AFHOME
then
  ServerName="${ServerCore}-${ServerName}"
  bash $AFHOME/Manage/${ServerCore}/manage $AFHOME ${ServerName}
else
  exit
fi
return
}

UninstallServer(){
ServerName=
if ls $AFHOME/Server/* > /dev/null 2>&1
then
  i=0
  for MinecraftServer in $(ls $AFHOME/Server)
  do
    ((i++))
    local ServerName="${ServerName} ${i} ${MinecraftServer}"
  done
else
  ScreenSizeMsgbox
  whiptail --title "AFMCSS" \
  --msgbox "未创建服务器" ${HEIGHT} ${WIDTH}
  return
fi
ScreenSizeMenu
Number=$(whiptail \
--title "AFMCSS" \
--menu "您想要卸载哪个服务器？" \
${HEIGHT} ${WIDTH} ${OPTION} \
${ServerName} \
3>&1 1>&2 2>&3)
feedback=$?
if [ ${feedback} == 1 ]
then
  return
fi
ServerName=$(ls -1 $AFHOME/Server | sed -n "${Number}p")
if (whiptail --title "卸载服务器"  \
--yes-button "确认" \
--no-button "返回" \
--yesno "是否确认删除${ServerName}" ${HEIGHT} ${WIDTH})
then
  echo -e ${blue}[${red}*${blue}] ${cyan}将要删除${cyan}${ServerName}${yellow}3${background}
  echo -e ${blue}[${red}*${blue}] ${cyan}倒数 ${yellow}3${background}
  sleep 1s
  echo -e ${blue}[${red}*${blue}] ${cyan}倒数 ${yellow}2${background}
  sleep 1s
  echo -e ${blue}[${red}*${blue}] ${cyan}倒数 ${yellow}1${background}
  sleep 1s
  rm -rf $AFHOME/Server/${ServerName} > /dev/null 2>&1
  rm -rf $AFHOME/Server/${ServerName} > /dev/null 2>&1
  ScreenSizeMsgbox
  whiptail --title "AFMCSS" \
  --msgbox "卸载完成" \
  ${HEIGHT} ${WIDTH}
else
  return
fi
}

OtherFeatures(){
Number=$(whiptail \
--title "AFMCSS" \
--menu "请选择操作" \
${HEIGHT} ${WIDTH} ${OPTION} \
"1" " 内网穿透" \
"2" " WebDAV" \
"0" "🍧 返回主菜单" \
3>&1 1>&2 2>&3)

case ${Number} in
1)
  bash $AFHOME/Manage/FRP/FRP $AFHOME
  ;;
2)
  bash $AFHOME/Manage/WebDAV/WebDAV $AFHOME
  ;;
0)
  return
  ;;
esac
}

ScreenSizeMenu
Number=$(whiptail \
--title "AFMCSS" \
--menu "请选择操作" \
${HEIGHT} ${WIDTH} ${OPTION} \
"1" "🍫 创建服务器" \
"2" "🍬 管理服务器" \
"3" "🍪 卸载服务器" \
"4" "🍮 其他--功能" \
"0" "🍧 退出--脚本" \
3>&1 1>&2 2>&3)
feedback=$?
if [ ${feedback} == 1 ]
then
  exit
fi
case ${Number} in
  1)
    CreateServer
    ;;
  2)
    ManageServer
    ;;
  3)
    UninstallServer
    ;;
  4)
    OtherFeatures
    ;;
  0)
    exit 0
    ;;
esac
}

function LoopMenu(){
while true
do
    Menu
    LoopMenu
done
}
LoopMenu
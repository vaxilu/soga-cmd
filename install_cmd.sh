#!/bin/bash

red='\033[0;31m'
green='\033[0;32m'
yellow='\033[0;33m'
plain='\033[0m'

# check root
[[ $EUID -ne 0 ]] && echo -e "${red}错误：${plain} 必须使用root用户运行此脚本！\n" && exit 1

arch=$(arch)

if [[ $arch == "x86_64" || $arch == "x64" || $arch == "amd64" ]]; then
    arch="amd64"
elif [[ $arch == "aarch64" || $arch == "arm64" ]]; then
    arch="arm64"
else
    arch="amd64"
    echo -e "${red}检测架构失败，使用默认架构: ${arch}${plain}"
fi

echo "架构: ${arch}"

if [ "$(getconf WORD_BIT)" != '32' ] && [ "$(getconf LONG_BIT)" != '64' ] ; then
    echo "本软件不支持 32 位系统(x86)，请使用 64 位系统(x86_64)，如果检测有误，请联系作者"
    exit 2
fi

echo -e "${green}开始下载 soga-cmd 最新版${plain}"

if [ $# == 0 ] ;then
    wget -N --no-check-certificate -O /usr/bin/soga https://github.com/vaxilu/soga-cmd/releases/latest/download/soga-cmd-linux-${arch}
    if [[ $? -ne 0 ]]; then
        echo -e "${red}下载 soga-cmd 失败，请确保你的服务器能够下载 Github 的文件${plain}"
        exit 1
    fi
else
    last_version=$1
    url="https://github.com/vaxilu/soga-cmd/releases/download/${last_version}/soga-cmd-linux-${arch}"
    echo -e "开始下载 soga-cmd $1"
    wget -N --no-check-certificate -O /usr/bin/soga ${url}
    if [[ $? -ne 0 ]]; then
        echo -e "${red}下载 soga-cmd $1 失败，请确保此版本存在${plain}"
        exit 1
    fi
fi

chmod +x /usr/bin/soga

last_version="$(/usr/bin/soga -v 2>/dev/null || echo "unknown")"
echo -e "${green}soga-cmd v${last_version}${plain} 安装完成"

echo -e ""
echo "执行 soga 命令："
echo "------------------------------------------"
/usr/bin/soga

#!/usr/bin/env bash

# 判断supervisor是否安装

search_res=`systemctl status supervisord 2>&1|grep 'could not be found'`
need_to_install=${#search_res}

set -e # grep没搜索到会返回1，会被认为脚本出错，所以set -e不能在grep之前

# -z True if zero length
# -n True if the length of $var is non-zero
if [[ ${need_to_install} != 0  ]]; then
    echo 'start to install supervisor...'
    yum install -y supervisor
    systemctl enable supervisord
else
    echo 'supervisor has been installed'
    exit 0
fi


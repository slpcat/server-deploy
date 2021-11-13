#!/usr/bin/env bash

yum install python3 -y
yum install python3-pip.noarch -y
mkdir -p ~/.pip
tee ~/.pip/pip.conf <<-'EOF'
[global]
index-url = https://pypi.tuna.tsinghua.edu.cn/simple
EOF

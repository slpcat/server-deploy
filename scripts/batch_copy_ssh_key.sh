#!/usr/bin/env bash

if [[ $# != 2 ]]; then
    echo 'please input remote user and remote host'
    exit 1
fi

remote_user=$1
remote_host=$2

ssh-copy-id -i ~/.ssh/id_rsa.pub ${remote_user}@${remote_host}

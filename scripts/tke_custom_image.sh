#!/bin/bash

set -e

script_name=`basename "${BASH_SOURCE}"`
_action=

for options
do
  case $options in
    --help)
      init_help=xxx;;
    *)
      if [[ "$_action" = "" ]];then
        _action=$options
      else
        init_help="only accepts one action!"
      fi
      ;;
  esac
done

g_action=$_action

#check action
case $g_action in
  clean)
  ;;
  "")
  init_help="xxx";;
  *)
  init_help="unsupported action [$_action]"
esac

#show help
if test "$init_help" != ""; then

  if [[ $init_help != "xxx" ]];then
    error_tips="error: $init_help"
  fi

  if [[ $error_tips != "" ]];then
    echo "$error_tips"
  fi

  cat << EOF
usage: $script_name action

action:
  clean   clean cloud-init in vm of creating custom image
EOF
  exit 0
fi

# check os type
check_os_type()
{
  # ostype: tlinux|opensuse|suse|centos|redhat|ubuntu|debian
    if [ -f /etc/tlinux-release ];then
        echo "tlinux"
        return
    fi

    if [ -f /etc/SuSE-release ];then
        grep -i "opensuse" /etc/SuSE-release &>/dev/null && echo "opensuse" || echo "suse"
        return
    fi

    if [ -f /etc/centos-release ];then
        echo "centos"
        return
    fi
    #centos5 and redhat5
    if [ -f /etc/redhat-release ];then
        grep -i "Red Hat" /etc/redhat-release &>/dev/null
        if [ $? -eq 0 ];then
            echo "redhat"
            return
        fi
        grep -i "CentOS" /etc/redhat-release &>/dev/null
        if [ $? -eq 0 ];then
            echo "centos"
            return
        fi
    fi

  for os in ubuntu debian coreos;do grep -i "^ID=${os}$" /etc/os-release >/dev/null 2>/dev/null && echo "${os}" && return; done
  grep -i =ubuntu /etc/lsb-release >/dev/null 2>/dev/null && echo "ubuntu" && return
  [ -f /etc/freebsd-update.conf ] && echo "FreeBSD"
}

centos_cloud_init_clean()
{
    rm -rf /var/lib/cloud
}

tlinux_cloud_init_clean()
{
    centos_cloud_init_clean
}

ubuntu_cloud_init_clean()
{
    rm -rf /var/lib/cloud
    rm -rf /etc/network/interfaces.d/50-cloud-init.cfg

    cat > /etc/network/interfaces <<EOF
# This file describes the network interfaces available on your system
# and how to activate them. For more information, see interfaces(5).

source /etc/network/interfaces.d/*
EOF
}

opensuse_cloud_init_clean()
{
    centos_cloud_init_clean
}

coreos_cloud_init_clean()
{
    centos_cloud_init_clean
}

# do clean
do_clean()
{
  ostype=`check_os_type`
  echo "current os type is $ostype, cleaning..."
  case $ostype in
    "centos")
        centos_cloud_init_clean
        return
        ;;
    "tlinux")
        tlinux_cloud_init_clean
        ;;
    "ubuntu")
        ubuntu_cloud_init_clean
        return
        ;;
    "debian")

        return
        ;;
    "opensuse")
        opensuse_cloud_init_clean
        return
        ;;
    "suse")
        opensuse_cloud_init_clean
        return
        ;;
    "coreos")
        coreos_cloud_init_clean
        return
        ;;
    *)
        echo "$ostype is not supported by clean script"
        exit
        ;;
  esac
}

case $g_action in
  clean)
    do_clean
    ;;
  *)
  ;;
esac
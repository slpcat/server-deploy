#!/bin/bash

#install ecs multiqueue------------------

base_dir=$(dirname $(readlink -f $0))

map=(
aliyun:2:systemd
centos:6:sysvinit
centos:7:systemd
centos:8:systemd
ubuntu:14:update-rc.d
ubuntu:16:systemd
ubuntu:18:systemd
opensuse:1302:systemd
opensuse:4203:systemd
opensuse:15:usr-systemd
sles:12:usr-systemd
sles:15:usr-systemd
debian:8:systemd
debian:9:systemd
debian:10:systemd
)

#enable
if [ "$1" == "debian" ];then
    apt-get update
    apt-get install -y ethtool
    #apt-get install -y irqbalance
elif [ "$1" == "ubuntu" ];then
    apt-get update
    apt-get install -y ethtool
elif [ "$1" == "opensuse" ];then
    zypper install -y irqbalance
elif [ "$1" == "centos" -a "$2" == "6" ];then
    yum install -y irqbalance
fi

#cp ecs_mq_rps_rfs file

cp -f $base_dir/src/ecs_mq_rps_rfs.sh /sbin/ecs_mq_rps_rfs
chmod +x /sbin/ecs_mq_rps_rfs
cp -f $base_dir/src/62-ecs-mq.rules /lib/udev/rules.d/62-ecs-mq.rules



#service startup-----------
for i in ${map[@]}; do 
    if echo $i | grep -E -q "$1:$2:" ; then
        init=$(echo $i | awk -F':' '{print $3}')
    fi
done

if [ $init == "systemd" ]; then
	#enable the following for **centos7u**
	#install the file: /lib/systemd/system/ecs_mq.service
	cp -f $base_dir/boot/ecs_mq.service /lib/systemd/system/ecs_mq.service
	systemctl enable ecs_mq.service
	systemctl list-unit-files | grep ecs
elif [ $init == "usr-systemd" ]; then
        cp -f $base_dir/boot/ecs_mq.service /usr/lib/systemd/system/ecs_mq.service
        systemctl enable ecs_mq.service
        systemctl list-unit-files | grep ecs
elif [ $init == "update-rc.d" ]; then
        cp -f $base_dir/boot/ecs_mq-service /etc/init.d/ecs_mq-service
        chmod +x /etc/init.d/ecs_mq-service

        update-rc.d ecs_mq-service defaults
else
	#enable the following for **centos6u**
	#install the file: /etc/rc.d/init.d/ecs_mq-service
	cp -f $base_dir/boot/ecs_mq-service /etc/rc.d/init.d/ecs_mq-service
	chmod +x /etc/rc.d/init.d/ecs_mq-service

	chkconfig --add ecs_mq-service
	chkconfig ecs_mq-service on
fi

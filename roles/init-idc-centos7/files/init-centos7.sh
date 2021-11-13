#!/bin/bash
#初始化脚本

#修改hostname,bash提示符
# hostname=$1
# if [ -z $hostname ] ; then
#         echo "please input hostname param!"
#         echo "userage example: ./init.sh centos-33"
#         exit
# fi

# echo "Press Enter to continue....."
# read buf

# ipaddr=$(/sbin/ifconfig eth1 2>/dev/null| grep "inet addr"| awk -F: '{print $2}'|awk '{print $1}')
# if [ "$ipaddr" == "" ];then
#    ipaddr=$(/sbin/ifconfig eth0| grep "inet addr"| awk -F: '{print $2}'|awk '{print $1}' 2>/dev/null)
# fi
# echo  $ipaddr       $hostname >>/etc/hosts
#修改hostname
# cp /etc/sysconfig/network /etc/sysconfig/network_ori_bak
# sed -i "s/HOSTNAME=.*/HOSTNAME=$hostname/" /etc/sysconfig/network
# hostname $hostname

#关闭selinux
sed -i '/^SELINUX/s/enforcing/disabled/' /etc/selinux/config
sed -i '/^SELINUX/s/permissive/disabled/' /etc/selinux/config
setenforce 0

#修改/etc/security/limits.conf，完成系统性能优化的一些设置
if [ ! -f /etc/security/limits_conf_ori_bak ]; then
    cp /etc/security/limits.conf /etc/security/limits_conf_ori_bak
fi
echo "# /etc/security/limits.conf" > /etc/security/limits.conf
echo "#">>/etc/security/limits.conf
echo "#This file sets the resource limits for the users logged in via PAM.">>/etc/security/limits.conf
echo "#It does not affect resource limits of the system services.">>/etc/security/limits.conf
echo "#">>/etc/security/limits.conf
echo "#Also note that configuration files in /etc/security/limits.d directory,">>/etc/security/limits.conf
echo "#which are read in alphabetical order, override the settings in this">>/etc/security/limits.conf
echo "#file in case the domain is the same or more specific.">>/etc/security/limits.conf
echo "#That means for example that setting a limit for wildcard domain here">>/etc/security/limits.conf
echo "#can be overriden with a wildcard setting in a config file in the">>/etc/security/limits.conf
echo "#subdirectory, but a user specific setting here can be overriden only">>/etc/security/limits.conf
echo "#with a user specific setting in the subdirectory.">>/etc/security/limits.conf
echo "#">>/etc/security/limits.conf
echo "#Each line describes a limit for a user in the form:">>/etc/security/limits.conf
echo "#">>/etc/security/limits.conf
echo "#<domain>        <type>  <item>  <value>">>/etc/security/limits.conf
echo "#">>/etc/security/limits.conf
echo "#Where:">>/etc/security/limits.conf
echo "#<domain> can be:">>/etc/security/limits.conf
echo "#        - a user name">>/etc/security/limits.conf
echo "#        - a group name, with @group syntax">>/etc/security/limits.conf
echo "#        - the wildcard *, for default entry">>/etc/security/limits.conf
echo "#        - the wildcard %, can be also used with %group syntax,">>/etc/security/limits.conf
echo "#                 for maxlogin limit">>/etc/security/limits.conf
echo "#">>/etc/security/limits.conf
echo "#<type> can have the two values:">>/etc/security/limits.conf
echo "#        - \"soft\" for enforcing the soft limits">>/etc/security/limits.conf
echo "#        - \"hard\" for enforcing hard limits">>/etc/security/limits.conf
echo "#">>/etc/security/limits.conf
echo "#<item> can be one of the following:">>/etc/security/limits.conf
echo "#        - core - limits the core file size (KB)">>/etc/security/limits.conf
echo "#        - data - max data size (KB)">>/etc/security/limits.conf
echo "#        - fsize - maximum filesize (KB)">>/etc/security/limits.conf
echo "#        - memlock - max locked-in-memory address space (KB)">>/etc/security/limits.conf
echo "#        - nofile - max number of open file descriptors">>/etc/security/limits.conf
echo "#        - rss - max resident set size (KB)">>/etc/security/limits.conf
echo "#        - stack - max stack size (KB)">>/etc/security/limits.conf
echo "#        - cpu - max CPU time (MIN)">>/etc/security/limits.conf
echo "#        - nproc - max number of processes">>/etc/security/limits.conf
echo "#        - as - address space limit (KB)">>/etc/security/limits.conf
echo "#        - maxlogins - max number of logins for this user">>/etc/security/limits.conf
echo "#        - maxsyslogins - max number of logins on the system">>/etc/security/limits.conf
echo "#        - priority - the priority to run user process with">>/etc/security/limits.conf
echo "#        - locks - max number of file locks the user can hold">>/etc/security/limits.conf
echo "#        - sigpending - max number of pending signals">>/etc/security/limits.conf
echo "#        - msgqueue - max memory used by POSIX message queues (bytes)">>/etc/security/limits.conf
echo "#        - nice - max nice priority allowed to raise to values: [-20, 19]">>/etc/security/limits.conf
echo "#        - rtprio - max realtime priority">>/etc/security/limits.conf
echo "#">>/etc/security/limits.conf
echo "#<domain>      <type>  <item>         <value>">>/etc/security/limits.conf
echo "#">>/etc/security/limits.conf
echo >>/etc/security/limits.conf
echo "#*               soft    core            0">>/etc/security/limits.conf
echo "#*               hard    rss             10000">>/etc/security/limits.conf
echo "#@student        hard    nproc           20">>/etc/security/limits.conf
echo "#@faculty        soft    nproc           20">>/etc/security/limits.conf
echo "#@faculty        hard    nproc           50">>/etc/security/limits.conf
echo "#ftp             hard    nproc           0">>/etc/security/limits.conf
echo "#@student        -       maxlogins       4">>/etc/security/limits.conf
echo "*        soft    core        unlimited">>/etc/security/limits.conf
echo "*        hard    core        unlimited">>/etc/security/limits.conf
echo "*        soft    data        unlimited">>/etc/security/limits.conf
echo "*        hard    data        unlimited">>/etc/security/limits.conf
echo "*        soft    fsize       unlimited">>/etc/security/limits.conf
echo "*        hard    fsize       unlimited">>/etc/security/limits.conf
echo "*        soft    memlock     unlimited">>/etc/security/limits.conf
echo "*        hard    memlock     unlimited">>/etc/security/limits.conf
echo "*        soft    nofile      1024000">>/etc/security/limits.conf
echo "*        hard    nofile      1024000">>/etc/security/limits.conf
echo "*        soft    rss         unlimited">>/etc/security/limits.conf
echo "*        hard    rss         unlimited">>/etc/security/limits.conf
echo "*        soft    stack       unlimited">>/etc/security/limits.conf
echo "*        hard    stack       unlimited">>/etc/security/limits.conf
echo "yun      soft    nproc       102400">>/etc/security/limits.conf
echo "yun      hard    nproc       102400">>/etc/security/limits.conf
echo "*        soft    locks       unlimited">>/etc/security/limits.conf
echo "*        hard    locks       unlimited">>/etc/security/limits.conf
echo "*        soft    sigpending  unlimited">>/etc/security/limits.conf
echo "*        hard    sigpending  unlimited">>/etc/security/limits.conf
echo "*        soft    msgqueue    unlimited">>/etc/security/limits.conf
echo "*        hard    msgqueue    unlimited">>/etc/security/limits.conf
echo >>/etc/security/limits.conf
echo "# End of file">>/etc/security/limits.conf

if [ ! -f /etc/security/limits.d/20-nproc_conf_ori_bak ]; then
    cp /etc/security/limits.d/20-nproc.conf /etc/security/limits.d/20-nproc_conf_ori_bak
fi
sed -i 's/.*soft    nproc.*/*          soft    nproc     102400/' /etc/security/limits.d/20-nproc.conf

#设置yum更新源，注意repo已经由ansible-playbook输出至服务器
mkdir -p /etc/pki/rpm-gpg
wget https://archive.fedoraproject.org/pub/epel/RPM-GPG-KEY-EPEL-7 -P /etc/pki/rpm-gpg

#安装必备软件
yum -y install epel-release
yum -y install vim htop net-tools ntp
yum -y install nc gcc  gcc-c++ autoconf automake make unzip git git-core libtool pkgconfig tcpdump lrzsz which json-c
yum -y install mysql-devel mysql-libs unixODBC-devel dos2unix gdb patch httpd
yum -y install libcurl libcurl-devel  curl-devel openssl-devel openssl libssl-devel
yum -y install libtermcap-devel  ncurses-devel flex bison libxml2-devel libxml2 pcre-devel bzip2
yum -y install pcre python python-devel libevent libevent-devel
yum -y install libunistring libunistring-devel  ncurses-devel libjpeg-devel libtiff-devel libogg libogg-devel libvorbis libvorbis-devel
yum -y install expat-devel libzrtpcpp-devel zlib zlib-devel alsa-lib-deve perl-libs gdbm-devel libdb-devel uuid-devel
yum -y install bridge-utils # 查看docker网桥
cp -R -p /usr/lib64/mysql/* /usr/lib64/

#关闭防火墙
systemctl stop firewalld
systemctl disable firewalld
rm -f /etc/sysconfig/iptables

#校正时间
ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime
ntpdate asia.pool.ntp.org
if [[ ! -f /etc/rc.d/rc.local ]]; then
    echo "#!/bin/bash" > /etc/rc.d/rc.local
    echo "# THIS FILE IS ADDED FOR COMPATIBILITY PURPOSES" >> /etc/rc.d/rc.local
    echo "#" >> /etc/rc.d/rc.local
    echo "# It is highly advisable to create own systemd services or udev rules" >> /etc/rc.d/rc.local
    echo "# to run scripts during boot instead of using this file." >> /etc/rc.d/rc.local
    echo "#" >> /etc/rc.d/rc.local
    echo "# In contrast to previous versions due to parallel execution during boot" >> /etc/rc.d/rc.local
    echo "# this script will NOT be run after all other services." >> /etc/rc.d/rc.local
    echo "#" >> /etc/rc.d/rc.local
    echo "# Please note that you must run 'chmod +x /etc/rc.d/rc.local' to ensure" >> /etc/rc.d/rc.local
    echo "# that this script will be executed during boot." >> /etc/rc.d/rc.local
    echo >> /etc/rc.d/rc.local
    echo "touch /var/lock/subsys/local" > /etc/rc.d/rc.local
    echo >> /etc/rc.d/rc.local
    echo "ntpdate pool.ntp.org" >> /etc/rc.d/rc.local
fi
chmod +x /etc/rc.d/rc.local

# 设置vimrc
echo "\

set nu
set tabstop=2
set expandtab
set smartindent shiftwidth=2
set nocp
set autochdir
set hlsearch
set incsearch
set encoding=utf-8 fileencodings=utf-8,gb2312,gbk,latin-1,cp936
filetype plugin indent on
filetype plugin on
autocmd FileType python set omnifunc=pythoncomplete#Complete
autocmd FileType python setlocal tabstop=4 shiftwidth=4 softtabstop=4
set guifont=Courier\ Regular\ 12
colorscheme torte
map :silent 1,$!xmllint –format –recover – 2>/dev/null" >> /etc/vimrc


# 添加定时校正时间cron
matched_time=`crontab -l | grep time\.example\.com|wc -l`
if [[ ${matched_time} == 0 ]];then
    crontab -l > /tmp/cron.conf
    echo '*/5 * * * * /usr/sbin/ntpdate time.exmaple.com &> /dev/null && /sbin/hwclock -w &> /dev/null' >> /tmp/cron.conf && crontab /tmp/cron.conf && rm /tmp/cron.conf
fi

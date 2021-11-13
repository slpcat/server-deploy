#version=DEVEL
# System authorization information
auth --enableshadow --passalgo=sha512
# Install OS instead of upgrade
install
# Use network installation
# Use text mode install
text
# Firewall configuration
firewall --disabled
firstboot --disable
ignoredisk --only-use=vda
# Keyboard layouts
keyboard --vckeymap=us --xlayouts=''
# System language
lang en_US.UTF-8

# Network information
#network  --bootproto=dhcp --device=eth0 --ipv6=auto --activate
#network  --bootproto=dhcp --device=eth1 --onboot=off --ipv6=auto
#network  --hostname=localhost.localdomain
# Reboot after installation
reboot
#url --mirrorlist="http://mirrorlist.centos.org/?release=7&arch=x86_64&repo=os"
#repo --name="CentOS" --baseurl=http://mirror.centos.org/centos/7/os/x86_64/ --cost=100
#repo --name="Updates" --baseurl=http://mirror.centos.org/centos/7/updates/x86_64/ --cost=100

logging --level=info
# Root password
#rootpw --iscrypted $1$123.com$vJnAV0PmpKla9ZpsLSQU6/
rootpw "centos"
#user --name=centos --plaintext --password packer

# SELinux configuration
selinux --disabled
# System services
services --disabled="NetworkManager" --enabled="chronyd"
# Do not configure the X Window System
skipx
# System timezone
timezone Asia/Shanghai --isUtc
# System bootloader configuration
bootloader --append="rhgb quiet crashkernel=auto" --location=mbr --driveorder="vda" --boot-drive=vda
# Clear the Master Boot Record
zerombr
# Partition clearing information
clearpart --all --initlabel
part / --fstype="ext4" --size=1 --asprimary --grow --ondisk=vda --fsoptions=rw,noatime,data=ordered,nobarrier,inode_readahead_blks=2048,delalloc,commit=600,errors=remount-ro,discard,x-systemd.growfs
#part / --asprimary --fstype="ext4" --ondisk=sda --size=100000
#part /tol --fstype="xfs" --ondisk=sda --size=1041496
#part biosboot --fstype="biosboot" --size=2
#part /boot --asprimary --fstype="xfs" --ondisk=sda --size=1000

%post

#rm -rf /etc/resolv.conf
#cat >> /etc/resolv.conf << KDA
#nameserver 127.0.0.1
#KDA

#cat >> /etc/sysconfig/network-scripts/ifcfg-bond1 << EOF
#DEVICE=bond1
#TYPE=Ethernet
#ONBOOT=yes
#NM_CONTROLLED=no
#BOOTPROTO=none
#IPADDR=172.16.
#NETMASK=255.255.255.0
#GATEWAY=172.16.
#BONDING_OPTS="miimon=100 mode=1"
#EOF
# Configure the network

%end

%packages --nobase
@core
chrony
kexec-tools
bash
coreutils
chkconfig
curl
dhclient
e2fsprogs
iputils
kbd
man
openssh
passwd
sudo
vim-minimal
-*firmware
-firewalld-filesystem
-libteam
-teamd
-tuned


%end

#%addon com_redhat_kdump --enable --reserve-mb='auto'

#%end

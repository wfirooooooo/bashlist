#!/bin/bash
##
# init network
# 1 turn off ipv6
# 2 ip netmask gateway hostname
# 3 dns
# date 2014-3-24
# author wong
# version 2
##

usage()
{
  echo "sh $0 -i ip -n netmask -g gateway -o hostname"
  echo ""
  exit
}

while getopts ":i:n:g:o:h" opt
do
  case $opt in
    i)
      ip=$OPTARG	#ip value
    ;;
    n)
      netmask=$OPTARG	#netmask value
    ;;
    g)
      gateway=$OPTARG	#gateway value
    ;;
    o)
      hostname=$OPTARG	#hostname value
    ;;
    h)
      usage
      exit 0
    ;;
    *)
      usage
      exit 1
    ;;
  esac
done
    
if [ -z $ip ];then 
  echo "lack ip value"
  usage
  exit 1
fi

if [ -z $netmask ];then
  echo "lack netmask value"
  usage
  exit 1
fi

if [ -z $gateway ];then
  echo "lack gateway value"
  usage
  exit 1
fi

if [ -z $hostname ];then
  echo "lack hostname value"
  usage
  exit 1
fi

#some dirs and files
bakdir=/root/bak/
networkdir=/etc/sysconfig/network-scripts
eth0file=${networkdir}/ifcfg-eth0
moddir=/etc/modprobe.d

test ! -d $bakdir && mkdir $bakdir

filelist=$(ls /etc/sysconfig/network-scripts/ifcfg-*| grep -v lo)

mv ${filelist} $bakdir > /dev/null 2>&1

#create ifcfg-eth0 file
echo "DEVICE=eth0"        >> $eth0file
echo "TYPE=Ethernet"       >> $eth0file
echo "ONBOOT=yes"          >> $eth0file
echo "NM_CONTROLLED=no"    >> $eth0file
echo "BOOTPROTO=none"      >> $eth0file
echo "IPV6INIT=no"         >> $eth0file
echo "USERCTL=no"          >> $eth0file
echo "IPADDR=${ip}"        >> $eth0file
echo "NETMASK=${netmask}"  >> $eth0file
echo "GATEWAY=${gateway}"  >> $eth0file

#add host file
echo "$ip $hostname" >> /etc/hosts

#turn off ipv6
ipv6off=${moddir}/ipv6off.conf
echo "options ipv6 disable=1" >>${ipv6off}

sed -i "s/HOSTNAME/#HOSTNAME/g" /etc/sysconfig/network
echo "HOSTNAME=$hostname" >> /etc/sysconfig/network
echo "NETWORKING_IPV6=no" >> /etc/sysconfig/network
sed -i "s/::1/#::1/g" /etc/hosts

# set dns
> /etc/resolv.conf
echo "search $hostname" >> /etc/resolv.conf
echo "nameserver 8.8.8.8" >> /etc/resolv.conf
echo "nameserver 114.114.114.114" >> /etc/resolv.conf

#test the result
echo "---hosts---"
cat /etc/hosts
echo "---network---"
cat /etc/sysconfig/network
echo "---bond0---"
cat $eth0file

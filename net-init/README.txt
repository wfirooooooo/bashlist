hi,
You can use this scripts to init the network config
for new installed server which is not config the network.

 1 net-init-bond.sh
   config network with bonding of two NIC card.
   you need change the ifcfg name to the real card name.
   
   for example(maybe is a DELL server):
     sed -i "s/eth0/p1p1/g" net-init-bond.sh
     sed -i "s/eth1/p2p1/g" net-init-bond.sh
     sh net-init-bond.sh -i 192.168.1.2 -n 255.255.255.0 -g 192.168.1.1 -o node1.com

 2 net-init-nobond.sh
   config network without bonding.
   you just need change the ifcfg name to the real card name.
 
   for example(maybe is a DELL server):
     sed -i "s/eth0/p1p1/g" net-init-bond.sh
     sed -i "s/eth1/p2p1/g" net-init-bond.sh
     sh net-init-nobond.sh -i 192.168.1.2 -n 255.255.255.0 -g 192.168.1.1 -o node1.com
 
  for find the NIC card which is connected the line,you can use this cmd:
    dmesg | grep NIC

maybe I was wrong...
good lock :)

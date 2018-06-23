#!/bin/bash

#get OS
OS=$(awk '/^ID=/' /etc/*-release | awk -F'=' '{ print tolower($2) }' | sed 's/"//' | sed 's/["]//')
defInterface=$(ip addr show | awk '/inet.*brd/{print $NF}' | head -n 1)
defIP=$(ip -f inet a show $defInterface | grep inet | awk '{ print $2 }' | cut -d / -f1)
defNetmask=$(ip -f inet a show eth0 | grep inet | awk '{ print $2 }' | rev | cut -d / -f1 | rev)
gateway=$(ip r | grep default | awk '{print $3}')
#netcfg="/etc/sysconfig/network-scripts/ifcfg-$defInterface"
netcfg="./test-eth0"
#echo vars
echo "---------------------------------------------------------------"
echo -e "Operating system is: " '\033[1m'$OS'\033[0m'
echo -e "Default interface is: " '\033[1m'$defInterface'\033[0m'
echo -e "Main IP is: " '\033[1m'$defIP'\033[0m'
echo -e "Netmask is: " '\033[1m' $defNetmask'\033[0m'
echo -e "Network configuration file located at: "'\033[1m' $netcfg'\033[0m'
if [ $OS  == 'centos' ]
then
	echo "---------------------------------------------------------------"
	if grep -q dhcp $netcfg
	then
		sed -i 's/dhcp/static/g' $netcfg
		sed -i "s/.*BOOTPROTO.*/&\nIPADDR=\"$defIP\"/" $netcfg
		sed -i "s/.*IPADDR.*/&\nPREFIX=\"$defNetmask\"/" $netcfg
		sed -i "s/.*PREFIX.*/&\nGATEWAY=\"$gateway\"/" $netcfg
		sed -i "s/.*GATEWAY.*/&\nDNS1=\"8.8.8.8\"/" $netcfg
		sed -i "s/.*GATEWAY.*/&\nDNS1=\"8.8.4.4\"/" $netcfg
		echo "Interface was configured:"
 	        cat $netcfg	
	else
		echo "Interface is already configured"
	fi 
	echo ""
	echo "---------------------------------------------------------------"


elif [ $OS == 'ubuntu' ]
then
	echo "todo"

else
	echo "OS is not Ubuntu or Centos"
	exit 4
fi

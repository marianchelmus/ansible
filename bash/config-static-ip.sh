#!/bin/bash

#get OS
OS=$(awk '/^ID=/' /etc/*-release | awk -F'=' '{ print tolower($2) }' | sed 's/"//' | sed 's/["]//')
defInterface=$(ip addr show | awk '/inet.*brd/{print $NF}' | head -n 1)
defIP=$(ip -f inet a show $defInterface | grep inet | awk '{ print $2 }' | cut -d / -f1)
defNetmask=$(ip -f inet a show eth0 | grep inet | awk '{ print $2 }' | rev | cut -d / -f1 | rev)
ubuntuNetmask=$(ifconfig $defInterface | sed -rn '2s/ .*:(.*)$/\1/p')
gateway=$(ip r | grep default | awk '{print $3}')
#netcfgCentos="/etc/sysconfig/network-scripts/ifcg-$defInterface"
netcfgCentos="/ansible/bash/test-eth0"
#netcfgUbuntu="/etc/network/interfaces
netcfgUbuntu="/root/interfaces"

#echo vars
echo "---------------------------------------------------------------"
echo -e "Operating system is: " '\033[1m'$OS'\033[0m'
echo -e "Default interface is: " '\033[1m'$defInterface'\033[0m'
echo -e "Main IP is: " '\033[1m'$defIP'\033[0m'
echo -e "Netmask is: " '\033[1m' $defNetmask'\033[0m'
if [ $OS  == 'centos' ]
then
	echo "---------------------------------------------------------------"
	echo "Configuring the interface for $OS"
	if [ ! -f $netcfgCentos ]
	then
		echo "Network configuration file not found... EXITING"
		exit 4
	else
		echo -e "Network configuration file located at: "'\033[1m' $netcfgCentos'\033[0m'
		if grep -q dhcp $netcfgCentos
		then
			sed -i 's/dhcp/static/g' $netcfgCentos
			sed -i "s/.*BOOTPROTO.*/&\nIPADDR=\"$defIP\"/" $netcfgCentos
			sed -i "s/.*IPADDR.*/&\nPREFIX=\"$defNetmask\"/" $netcfgCentos
			sed -i "s/.*PREFIX.*/&\nGATEWAY=\"$gateway\"/" $netcfgCentos
			sed -i "s/.*GATEWAY.*/&\nDNS1=\"8.8.8.8\"/" $netcfgCentos
			sed -i "s/.*GATEWAY.*/&\nDNS2=\"8.8.4.4\"/" $netcfgCentos
			echo "Interface was configured:"
 		        cat $netcfgCentos	
		else
			echo "Interface is already configured"
			cat $netcfgCentos
		fi 
	fi
	echo ""
	echo "---------------------------------------------------------------"


elif [ $OS == 'ubuntu' ]
then
	echo "---------------------------------------------------------------"
        echo "Configuring the interface for $OS"
       	if [ ! -f $netcfgUbuntu ]
	then
		echo "Configuration file not found... Exiting"
		exit 4
	else
		echo -e "Network configuration file located at: " '\033[1m' $netcfgUbuntu'\033[0m'
		if grep -q dhcp $netcfgUbuntu
		then
			sed -i 's/dhcp/static/g' $netcfgUbuntu
			echo "        address $defIP" >> $netcfgUbuntu
			echo "        netmask $ubuntuNetmask" >> $netcfgUbuntu
			echo "        gateway $gateway" >> $netcfgUbuntu
			echo "        dns-nameservers 8.8.8.8 8.8.4.4" >> $netcfgUbuntu
			echo "Interface was configured: "
			cat $netcfgUbuntu
		else
			echo "Interface was already configured"
			cat $netcfgUbuntu
		fi
	fi
else
	echo "OS is not Ubuntu or Centos"
	exit 4
fi

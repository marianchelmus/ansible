#!/bin/bash

#get OS
OS=$(awk '/^ID=/' /etc/*-release | awk -F'=' '{ print tolower($2) }' | sed 's/"//' | sed 's/["]//')
defInterface=$(ip addr show | awk '/inet.*brd/{print $NF}' | head -n 1)
defIP=$(ip -f inet a show $defInterface | grep inet | awk '{ print $2 }' | cut -d / -f1)
defNetmask=$(ip -f inet a show eth0 | grep inet | awk '{ print $2 }' | rev | cut -d / -f1 | rev)

#echo vars

echo -e "Operating system is: " '\033[1m'$OS'\033[0m'
echo -e "Default interface is: " '\033[1m'$defInterface'\033[0m'
echo -e "Main IP is: " '\033[1m'$defIP'\033[0m'
echo -e "Netmask is: " '\033[1m' $defNetmask'\033[0m'
#if [ $OS  == 'centos' ]


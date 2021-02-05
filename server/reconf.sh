#!/bin/bash

PWD=`pwd`
dir=`dirname $0`
cd $dir
prompt_confirm() {

	while true; do
		read -r -n 1 -p "${1:-Contiue?} [y|n]: " REPLY
		case $REPLY in
			[yY]) echo ; return 0 ;;
			[nN]) echo ; return 1 ;;
			*) printf " \033[31m %s \n\033[0m" "invalid input"
		esac
	done
}

printf "\033[4;33m%s\n\033[0m" "Reconfiguration of server-side bonding"

echo
(( $# > 0 )) &&
	printf "\033[2;31m%s\033[0m"  "reconf: "&&
	printf "\033[4;31m%s\n\033[0m" "error" &&
	printf "\033[35m%s\n\033[0m" "usage: ./reconf.sh" &&
	exit 1



read -r -p "No of tunnels: " tuns
echo
! [[ "$tuns" =~ ^[0-9]+$ ]] && printf "\033[4;31m%s\n\033[0m"   "not a number" && exit 1

(( $tuns < 2 )) && printf "\033[4;31m%s\n\033[0m"   "cannot bond less than 2 devices" && exit 1
(( $tuns > 4 )) && printf "\033[4;31m%s\n\033[0m"   "cannot bond more than 4 devices" && exit 1



sed -i "/^numberOfTunnels=.*/ s//numberOfTunnels=${tuns}/" commonConfig
echo "Done configuring tunnels"

# TODO: Add mode and packet configuration

prompt_confirm "Proceed with the installation?" || exit 1

rm -rf /etc/openvpn/server /etc/openvpn/commonConfig /etc/openvpn/*bond.sh
prompt_confirm "Generate new key?" && rm /etc/openvpn/ta.key
./install.sh

echo 
printf "\033[1;35m%s\n\033[0m" "Installation finished"
printf "\033[0;35m%s\033[0m\033[3;36m%s\033[0m"  "run: " "#/etc/openvpn/startbond.sh"
printf "\033[0;35m%s\033[0m\033[3;36m%s\n\033[0m"  " or: " "#/etc/openvpn/stopbond.sh"


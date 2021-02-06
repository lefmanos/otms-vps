#!/bin/bash

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

devs=( $( ip link | cut -d: -f2 | grep " " | sed "s/ //" ) )

printf "\033[4;33m%s\n\033[0m" "Reconfiguration of client-side bonding"

echo
(( $# > 0 )) &&
	printf "\033[2;31m%s\033[0m"  "reconf: "&&
	printf "\033[4;31m%s\n\033[0m" "error" &&
	printf "\033[35m%s\n\033[0m" "usage: ./reconf.sh" &&
	exit 1

printf "\033[4;35m%s\n\033[0m" "Device list:"
cnt=0
for d in "${devs[@]}"
do
	let "cnt += 1"
	printf "\033[0;36m%s\033[0m\033[3;36m%s\n\033[0m"   "    $cnt)" " $d"
done

echo
printf "\033[1;37m%s\n\033[0m" "Select devices to be bond. "
printf "\033[3;37m%s\n\033[0m" "  e.g. "
printf "    devs: 2,3\n"
printf "\033[3;37m%s\n\033[0m" "  or"
printf "    devs: 2,4,\n"
echo
read -r -p "devs: " selection
echo

cnt_sel=0
IFS=',' read -ra sel_t <<< "$selection"
for i in "${sel_t[@]}"; do
	let "cnt_sel += 1"
	! [[ "$i" =~ ^[0-9]+$ ]] && printf "\033[4;31m%s\n\033[0m"   "not a number" && exit 1
	[[ $i -gt $cnt ]] && printf "\033[4;31m%s\n\033[0m"   "skata device evales, malaka. Fevgw..." && exit 1
done

(( $cnt_sel < 2 )) && printf "\033[4;31m%s\n\033[0m"   "cannot bond less than 2 devices" && exit 1
(( $cnt_sel > 4 )) && printf "\033[4;31m%s\n\033[0m"   "cannot bond more than 4 devices" && exit 1

tun_devs=()
echo
echo "Bond devices: "
for i in "${sel_t[@]}"; do
	let "iter = i - 1"
	echo "    * "${devs[$iter]}
	tun_devs+=( ${devs[$iter]} )

done
prompt_confirm "Continue?" || exit 1

iter=0
for tun in "${tun_devs[@]}"; do
	let "iter += 1"
	sed -i "s/tunnelInterface$iter=.*/tunnelInterface${iter}=${tun}/" commonConfig
done
sed -i "/^numberOfTunnels=.*/ s//numberOfTunnels=${cnt_sel}/" commonConfig
echo
echo "Done configuring interfaces"

echo
echo "Current VPN Server: $( cat commonConfig | grep vpnServer | cut -d= -f2 )"
prompt_confirm "Do you want to change the server?" && read -r -p "New VPN Server: " srv

[[ -z ${srv+x} ]] || sed -i "/^vpnServer=.*/ s//vpnServer=${srv}/" commonConfig


prompt_confirm "Proceed with the installation?" || exit 1

sudo rm -rf /etc/openvpn/client /etc/openvpn/commonConfig /etc/openvpn/*bond.sh
sudo ./install.sh

echo 
printf "\033[1;35m%s\n\033[0m" "Installation finished"
printf "\033[0;35m%s\033[0m\033[3;36m%s\033[0m"  "run: " "#/etc/openvpn/startbond.sh"
printf "\033[0;35m%s\033[0m\033[3;36m%s\n\033[0m"  " or: " "#/etc/openvpn/stopbond.sh"

# OB_onetwo
This is a project forked from https://github.com/onemarcfifty/openvpn-bonding

This project is heavily based on [openvpn bonding](https://github.com/onemarcfifty/openvpn-bonding) from [onemarcfifty](https://github.com/onemarcfifty)

Run client/reconf.sh on client for interactive configuration
Run server/reconf.sh on server for interactive configuration

Execute both scripts with elevated privileges

## Bellow is the original readme by onemarcfifty

### _openvpn-bonding_
_The scripts in this repository may be used to bond multiple VPN interfaces together and hence increase (i.e. double, triple, quadruple....) your internet speed._

_The way this is achieved is by installing openvpn as a server on a VPS (i.e. a virtual Server which you can rent from any VPS provider) and running a vpn client on your home network environment (i.e. a raspberry pi, in a VM or on an OpenWRT router)_

_The network interfaces which are specified in the configuration file are then bonded on the client and on the server side and effectively aggregate the available internet speed over multiple connections._

_Find all details on [my youtube channel](https://www.youtube.com/channel/UCG5Ph9Mm6UEQLJJ-kGIC2AQ)_

_The work is greatly inspired by [this article on serverfault by legolas108](https://serverfault.com/questions/977589/how-to-bond-two-multiple-internet-connections-for-increased-speed-and-failover)_

_IMPORTANT: Please note that this works only for IP V4 at the moment_
_IP V6 is future work_

_If you are having issues with these scripts (they don't work as expected etc.) then you may join my discord server and chat life with me - please see [THIS VIDEO](https://youtu.be/VouCBt1NTjw) for details_

#!/bin/bash
ovpn_genconfig -u udp://$(curl -s http://whatismyip.akamai.com/ | cut -b 1-16)
ovpn_initpki
echo "Set prefix"
read CLIENTNAME
echo "qnty?"
read qnty
for (( i=1; i <= $qnty; i++ ))
do
echo " $i"
easyrsa build-client-full $CLIENTNAME$i nopass
ovpn_getclient $CLIENTNAME$i > $CLIENTNAME$i.ovpn
done

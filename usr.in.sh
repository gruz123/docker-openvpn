#!/bin/bash
echo "Set prefix"
read CLIENTNAME
echo "qnty?"
read qnty
for (( i=1; i <= $qnty; i++ ))
do
echo " $i"
easyrsa --passin=pass:$(cat $OPENVPN/psk)  build-client-full $CLIENTNAME$i nopass
ovpn_getclient $CLIENTNAME$i > $CLIENTNAME$i.ovpn
done

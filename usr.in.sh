#!/bin/bash
echo "Set prefix(name)"
read CLIENTNAME
if [ -d "clients/$CLIENTNAME" ]
    then
    e=$(ls clients/$CLIENTNAME/ | wc -l) || :
    else 
    e=0
    mkdir clients/$CLIENTNAME
fi
echo "quantity? 1-25"
read q
if [[ "${q}" =~ ^([0-9]) ]]; then
   if [[ $q -lt 25 ]]
   then 
t=$(($e+$q))
for (( i=1; i <= $t; i++ ))
do
easyrsa --passin=pass:$(cat $OPENVPN/psk)  build-client-full $CLIENTNAME$i nopass
getclient $CLIENTNAME$i > clients/$CLIENTNAME/$CLIENTNAME$i.ovpn
echo "added $q, total =$t"
done
   else 
      echo "allowed only 25 users per request"
   fi
else
echo "error: Not a number" >&2; exit 1
fi
#!/bin/bash
echo "Set prefix(Name)"
read -r CLIENTNAME
if [ -d "clients/$CLIENTNAME" ]
    then
    #e="$(ls clients/"$CLIENTNAME"/*.ovpn | wc -l)" || :
    p=(clients/"$CLIENTNAME"/*.ovpn) || :
    e=${#p[@]}
    else 
    e=0
    mkdir -p clients/"$CLIENTNAME"
fi
echo "How many users ? 1-25"
read -r q
if [[ "${q}" =~ ^([0-9]) ]]; then
   if [[ $q -lt 26 ]]
   then 
t=$((e+q))
for (( i=1; i <= t; i++ ))
do
easyrsa --passin=pass:"$(cat "$OPENVPN"/psk)"  build-client-full "$CLIENTNAME$i" nopass
getclient "$CLIENTNAME$i" > clients/"$CLIENTNAME"/"$CLIENTNAME$i".ovpn
done
echo "added $q, total =$t"
   else 
      echo "allowed only 25 users per request"
   fi
else
echo "error: Not a number" >&2; exit 1
fi


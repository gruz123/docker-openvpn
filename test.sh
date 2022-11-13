OVPN_DATA="ovp$(shuf -i 1-9999 -n1)"
docker volume create --name $OVPN_DATA
docker run -v $OVPN_DATA:/etc/openvpn --rm gruz123/ovpn ovpn_genconfig -u udp://$(curl -s http://whatismyip.akamai.com/ | cut -b 1-16)
docker run -v $OVPN_DATA:/etc/openvpn --rm -it gruz123/ovpn ovpn_initpki
docker run -v $OVPN_DATA:/etc/openvpn -d -p 1194:1194/udp --cap-add=NET_ADMIN gruz123/ovpn

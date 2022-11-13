ovpn_genconfig -u udp://$(curl -s http://whatismyip.akamai.com/ | cut -b 1-16)
ovpn_initpki
#openvpn -d -p 1194:1194/udp --cap-add=NET_ADMIN gruz123/ovpn

#!/bin/sh
2=$(cat /etc/openvpn/psk)
easyrsa gen-crl $2

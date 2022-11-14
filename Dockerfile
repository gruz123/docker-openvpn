# Original credit: https://github.com/jpetazzo/dockvpn

# Smallest base image
FROM alpine:latest

#LABEL maintainer="Kyle Manna <kyle@kylemanna.com>"

# Testing: pamtester
RUN echo "http://dl-cdn.alpinelinux.org/alpine/edge/testing/" >> /etc/apk/repositories && \
    apk add --update openvpn iptables bash easy-rsa openvpn-auth-pam google-authenticator curl pamtester libqrencode bind-tools && \
    ln -s /usr/share/easy-rsa/easyrsa /usr/local/bin && \
    rm -rf /tmp/* /var/tmp/* /var/cache/apk/* /var/cache/distfiles/*

# Needed by scripts
ENV OPENVPN=/etc/openvpn
ENV EASYRSA=/usr/share/easy-rsa \
    EASYRSA_CRL_DAYS=3650 \
    EASYRSA_PKI=$OPENVPN/pki \ 
    EASYRSA_FILE=/usr/share/easy-rsa/easyrsa

VOLUME ["/etc/openvpn"]

# use randmon passphrase and log it to /psk
# using inside container: sed -i '649i\\t\shuf \x2Di 10000000\x2D99999999 \x2Dn 1 \x3E \x22\x2Fpsk\x22 \x26\x26 cat \x22\x2Fpsk\x22 \x3E  \x22$out\x5Fkey\x5Fpass\x5Ftmp\x22' $EASYRSA_FILE    
#RUN sed -i '649ishuf -i 10000000-99999999 -n 1 > "/psk" && cat "/psk" >  "$out_key_pass_tmp"' $EASYRSA_FILE
RUN sed -i '649,662d' $EASYRSA_FILE && sed -i '649ikpass=$(shuf -i 10000000-99999999 -n 1)' $EASYRSA_FILE && \ 
sed -i '650iprintf "%s" "$kpass" > "$out_key_pass_tmp" && printf "%s" "$kpass" > "$OPENVPN/psk"' $EASYRSA_FILE


# Internally uses port 1194/udp, remap using `docker run -p 443:1194/tcp`
EXPOSE 1194/udp

CMD ["ovpn_run"]

ADD ./bin /usr/local/bin
RUN chmod a+x /usr/local/bin/*

# Add support for OTP authentication using a PAM module
ADD ./otp/openvpn /etc/pam.d/

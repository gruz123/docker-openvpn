# Original credit: https://github.com/jpetazzo/dockvpn

# Smallest base image
FROM alpine:latest

LABEL maintainer="ArtemK <gruz123@gmail.com>"

# Testing: pamtester
RUN echo "http://dl-cdn.alpinelinux.org/alpine/edge/testing/" >> /etc/apk/repositories && \
    apk add --update openvpn iptables bash easy-rsa openvpn-auth-pam google-authenticator curl s-nail ssmtp pamtester libqrencode && \
    ln -s /usr/share/easy-rsa/easyrsa /usr/local/bin && \
    ln -s /usr/bin/mail /usr/bin/mailx && \
    rm -rf /tmp/* /var/tmp/* /var/cache/apk/* /var/cache/distfiles/*

# Needed by scripts
ENV OPENVPN=/etc/openvpn
ENV EASYRSA=/usr/share/easy-rsa \
    EASYRSA_CRL_DAYS=3650 \
    EASYRSA_PKI=$OPENVPN/pki \ 
    EASYRSA_FILE=/usr/share/easy-rsa/easyrsa
ENV SSMTPC=/etc/ssmtp/ssmtp.conf

VOLUME ["/etc/openvpn"]

# use randmon passphrase and log it to /psk
RUN sed -i '649,662d' $EASYRSA_FILE && sed -i '649ikpass=$(shuf -i 10000000-99999999 -n 1)' $EASYRSA_FILE && \ 
sed -i '650iprintf "%s" "$kpass" > "$out_key_pass_tmp" && printf "%s" "$kpass" > "$OPENVPN/psk"' $EASYRSA_FILE


# Internally uses port 1194/udp, remap using `docker run -p 443:1194/tcp`
EXPOSE 1194/udp

CMD ["ovpn_run"]

ADD ./bin /usr/local/bin
RUN chmod a+x /usr/local/bin/*

# Add support for OTP authentication using a PAM module
ADD ./otp/openvpn /etc/pam.d/

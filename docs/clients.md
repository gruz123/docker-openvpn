# Advanced Client Management

## Client Configuration Mode

The [`getclient`](/bin/getclient) can produce two different versions of the configuration.

1. combined (default): All needed configuration and cryptographic material is in one file (Use "combined-save" to write the configuration file in the same path as the separated parameter does).
2. separated: Separated files.

Note that some client software might be picky about which configuration format it accepts.

## Client List

See an overview of the configured clients, including revocation and expiration status:

    docker run --rm -it -v $OVPN_DATA:/etc/openvpn gruz123/ovpn listclients

 The output is generated using `openssl verify`. Error codes from the verification process different from `X509_V_ERR_CERT_HAS_EXPIRED` or `X509_V_ERR_CERT_REVOKED` will show the status `INVALID`.

## Batch Mode

If you have more than a few clients, you will want to generate and update your client configuration in batch. For this task the script [`getclient_all`](/bin/getclient_all) was written, which writes out the configuration for each client to a separate directory called `clients/$cn`.

Execute the following to generate the configuration for all clients:

    docker run --rm -it -v $OVPN_DATA:/etc/openvpn --volume /tmp/openvpn_clients:/etc/openvpn/clients gruz123/ovpn getclient_all

After doing so, you will find the following files in each of the `$cn` directories:

    ca.crt
    $cn-combined.ovpn # Combined configuration file format. If your client recognices this file then only this file is needed.
    $cn.ovpn          # Separated configuration. This configuration file requires the other files ca.crt dh.pem $cn.crt $cn.key ta.key
    $cn.crt
    $cn.key
    ta.key

## Revoking Client Certificates

Revoke `client1`'s certificate and generate the certificate revocation list (CRL) using [`revokeclient`](/bin/revokeclient) script :

    docker run --rm -it -v $OVPN_DATA:/etc/openvpn gruz123/ovpn revokeclient client1

The OpenVPN server will read this change every time a client connects (no need to restart server) and deny clients access using revoked certificates.

You can optionally pass `remove` as second parameter to revokeclient to remove the corresponding crt, key and req files :

    docker run --rm -it -v $OVPN_DATA:/etc/openvpn gruz123/ovpn revokeclient client1 remove

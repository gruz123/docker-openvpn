# OpenVPN for Docker

[![Build Status](https://app.travis-ci.com/gruz123/docker-openvpn.svg?branch=master)](https://app.travis-ci.com/gruz123/docker-openvpn)
[![Docker Stars](https://img.shields.io/docker/stars/gruz123/ovpn.svg)](https://hub.docker.com/r/gruz123/ovpn/)
[![Docker Pulls](https://img.shields.io/docker/pulls/gruz123/ovpn.svg)](https://hub.docker.com/r/gruz123/ovpn/)
[![FOSSA Status](https://app.fossa.com/api/projects/git%2Bgithub.com%2Fgruz123%2Fdocker-openvpn.svg?type=shield)](https://app.fossa.com/projects/git%2Bgithub.com%2Fgruz123%2Fdocker-openvpn?ref=badge_shield)


OpenVPN server in a Docker container complete with an EasyRSA PKI CA \
Auto install/config, users auto creation, send configs/backup by email or Telegram.

* Docker Registry @ [gruz123/ovpn](https://hub.docker.com/r/gruz123/ovpn/)
* GitHub @ [gruz123/docker-ovpn](https://github.com/gruz123/docker-openvpn)

### Forked from:
* GitHub @ [kylemanna/docker-openvpn](https://github.com/kylemanna/docker-openvpn)

## Differences kylemanna/docker-openvpn

* Auto users creation (adduser)
* Send users configurations by email or telegram (send)
* Auto generated passphrase (openvpn-data/conf/psk) 
* Backup and auto backup by mail or telegram, adanced security futures: 
*   [based on this document](/docs/paranoid.md) and this
    [this document](/docs/backup.md) (work in progress)

# Quick Start with docker-compose


* Add a new service in docker-compose.yml

```yaml
version: '2'
services:
  openvpn:
    cap_add:
     - NET_ADMIN
    image: gruz123/ovpn
    container_name: openvpn
    ports:
     - "1194:1194/udp"
    restart: always
    volumes:
     - ./openvpn-data/conf:/etc/openvpn
    environment: 
     - "EmailUN=gruz123@gmailcom"
     - "EmailPW=16"
     - "SMTP=smtp.gmail.com:587" 
     - "Encryption=STARTTLS" 
     - "chat_id=-1001111111125"
     - "botToken=1111222244:AAaaAAaaAaAAaaAAAaaAAaaaaaAaA21AAAA"
```
 
Usual gmail pwd ain't' gonna work
https://myaccount.google.com/apppasswords


* Initialize the configuration files and certificates

```bash
docker-compose run --rm openvpn quickstart
```
* Automatically: 
  * Set external ip
  * Build server with passphrase
  * Generate clients certificates without a passphrase
  * Retrieve the clients configuration with embedded certificates
* User input   
  * prefix (username) and quantity.
  * As an example:
  * set Prefix: `Halifax`
  * set quantity: 12
  * it creates: `Halifax1.ovpn`, `Halifax2.ovpn` ...`Halifax12.ovpn`

  
To add more with same or different prefix 

      docker run -v $OVPN_DATA:/etc/openvpn --rm gruz123/ovpn adduser

 Send user configuration to Email or Telegram 

      docker run -v $OVPN_DATA:/etc/openvpn --rm gruz123/ovpn send

* Fix ownership (depending on how to handle your backups, this may not be needed)       

```bash
sudo chown -R $(whoami): ./openvpn-data
```

* Start OpenVPN server process

```bash
docker-compose up -d openvpn
```

* You can access the container logs with

```bash
docker-compose logs -f
```

## Custom settings.

* ip/fqdn, port number and protocol (UDP to TCP) can be changed here (on host):

```bash
openvpn-data/conf/env.sh
```
* for switching UDP to TCP needed
to be changed here also, for client configuration files. (don't need to change port number here):
```bash
openvpn-data/conf/openvpn.conf
  ```

### More about tcp

advanced configurations are available in this
[docs](docs/tcp.md) page.

## Debugging Tips

* Create an environment variable with the name DEBUG and value of 1 to enable debug output (using "docker -e").

```bash
docker-compose run -e DEBUG=1 -p 1194:1194/udp openvpn
```
 ### Old way
  Old way if you need to set ip, fqdn, port (number and protocol) by you own during installation

* Initialize the configuration files and certificates

```bash
docker-compose run --rm openvpn ovpn_genconfig -u udp://VPN.SERVERNAME.COM
docker-compose run --rm openvpn ovpn_initpki
```

* Generate a client certificate

```bash
export CLIENTNAME="your_client_name"
# with a passphrase (recommended)
docker-compose run --rm openvpn easyrsa build-client-full $CLIENTNAME
# without a passphrase (not recommended)
docker-compose run --rm openvpn easyrsa build-client-full $CLIENTNAME nopass
```

* Retrieve the client configuration with embedded certificates

```bash
docker-compose run --rm openvpn getclient $CLIENTNAME > $CLIENTNAME.ovpn
```

* Revoke a client certificate

```bash
# Keep the corresponding crt, key and req files.
docker-compose run --rm openvpn revokeclient $CLIENTNAME
# Remove the corresponding crt, key and req files.
docker-compose run --rm openvpn revokeclient $CLIENTNAME remove
```

### More Reading

Miscellaneous write-ups for advanced configurations are available in the
[docs](docs) folder.


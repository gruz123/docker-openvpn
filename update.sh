docker image remove -f  $(docker image list)
docker build -t ovpn:latest .
docker tag ovpn:latest gruz123/ovpn:latest
push image, just done!
docker push gruz123/ovpn

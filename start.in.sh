#!/bin/bash
genconfig -u udp://$(curl -s http://whatismyip.akamai.com/ | cut -b 1-16)
initpki
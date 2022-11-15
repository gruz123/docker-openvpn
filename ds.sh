#!/bin/sh
#function gen_full_client

gen_full_client() {
     CN=$1
     OVERWRITE=$2

 #Generate client using cn and sign it
  if [ -f "$EASYRSA_DIR/pki/private/$CN.key" ]; then         
     cat <-EOF  | sudo $EASYRSA gen-req $CN nopass         
     $OVERWRITE
     $CN   
     EOF
 else
     cat <-EOF  | sudo $EASYRSA gen-req $CN nopass         
     $CN   
     EOF
 fi

 #give it some time
 sleep 2
 CA_PASSWORD=$3
 #Generate client using cn and sign it
 if [ -f "$EASYRSA_DIR/pki/private/$CN.key" ]; then    
     #cat    <-EOF | sudo $EASYRSA opts="-passout stdin" build-client-full $CN      
     cat <-EOF   | sudo $EASYRSA sign-req client $CN 
     yes
     $(echo $CA_PASSWORD)
     EOF
 fi
}
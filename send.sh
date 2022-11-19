#!/bin/bash
echo -e "1. Email  \n2. Telegram \n3. Don't send"
read s
if [[ "${s}" =~ ^([0-9]) ]]; then
   if [[ $s -lt 4 ]]; then
      echo "Архивация"
       tar -cJf clietns.tar.xz "$OPENVPN"/clients/$CLIENTNAME || :
       echo "Подготовка к отправке"
       fi
         if [ "$s" == "1" ]; then
         echo "Отправка на почту..."
         echo -e "to: $EmailUN\nsubject: Clients OVPN\n"| \ 
         (cat - && uuencode clietns.tar.xz clietns.tar.xz ) | ssmtp $EmailUN && rm clients.tar.xz \
         fi
         if [ "$s" == "2" ]; then
         echo "Отправка в Telegram"
         curdir=$PWD
         echo sending $curdir/$1
         curl -F chat_id=$chat_id -F document=@$curdir/clietns.tar.xz https://api.telegram.org/bot$botToken/sendDocument && \
         rm clients.tar.xz
         fi
         if [ "$s" == "3" ]; then
         echo "Эхит"
         fi
         else
      echo "error: ..."
   fi        
else
echo "error: Not a number" >&2; exit 1
fi
  
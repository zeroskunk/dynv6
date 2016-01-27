#!/bin/bash

# ADD A CRONJOB (crontab -e)
# */20 * * * * /usr/sbin/dynv6 <public_dns> <token> > /var/log/dynv6 2>&1


# Line 17 if systemwide Token is given you need no
# second param, if second toke is given it will be used
# reguadless of sytem wide token!!

if [ -z "$1" ]; then
  echo "give me dynv6 dns and token"
  exit 1
else
  if [[ $1 == *".dynv6.net"* ]]; then
    public_dns=$1
  else
    echo "hey I need an dynv6 address"
    exit 1
  fi
  if [ -z $2 ]; then
     if [ -z $token ]; then
       echo "give me token your DNS is $1"
       exit 1
     fi
  else
    token=$2
  fi
fi


# we need dig for getting public ip
# if dig is not in system script exits
# also wget and curl for update is checked

if [ -e /usr/bin/dig ]; then
  public_ip=$(dig +short myip.opendns.com @resolver1.opendns.com)
  current_ip=$(dig +short $public_dns)
else
  echo "install dig on your system"
  echo "mostly dnsutils"
  exit 1
fi

if [ -e /usr/bin/curl ]; then
  bin="curl -fsS"
elif [ -e /usr/bin/wget ]; then
  bin="wget -O-"
else
  echo "neither curl nor wget found"
  exit 1
fi


# compare external and internal IP! If its the same
# script will exit because nothing todo!

ppp0_ip=$(ifconfig ppp0 | grep inet | cut -d ":" -f 2 | cut -d " " -f 1)


if [ -z $test_ip ]; then
 sleep 0
else
  public_ip=$test_ip
fi

if [ $current_ip == $public_ip ]; then
  echo $(date) "your IP is up to date"
  exit 1
else


  echo $(date) "new ipv4 address detected ${public_ip}, updating"
#send address to dynv6
  filepath=$HOME/.${public_dns}.addr4
  last_ip=$(tail -n1 $filepath)
  #echo $bin  "http://ipv4.dynv6.com/api/update?hostname=$public_dns&ipv4=$public_ip&token=$token"
  $bin "http://ipv4.dynv6.com/api/update?hostname=$public_dns&ipv4=$public_ip&token=$token" 2> $filepath
# save current address
        echo "old_ip" $last_ip
        echo "new_ip" $public_ip
  if [[ $last_ip != $public_ip ]]; then
  echo $last_ip >> $filepath
  echo $public_ip >> $filepath
  fi
fi

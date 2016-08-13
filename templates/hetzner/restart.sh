#!/bin/bash

if [ $# -lt 2 ]
then
    echo "Usage : hostname and/or ip not defined"
    exit
fi

hostname=$1
ip=$2
user="{{ monit_hetzner_user }}"
pass="{{ monit_hetzner_password }}"
uri="{{ monit_hetzner_uri }}"
email="{{ monit_hetzner_email }}"
lockfile="/run/restart_$hostname.lock"


# is curl installed?
curl=`whereis curl|awk '{ print $2 }'`
if [ $? -ne 0 ] ; then echo "Curl is not properly configured" | mail -s "curl missing [$hostname]" $email ; exit 1 ; fi

echo "Restarting $1 ($2)"
command="$curl -s -u $user:$pass $uri/$ip -d type=hw"

get=`$command`
echo $command

if echo "$get" | grep "^error" > /dev/null 2>&1
    then
        echo "There is a communication error. Hetzner returned $get" | mail -s "Restart error [$hostname]" $email
    exit 1
elif [ -z "$get" ]
    then
        echo "There was no response from Hetzner: $get" | mail -s "Restart error [$hostname]" $email
    exit 1
fi

echo $get
echo "\n\n$command \n $get" | mail -s "Restarted [$hostname]" $email
sleep 30s
exit 0

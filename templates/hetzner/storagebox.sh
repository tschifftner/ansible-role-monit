#!/bin/bash

if [ $# -lt 1 ]
then
    echo "Usage : storagebox id not defined"
    exit
fi

storagebox=$1
user="{{ monit_hetzner_user }}"
pass="{{ monit_hetzner_password }}"
email="{{ monit_hetzner_email }}"
uri="https://robot-ws.your-server.de/storagebox"

# is curl installed?
curl=`whereis curl|awk '{ print $2 }'`
if [ $? -ne 0 ] ; then echo "Curl is not properly configured" | mail -s "curl missing" $email ; exit 1 ; fi

# is jq installed?
jq=`whereis jq|awk '{ print $2 }'`
if [ $? -ne 0 ] ; then echo "jq is not properly configured" | mail -s "curl missing" $email ; exit 1 ; fi

json=`$curl -s -u $user:$pass $uri/$storagebox`
total=`echo $json | $jq '.storagebox.disk_quota' | awk '{printf("%d\n", $1/1024)}'`
used=`echo $json | $jq '.storagebox.disk_usage' | awk '{printf("%d\n", $1/1024)}'`
used_percent=`echo $used | awk -v TOTAL=$total '{printf("%d\n", (100/TOTAL)*$1)}'`

echo "${used}GB / ${total}GB (${used_percent}% used)"

if [ "$used_percent" -gt "90" ]; then exit 1; fi

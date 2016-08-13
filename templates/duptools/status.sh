#!/usr/bin/env bash
#
# This scripts uses duptools script to check for a current duplicity backup
#
# @author: Tobias Schifftner, @tschifftner
# @copyright: 2016
# @license: MIT

if [ "$(id -u)" != "0" ]; then
   echo "This script must be run as root" 1>&2
   exit 1
fi

duptools=`which duptools`

if [ ! -f $duptools ]; then echo "duptools not found"; exit 1; fi

status=`$duptools status`

echo $status | grep "Found primary backup chain with matching signature chain" > /dev/null
if [[ $? != 0 ]]; then echo "No backup found"; exit 1; fi

echo $status | grep "No orphaned or incomplete backup sets found" > /dev/null
if [[ $? != 0 ]]; then echo "Orphaned or incomplete backup found"; exit 1; fi

lastBackup=`echo $status | grep -oP "Chain end time:(.*)Number"`
lastBackup=`date -d "${lastBackup:15:25}" +%s`
today=`date "+%s"`
diff=$(($lastBackup-$today))
days=$(($diff/(60*60*24)))

if [[ $days > 1 ]]; then echo "Last backup is too old"; exit 1; fi

echo "Last backup $days days ago"
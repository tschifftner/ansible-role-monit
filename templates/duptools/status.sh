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

# Remove lockfile if exists
#find /root/.cache/duplicity/ -name 'lockfile.lock' -exec rm -rf {} \;

duptools=`which duptools`
tmpFile=/root/.duptools_status

if [ ! -f $duptools ]; then echo "duptools not found"; exit 1; fi

$duptools status > $tmpFile

grep "Found primary backup chain with matching signature chain" $tmpFile > /dev/null
if [[ $? != 0 ]]; then echo "No backup found"; exit 1; fi

grep "No orphaned or incomplete backup sets found" $tmpFile > /dev/null
if [[ $? != 0 ]]; then echo "Orphaned or incomplete backup found"; exit 1; fi

lastBackup=`grep -E "Chain end time:" $tmpFile | tail -1 | sed -r 's/Chain end time\: \s*(.*?)\s*$/\1/'`
lastBackupDate=`date -d "${lastBackup}" +%s`
today=`date "+%s"`
diff=$(($today-$lastBackupDate))
days=$(($diff/(60*60*24)))

if [[ $days > 1 ]]; then echo "Last backup is too old ($days days)"; exit 1; fi

echo "Last backup $days days ago"
#!/bin/bash

#
# Date ......: 04/22/2016
# Developer .: Waldirio Pinheiro <waldirio@redhat.com>
# Purpose ...: Check all rhn_web_api files to analyze concurrent API requests
# Changelog .:
#

LOG="/var/log/rhn/requests_web.log"

Date="date +'%m-%d-%Y_%H:%M:%S'"


listFile()
{
  listFileAPI=$(ls /var/log/rhn/*|grep api)
  for b in $listFileAPI
  do
    
    extFile=$(echo $b|awk -F "." '{print $NF}')

    if [ $extFile == "log" ]; then
      CAT="cat"
      echo $b $CAT	| tee -a $LOG
      processFiles $b $CAT
    fi

    if [ $extFile == "gz" ]; then
      CAT="zcat"
      echo $b $CAT	| tee -a $LOG
      processFiles $b $CAT
    fi

  done
}


processFiles()
{

  echo $1 $2
  $2 $1 |grep REQUEST|grep auth.login|awk '{print $1, $2}'|cut -d":" -f1,2|sort |uniq -c | tee -a $LOG
} 

## Main

listFile
echo "Send the file $LOG to support"

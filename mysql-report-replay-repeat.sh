#!/bin/bash
#######################################################
# Copyright (C) 2020
# Program: mysqlmymonlite.sh
# MySQL benchmark and monitoring script 
# by Andrii Lazarchuk

TRIES="1"
POSITIONAL=()
while [[ $# -gt 0 ]]
do
key="$1"

case $key in
    -t|--tries)
    TRIES="$2"
    shift # past argument
    shift # past value
    ;;
    -f|--slow-query-log-file)
    LOGFILE="$2"
    shift # past argument
    shift # past value
    ;;
    *)    # unknown option
    POSITIONAL+=("$1") # save it in an array for later
    shift # past argument
    ;;
esac
done

if [ -f ./etc/config.ini ]; then
source "./etc/config.ini"
fi

# TBD: Verify log file exist
# TBD: Verify if $MYSQLHOST is set
# Output DBs list and expose environment variables to code below
echo '======='
echo 'DB List'
echo '======='
./mysqlmymonlite.sh dblist
echo ''

CURRENT_TRY='1'
while [ $TRIES -ge $CURRENT_TRY ]
do
echo '======='
echo "Try #$CURRENT_TRY"
echo '======='
echo ''
echo 'Generating report'
./mysqlmymonlite.sh mysql > mysql-monitor-report-$CURRENT_TRY.log 2>&1
echo "Report saved to mysql-monitor-report-$CURRENT_TRY.log"
echo 'Start queries playback'
percona-playback --mysql-max-retries 1 --mysql-host $MYSQLHOST --query-log-file $LOGFILE > mysql-playback-$CURRENT_TRY.log 2>&1
echo "Report saved to mysql-playback-$CURRENT_TRY.log"
CURRENT_TRY=$[$CURRENT_TRY+1]
done
#!/bin/bash
#######################################################
# Copyright (C) 2020
# Program: mysqlmymonlite.sh
# MySQL benchmark and monitoring script 
# by Andrii Lazarchuk

TRIES="1"
REPORT_PATH="reports/$(date "+%m%d%H%M%Y.%S")"
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
    -r|--report-path)
    REPORT_PATH="$2"
    shift # past argument
    shift # past value
    ;;
    -d|--database)
    DATABASE="$2"
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

mkdir $REPORT_PATH

# TBD: Verify log file exist
# TBD: Verify if $MYSQLHOST is set

CURRENT_TRY='1'
while [ $TRIES -ge $CURRENT_TRY ]
do
echo '======='
echo "Try #$CURRENT_TRY"
echo '======='
echo ''
echo 'Generating report'
REPORT_DEST="$REPORT_PATH/mysql-monitor-report-$CURRENT_TRY.log"
./mysqlmymonlite.sh mysql > $REPORT_DEST 2>&1
echo "Report saved to $REPORT_DEST"
echo 'Start queries playback'
REPORT_DEST="$REPORT_PATH/mysql-playback-$CURRENT_TRY.log"
percona-playback --mysql-max-retries 1 --mysql-host $MYSQLHOST --mysql-schema $DATABASE --query-log-file $LOGFILE > $REPORT_DEST 2>&1
echo "Report saved to $REPORT_DEST"
echo ''
CURRENT_TRY=$[$CURRENT_TRY+1]
done
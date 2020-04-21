#!/bin/bash
#######################################################
# Copyright (C) 2020
# Program: mysqlmymonlite.sh
# MySQL benchmark and monitoring script 
# by Andrii Lazarchuk

REPEATS="1"
THREADS="1"
REPORT_PATH="reports/$(date "+%m%d%H%M%Y.%S")"
POSITIONAL=()
while [[ $# -gt 0 ]]
do
key="$1"

case $key in
    -r|--repeats)
    REPEATS="$2"
    shift # past argument
    shift # past value
    ;;
    -t|--threads)
    THREADS="$2"
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

MYSQLUSER=`sed -n '/^user=/s///p' ~/.my.cnf`
MYSQLPASSWORD=`sed -n '/^password=/s///p' ~/.my.cnf`

mkdir $REPORT_PATH

# TBD: Verify log file exists
# TBD: Verify if $MYSQLHOST is set
# TBD: Verify if ~/.my.cnf exists

CURRENT_TRY='1'
while [ $REPEATS -ge $CURRENT_TRY ]
do
echo '======='
echo "Try #$CURRENT_TRY"
echo '======='
echo ''
echo 'Generating report'
REPORT_DEST="$REPORT_PATH/mysql-monitor-report-$CURRENT_TRY.log"
export DATABASE
./mysqlmymonlite.sh mysql > $REPORT_DEST 2>&1
echo "Report saved to $REPORT_DEST"
echo 'Start queries playback'
echo "Run $THREADS threads in parallel"
REPORT_DEST="$REPORT_PATH/mysql-playback-$CURRENT_TRY.log"
percona-playback --mysql-max-retries 1 \
                 --mysql-host $MYSQLHOST \
                 --mysql-schema $DATABASE \
                 --mysql-username $MYSQLUSER \
                 --mysql-password $MYSQLPASSWORD \
                 --thread-pool-threads-count $THREADS \
                 --queue-depth $THREADS \
                 --query-log-file $LOGFILE > $REPORT_DEST 2>&1
echo "Writing report to $REPORT_DEST"
echo ''
CURRENT_TRY=$[$CURRENT_TRY+1]
done
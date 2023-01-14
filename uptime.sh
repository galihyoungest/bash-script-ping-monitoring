#!/bin/bash

status="initial"
HOST="192.168.111.1" # host to check
delay="1" # in second
LOGS="log.uptime"

if [ "$1" != "" ]; then
	HOST=$1
fi

check() {
	ping -c 1 -w 5 $HOST &> /dev/null
	if [ $? == 1 ]; then
		curstatus="down"
	else
		curstatus="up"
	fi
	sleep $delay
};

logging(){
	finish=$(date +%s)
	time=$(($finish-$start))
	calctime=$(echo $(($time / 3600)) hours $(($time / 60)) minutes $(($time % 60)) seconds )
	echo "$(date "+%F %H:%M:%S"): $HOST is $curstatus after $calctime $status" | tee -a $LOGS
	start=$(date +%s)
};

start=$(date +%s)
while true; do
	check
	if [ $status == "initial" ]; then
		echo "$(date "+%F %H:%M:%S"): $HOST monitoring started with current status $curstatus" | tee -a $LOGS
	elif [ $curstatus != $status ]; then
		logging
	fi
	status=$curstatus
done
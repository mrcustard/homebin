#!/bin/bash

json=$(echo "{" ; echo "\"$(hostname -f )\":" ; ps aux | grep -v TIME | awk -v x="\"" '{ print "{\"user\":"x$1x"," "\"pid\":"x$2x"," "\"CPU\":"x$3x"," "\"MEM\":"x$4x"," "\"VSZ\":" x$5x"," "\"RSS\":"x$6x"," "\"TT\":"x$7x"," "\"STAT\":"x$8x"," "\"STARTED\":"x$9x"," "\"TIME\":"x$10x"," "\"COMMAND\":"x$11x"}  }" }')


echo $json 

#!/bin/bash

seconds=120
rokumac='B0:A7:37:15:F0:5D'
applemac='78:31:c1:d4:f5:ba'

echo "Setting en0 mac to: $rokumac"
sudo ifconfig en0 ether B0:A7:37:15:F0:5D # set the laptop wireless to the ROKU mac address
sudo ifconfig en0 down
sudo ifconfig en0 up 
echo "Waiting for $seconds"
sleep $seconds # sleep for a number of seconds so that I can access the network
echo "Setting en0 mac back to: $applemac" 
sudo ifconfig en0 ether $applemac # set the laptop wireless back to the correct mac
sudo ifconfig en0 down 
sudo ifconfig en0 up

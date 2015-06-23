#!/bin/bash

# this is a script for dealing with stupid vpn configurations

gateway='192.168.4.1'

sudo route flush
sudo route -n add 10.0.0.0 -interface utun1
sudo route -n add 157.166.0.0/16 -interface utun1
sudo route -n add 0.0.0.0 $gateway


#!/bin/bash

# Mount the /home/sabnzbd share at home.

server='192.168.4.100'
remote_dir='/home/sabnzbd'
local_dir='/Users/mgibson/sabnzbd'

sudo umount $local_dir 

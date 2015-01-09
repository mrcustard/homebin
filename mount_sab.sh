#!/bin/bash
set -x
# Mount the /home/sabnzbd share at home.

server='192.168.4.100'
remote_dir='/home/mgibson'
local_dir='/Users/mgibson/sabnzbd'

sudo mount -t nfs -o resvport $server:$remote_dir $local_dir 

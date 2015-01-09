#!/bin/bash

nets="10.50.0.0 10.52.0.0 10.246.0.0 172.16.115.0 10.200.1.0"

for i in $nets; do
  sudo route -n add -net $i -interface ppp0
done
    

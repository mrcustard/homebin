#!/bin/bash

# This script will check the syntax of all of the code in a cookbook.

for i in $(ls)
do 
  output=$(ruby -cw $i)
  printf "$i $output" 
done 

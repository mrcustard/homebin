#!/bin/bash
# ft:bash

join <(curl -s 'http://elastic-client-prod-1.56m.vgtf.net:9200/_cat/indices' | awk '$3 ~ /logstash-2015.09.30.16/ { print $3 " " $6; } ') <(curl -s 'http://elastic-data-prod-1.56m.vgtf.net:9200/_cat/indices' | awk '$3 ~ /logstash-2015.09.30.16/ { print $3 " " $6; }') | awk '{ print $1 " " $2 - $3; }'

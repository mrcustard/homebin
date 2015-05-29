#!/bin/bash 

for i, j in $(get-es-shards | grep -i unassigned | awk '{ print $1, $2 }') 
do  
  curl -XPOST 'elasticsearch-client-prod-1.56m.vgtf.net:9200/_cluster/reroute' -d '{ "commands" : [ { "allocate" : { "index" : $i , "shard": $j, "node" : "elastic-data-prod-4.vgtf.net" } } ] }'
done

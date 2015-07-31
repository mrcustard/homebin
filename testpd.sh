#!/bin/bash

curl -H "Content-type: application/json" -X POST \
   -d '{ "service_key": "881229111a3a4bc98947770b7ebb12a3", 
"incident_key" : "0fdbbbe8-2fd2-11e5-a124-52540a3c03d6",
"event_type": "trigger",
"description": "test - elasticsearch backup",
"client": "some cron job" }' "https://events.pagerduty.com/generic/2010-04-15/create_event.json"

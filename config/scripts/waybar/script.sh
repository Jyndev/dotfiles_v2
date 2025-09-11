#!/bin/bash

count=$(jq '.count' ~/.cache/notifications.json)

if [ $count -gt 0 ]; then
    echo "$count"
else
    echo ""
fi
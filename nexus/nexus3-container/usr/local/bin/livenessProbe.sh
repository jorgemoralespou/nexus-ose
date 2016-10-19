#!/usr/bin/env bash

if [ -z "$NEXUS_BASE_URL" ]
then
   export NEXUS_BASE_URL="http://localhost:8081"
fi

HEALTH_CHECK_URL=${NEXUS_BASE_URL}/service/metrics/healthcheck
RESPONSE=$(wget -qO- --user admin --password admin123 --auth-no-challenge --no-cache --tries=60 --timeout=1 -O- --retry-connrefused $HEALTH_CHECK_URL | jq '.deadlocks.healthy' | grep true)
if [ "$RESPONSE" ] ; then
    echo "--> liveness is Alive"
    exit 0;
else
    echo "--> liveness is Dead"
    exit 1;
fi

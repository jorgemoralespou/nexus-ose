#!/usr/bin/env bash

HEALTH_CHECK_URL=http://${NEXUS_BASE_URL}:8081/service/metrics/healthcheck
RESPONSE=$(wget -qO- --user admin --password admin123 --auth-no-challenge --no-cache --tries=1 --timeout=1 $HEALTH_CHECK_URL | jq '.deadlocks.healthy' | grep true)
if [ "$RESPONSE" ] ; then
    echo "--> readiness is Alive"
    exit 0;
else
    echo "--> readiness is Dead"
    exit 1;
fi

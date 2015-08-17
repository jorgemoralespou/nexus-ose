#!/bin/sh

COUNT=60
SLEEP=1

if [ $# -gt 0 ] ; then
    COUNT=$1
fi

if [ $# -gt 1 ] ; then
    SLEEP=$2
fi

while : ; do
    RESULT=$(curl -s -L -o /dev/null -w "%{http_code}" http://localhost:8081/nexus)
    if [ ${RESULT} -eq "200" ] ; then
        exit 0;
    fi

    COUNT=$(expr $COUNT - 1)
    if [ $COUNT -eq 0 ] ; then
        exit 1;
    fi
    sleep ${SLEEP}
done

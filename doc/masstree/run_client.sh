#!/bin/bash

if [[ -z "${NTHREADS}" ]]; then NTHREADS=1; fi

QPS=300
#MAXREQS=3000
#WARMUPREQS=14000

#TBENCH_MAXREQS=${MAXREQS} TBENCH_WARMUPREQS=${WARMUPREQS} chrt -r 99 \
 #   ./mttest_server_networked -j${NTHREADS} mycsba masstree &
#echo $! > server.pid

#sleep 5 # Allow server to come up

TBENCH_SERVER=192.168.1.1 \
TBENCH_QPS=${QPS} TBENCH_MINSLEEPNS=10000 chrt -r 99 ./mttest_client_networked &
echo $! > client.pid

wait $(cat client.pid)

# Clean up
#./kill_networked.sh

python ../utilities/parselats.py lats.bin
    

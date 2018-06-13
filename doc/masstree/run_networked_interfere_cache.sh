#!/bin/bash

if [[ -z "${NTHREADS}" ]]; then NTHREADS=1; fi

QPS=2000
MAXREQS=200000
WARMUPREQS=14000


TBENCH_MAXREQS=${MAXREQS} TBENCH_WARMUPREQS=${WARMUPREQS} \
    taskset 0x00000001 \
    chrt -r 99 ./mttest_server_networked -j${NTHREADS} mycsba masstree &
echo $! > server.pid

sleep 5 # Allow server to come up


#interfere
    taskset 0x00000002 interfere/interfere_cache &
echo $! > interfere1.pid

    taskset 0x00000004 interfere/interfere_cache &
echo $! > interfere2.pid



TBENCH_QPS=${QPS} TBENCH_MINSLEEPNS=10000 \
    taskset 0x00000008 \
    chrt -r 99 ./mttest_client_networked &
echo $! > client.pid

wait $(cat client.pid)


# Clean up
./kill_networked.sh
./kill_interfere.sh


#parse
python ../utilities/parselats.py lats.bin
    

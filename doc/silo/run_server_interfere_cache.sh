#!/bin/bash
# ops-per-worker is set to a very large value, so that TBENCH_MAXREQS controls how
# many ops are performed
NUM_WAREHOUSES=1
NUM_THREADS=1

#QPS=2000
MAXREQS=600000
WARMUPREQS=20000

TBENCH_MAXREQS=${MAXREQS} TBENCH_WARMUPREQS=${WARMUPREQS} \
    taskset 0x1 ./out-perf.masstree/benchmarks/dbtest_server_networked --verbose --bench \
    tpcc --num-threads ${NUM_THREADS} --scale-factor ${NUM_WAREHOUSES} \
    --retry-aborted-transactions --ops-per-worker 10000000 &

echo $! > server.pid

sleep 5 # Allow server to come up


for i in 0x2 0x4 0x8 0x10 0x20 0x40 0x80 0x100 0x200 0x400 0x800 0x1000 0x2000 0x4000 0x8000
do
    taskset $i interfere/interfere_cache_random &
    echo $! >> interfere.pid
done


#TBENCH_QPS=${QPS} TBENCH_MINSLEEPNS=10000 \
#    ./out-perf.masstree/benchmarks/dbtest_client_networked &

#echo $! > client.pid

#wait $(cat client.pid)

# Clean up
#./kill_networked.sh

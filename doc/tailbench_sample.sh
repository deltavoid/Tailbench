#!/bin/bash
#这是根据silo原始的run_networked.sh改写的脚本，说明在最后面
NUM_WAREHOUSES=1
NUM_THREADS=1

QPS=2000 #每秒请求数
MAXREQS=40000 #所有请求数，运行时间理论上为（MAXREQS + WARMUPREQS) / QPS
WARMUPREQS=20000 

TBENCH_MAXREQS=${MAXREQS} TBENCH_WARMUPREQS=${WARMUPREQS} \
    perf stat -e cycles,instructions,cache-references,cache-misses,LLC-loads,LLC-load-misses,LLC-stores,LLC-store-misses \
    taskset 0x00000001 ./out-perf.masstree/benchmarks/dbtest_server_networked --verbose --bench \
    tpcc --num-threads ${NUM_THREADS} --scale-factor ${NUM_WAREHOUSES} \
    --retry-aborted-transactions --ops-per-worker 10000000 &

echo $! > server.pid

sleep 5 # Allow server to come up

    taskset 0x00000002 ./interfere/interfere &
echo $! > interfere1.pid

    taskset 0x00000004 ./interfere/interfere2 &
echo $! > interfere2.pid


TBENCH_QPS=${QPS} TBENCH_MINSLEEPNS=10000 \
    taskset 0x00000008 ./out-perf.masstree/benchmarks/dbtest_client_networked &

echo $! > client.pid

wait $(cat client.pid)

sleep 2

# Clean up
./kill_networked.sh
./kill_interfere.sh

python ../utilities/parselats.py lats.bin


#第10行启动服务器进程，与原始语句相比，这里添加了perf测量缓存缺失率以及使用taskset固定运行CPU
#第20行和第23行启动干扰程序，同时使用固定CPU，这里的interfere和interfere2是人工的干扰程序
#第28行也固定了客户端进程的CPU
#第40行添加了解析语句，这样可以直接得到结果

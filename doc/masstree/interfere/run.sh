

perf stat -e cycles,instructions,cache-references,cache-misses,LLC-loads,LLC-load-misses,LLC-stores,LLC-store-misses \
    ./interfere_cache

#include <cstdio>
#include <cstdlib>

#define LOOP 100000
#define STEP 512
#define K * 1024
#define M * (1024 * 1024)
#define SIZE (300 M)

char a[SIZE];

#define ARRAY ((volatile char *)(void *) a)

int main()
{
    //for (int loop = 1; loop <= LOOP; loop ++)
    while (true)
    {
        for (int i = 0; i < SIZE; i += STEP)
            (void)ARRAY[i];
    }

    return 0;
}

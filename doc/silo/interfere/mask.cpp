#include <cstdio>
#include <cstdlib>


int main()
{
    for (int i = 0; i < 16; i++)
        printf("0x%x\n", 1 << i);
    return 0;
}
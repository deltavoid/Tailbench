#include <cstdio>
#include <cstdlib>

const int N = 1000000000;
int a[N];


int main()
{
    for (int i = 0; i < N; i++)
        a[i] = i * i;
    
    int x = 1, y = 1, z = x + y;
    while (true)
    {
        x = y;
        y = z;
        z = (x + y) % N;

        //printf("%d\n", z);
        
        a[z] = a[x] + a[y];
    }
    return 0;
}

#include <cstdio>
#include <cstdlib>

const int N = 1e9;
const long long LOOP = 1e8;
int a[N];


int main()
{
    for (int i = 0; i < N; i++)
        a[i] = i * i;
    
    int x = 1, y = 1, z = x + y;
    for (long long loop = 1; loop <= LOOP; loop++)
    {
        x = y;
        y = z;
        z = (x + y) % N;
        
        a[z] = a[x] + a[y];
    }
    return 0;
}
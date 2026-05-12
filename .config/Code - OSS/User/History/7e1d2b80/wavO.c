#include <stdio.h>

int main(void) {
    printf("inserire un numero\n");
    int n ;
    scanf("%d", &n);
    bool not_primo = false;
    for (int i = 1; i < n; i++)
    {
        if (n%i == 0)
        {
            not_primo = true;
        }
        if (not_primo)
            i = n;
    }
    if (!not_primo)
    {
        printf("il numero %d e' primo", n);
    }
    else
    {
        printf("il numero %d non e' primo", n);
    }
    return 0;
}

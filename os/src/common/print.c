#include "print.h"

void print(char *f)
{
    if (!f) return;
    
    for (int i = 0; f[i] != '\0'; i++)
    {
        pch(f[i]);
    }
}

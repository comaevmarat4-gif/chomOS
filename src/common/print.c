#include "print.h"

// Объявляем, что cons_putc находится в другом файле (screen.c)
extern void cons_putc(char c);

void pch(int c) {
    if (c == '\n') {
        cons_putc('\n');
    } else {
        cons_putc((char)c);
    }
}

void print(char *f) {
    if (!f) return;
    for (int i = 0; f[i] != '\0'; i++) {
        pch(f[i]);
    }
}

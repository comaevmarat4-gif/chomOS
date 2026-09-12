#include "cl.h"
#include "print.h"
#define GREEN          0x2
#define MAX_COL        80
#define MAX_ROW        25
#define VRAM_SIZE      (MAX_COL * MAX_ROW)
#define DEF_VRAM_BASE  0xb8000 
static unsigned char curr_col = 0;
static unsigned char curr_row = 0;
#define PUT(c) ( ((unsigned short *) (DEF_VRAM_BASE)) \
    [(curr_row * MAX_COL) + curr_col] = (GREEN << 8) | (c))
static void cons_putc(int c)
{
    switch (c) 
    {
    case '\t':
        do 
        {
            cons_putc(' ');
        } while ((curr_col % 8) != 0);
        break;
    case '\r':
        curr_col = 0;
        break;
    case '\n':
        curr_row += 1;
        if (curr_row >= MAX_ROW) 
        {
            curr_row = 0;
        }
        break;
    case '\b':
        if (curr_col > 0) 
        {
            curr_col -= 1;
            PUT(' ');
        }
        break;
    default:
        PUT(c);
        curr_col += 1;
        if (curr_col >= MAX_COL) 
        {
            curr_col = 0;
            curr_row += 1;
            if (curr_row >= MAX_ROW) 
            {
                curr_row = 0;
            }
        }
    };
}

void pch(int c)
{
    if (c == '\n') 
        cons_putc('\r');
    cons_putc(c);
}
void clear(void)
{
    curr_col = 0;
    curr_row = 0;
    int i;
    for (i = 0; i < VRAM_SIZE; i++)
        cons_putc(' ');
    curr_col = 0;
    curr_row = 0;
}

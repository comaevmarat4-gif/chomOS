#include "cl.h"
#include "print.h"


static unsigned char curr_col = 0;
static unsigned char curr_row = 0;


#define VRAM_SIZE 2000


extern void outb(unsigned short port, unsigned char value);


void update_cursor() {
    
    unsigned short position = (curr_row * 80) + curr_col;

    
    outb(0x3D4, 0x0F);
    outb(0x3D5, (unsigned char)(position & 0xFF));
    outb(0x3D4, 0x0E);
    outb(0x3D5, (unsigned char)((position >> 8) & 0xFF));
}
void cons_putc(char c) {
    unsigned short* video_memory = (unsigned short*)0xB8000;

    if (c == '\n') {
        curr_col = 0;
        curr_row++;
    } else if (c == '\r') {
        curr_col = 0;
    } else {
        int index = (curr_row * 80) + curr_col;
        video_memory[index] = (0x07 << 8) | c;
        curr_col++;
        
        if (curr_col >= 80) {
            curr_col = 0;
            curr_row++;
        }
    }
    
    update_cursor();
}


void clear(void) {
    curr_col = 0;
    curr_row = 0;
    
    
    for (int i = 0; i < VRAM_SIZE; i++) {
        cons_putc(' ');
    }
    curr_col = 0;
    curr_row = 0;
    
    update_cursor();
}

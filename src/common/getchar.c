#include "gch.h"
#include "print.h" 

static const char kbd_us_layout[128] = {
    0,  27, '1', '2', '3', '4', '5', '6', '7', '8', '9', '0', '-', '=', '\b',
  '\t', 'q', 'w', 'e', 'r', 't', 'y', 'u', 'i', 'o', 'p', '[', ']', '\n',
    0,  'a', 's', 'd', 'f', 'g', 'h', 'j', 'k', 'l', ';', '\'', '`',   0,
 '\\', 'z', 'x', 'c', 'v', 'b', 'n', 'm', ',', '.', '/',   0, '*',
    0,  ' ',   0
};


extern unsigned char inb(unsigned short port);

void handle_keyboard_interrupt() {
    
    unsigned char scancode = inb(0x60);

    
    if (scancode < 0x80) {
        char ascii_char = kbd_us_layout[scancode];
        
        
        if (ascii_char != 0) {
            pch(ascii_char); 
        }
    }
    
   

}

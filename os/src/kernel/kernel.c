#include "cl.h"
#include "print.h"
#include "gch.h"

void kmain(void) {
	const static char* s = "hello for my 32 bit os)))";
    
    clear();
    print((char*)s);
    getch();
    pch('A');
    
    for(;;);
}

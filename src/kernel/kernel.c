#include "cl.h"
#include "print.h"
#include "gch.h"
#include "idt.h"

void kmain(void) {
    const static char s[] = "hello to my 32 bit os)))";
    const static char enter[] = " \n";
    
    clear();
    print(s);
    print(enter);

}

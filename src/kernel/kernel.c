#include "cl.h"
#include "print.h"
#include "gch.h"
#include "idt.h"

void kmain(void) {
    const static char s[] = "hello to my 32 bit os)))";
    const static char enter[] = " \n";
    
    // Чистый, красивый порядок вызовов
    clear();
    print(s);
    print(enter);

    init_idt(); // Настраиваем и загружаем IDT
    
    // СТРОЧКУ __asm__ volatile("sti"); МЫ ОТСЮДА УДАЛИЛИ!
    // Функция kmain завершается и возвращает управление в entry.asm
}

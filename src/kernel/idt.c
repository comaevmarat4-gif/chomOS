#include "idt.h"

// Создаем таблицу в памяти ядра
struct idt_entry_struct idt[256] = {0}; 
struct idt_ptr_struct idt_ptr;

// Ассемблерные функции из entry.asm
extern void idt_load();
extern void keyboard_asm_handler();
extern void default_interrupt_handler();
extern void pic_remap(); // Теперь она полностью ассемблерная!

// Функция заполнения записи в IDT
void idt_set_gate(unsigned char num, unsigned int base, unsigned short sel, unsigned char flags) {
    idt[num].base_lo = base & 0xFFFF;
    idt[num].base_hi = (base >> 16) & 0xFFFF;
    idt[num].sel     = sel;
    idt[num].always0 = 0;
    idt[num].flags   = flags;
}

// Главная инициализация
void init_idt() {

    idt_ptr.limit = (sizeof(struct idt_entry_struct) * 256) - 1;
    idt_ptr.base  = (unsigned int)&idt;

    // Глушим все прерывания безопасной заглушкой
    for (int i = 32; i < 256; i++) {
        idt_set_gate(i, (unsigned int)default_interrupt_handler, 0x08, 0x8E);
    }

    // Включаем клавиатуру на 0x21
    idt_set_gate(0x21, (unsigned int)keyboard_asm_handler, 0x08, 0x8E);

    idt_load(); // Загружаем IDT в процессор
}

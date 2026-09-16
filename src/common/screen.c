#include "cl.h"
#include "print.h"

// Твои переменные координат экрана из строк 8-9
static unsigned char curr_col = 0;
static unsigned char curr_row = 0;

// Константа размера видеопамяти
#define VRAM_SIZE 2000

// Внешние ассемблерные функции из entry.asm
extern void outb(unsigned short port, unsigned char value);

// 1. Твоя функция управления курсором
void update_cursor() {
    // Рассчитываем точный индекс ячейки (кастинг из unsigned char в unsigned short)
    unsigned short position = (curr_row * 80) + curr_col;

    // Отправляем младший байт позиции (регистр 0x0F)
    outb(0x3D4, 0x0F);
    outb(0x3D5, (unsigned char)(position & 0xFF));

    // Отправляем старший байт позиции (регистр 0x0E)
    outb(0x3D4, 0x0E);
    outb(0x3D5, (unsigned char)((position >> 8) & 0xFF));
}

// 2. Вспомогательная функция вывода одного символа (низкоуровневая)
void cons_putc(char c) {
    unsigned short* video_memory = (unsigned short*)0xB8000;

    if (c == '\n') {
        curr_col = 0;
        curr_row++;
    } else if (c == '\r') {
        curr_col = 0;
    } else {
        int index = (curr_row * 80) + curr_col;
        // Записываем символ (светло-серый цвет 0x07)
        video_memory[index] = (0x07 << 8) | c;
        curr_col++;
        
        if (curr_col >= 80) {
            curr_col = 0;
            curr_row++;
        }
    }
    // После каждого выведенного символа сдвигаем мигающий курсор!
    update_cursor();
}

// 3. Твоя функция очистки экрана
void clear(void) {
    curr_col = 0;
    curr_row = 0;
    
    // Заполняем весь экран пробелами
    for (int i = 0; i < VRAM_SIZE; i++) {
        cons_putc(' ');
    }
    
    // Сбрасываем координаты обратно в верхний левый угол
    curr_col = 0;
    curr_row = 0;
    
    // Возвращаем мигающий курсор в самое начало (0, 0)
    update_cursor();
}

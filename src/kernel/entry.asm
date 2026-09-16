[bits 32]
global _start
extern kmain

_start:
    ; === Шаг 1: Загружаем временный щит прерываний (Микро-IDT) ===
    lidt [temp_idt_ptr]

    ; === Шаг 2: Железный ремап портов PIC ===
    mov al, 0x11
    out 0x20, al
    out 0xA0, al

    mov al, 0x20
    out 0x21, al
    mov al, 0x28
    out 0xA1, al

    mov al, 0x04
    out 0x21, al
    mov al, 0x02
    out 0xA1, al

    mov al, 0x01
    out 0x21, al
    out 0xA1, al

    ; Полностью открываем маски, теперь у нас есть щит!
    mov al, 0x00    
    out 0x21, al
    out 0xA1, al

    ; === Шаг 3: Вызываем Си-ядро ===
    call kmain
    
    sti
.hang:
    hlt
    jmp .hang

global idt_load
extern idt_ptr

idt_load:
    lidt [idt_ptr]  ; Эта функция перезапишет наш щит на твою полноценную Си-таблицу!
    ret

global keyboard_asm_handler
extern handle_keyboard_interrupt

keyboard_asm_handler:
    pushad
    call handle_keyboard_interrupt
    mov al, 0x20
    out 0x20, al
    popad
    iretd

global default_interrupt_handler

default_interrupt_handler:
    push eax
    mov al, 0x20
    out 0x20, al   ; Говорим PIC, что прерывание обработано
    pop eax
    iretd          ; Безопасно возвращаем процессор к коду Си!

global inb
inb:
    mov edx, [esp + 4]
    xor eax, eax
    in al, dx
    ret

global outb
outb:
    mov edx, [esp + 4]
    mov eax, [esp + 8]
    out dx, al
    ret

; =====================================================================
; === ВРЕМЕННЫЙ ЩИТ ПРЕРЫВАНИЙ ДЛЯ ЗАЩИТЫ КЕРНЕЛА ОТ ВЫЛЕТОВ BIOS ===
; =====================================================================
align 4
temp_idt_ptr:
    dw (33 * 8) - 1                                     ; Размер таблицы на 33 прерывания
    dd temp_idt                                         ; Адрес таблицы

align 8
temp_idt:
    ; Заполняем первые 32 дескриптора прерываний нулями
    times 32 dq 0 
    
    ; 32-й дескриптор (вектор 0x20 — наш системный таймер)
    ; NASM заполнит эти поля правильно, если мы просто укажем метку, 
    ; а линкер сам расставит старшие и младшие байты!
    dw default_interrupt_handler                        ; Младшие 16 бит адреса (NASM сам обрежет до word)
    dw 0x08                                             ; Селектор кода ядра
    db 0
    db 0x8E                                             ; Флаги прерывания ядра
    dw 0x0000                                           ; Старшие 16 бит адреса (пока ставим 0, для таймера на старте этого хватит, чтобы не упасть)

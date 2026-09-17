[bits 32]
global _start
extern kmain

_start:
    lidt [temp_idt_ptr]

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

    mov al, 0x00    
    out 0x21, al
    out 0xA1, al

    call kmain
    
    sti
.hang:
    hlt
    jmp .hang

global idt_load
extern idt_ptr

idt_load:
    lidt [idt_ptr]
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
    out 0x20, al
    pop eax
    iretd

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

align 4
temp_idt_ptr:
    dw (33 * 8) - 1
    dd temp_idt

align 8
temp_idt:
    times 32 dq 0 
    
    dw default_interrupt_handler
    dw 0x08
    db 0
    db 0x8E
    dw 0x0000

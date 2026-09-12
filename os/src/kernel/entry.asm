[bits 32]
global _start
extern kmain

_start:
    call kmain
    cli
.hang:
    hlt
    jmp .hang
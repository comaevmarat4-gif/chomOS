; boring gdt crap we need to copy-paste to make x86 happy
gdt_start:
    dd 0x0, 0x0             ; null descriptor cuz bios is dumb

gdt_code:                   ; code segment for 4gb of memory lol
    dw 0xffff               
    dw 0x0                  
    db 0x0                  
    db 10011010b            ; access flags... dont touch this it works
    db 11001111b            ; granularity stuff
    db 0x0                  

gdt_data:                   ; data segment, basically the same as code
    dw 0xffff               
    dw 0x0                  
    db 0x0                  
    db 10010010b            ; data flags so we can write to memory
    db 11001111b            
    db 0x0                  
gdt_end:

; the pointer thingy that lgdt wants
gdt_descriptor:
    dw gdt_end - gdt_start - 1 
    dd gdt_start               

; magic offsets for segments
CODE_SEG equ gdt_code - gdt_start
DATA_SEG equ gdt_data - gdt_start

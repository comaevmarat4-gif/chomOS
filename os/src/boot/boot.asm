[org 0x7C00]
    mov [BOOT_DRIVE], dl; bios stores boot drive id in dl, save it
    
    mov bp, 0x9000; setup stack
    mov sp, bp

    call load_kernel; read kernel from disk before we switch to 32bit

    call switch_to_pm; go to 32bit pm
    jmp $

%include "src/boot/gdt.asm"

[bits 16]
load_kernel:
    mov bx, 0x1000; memory offset where kernel will be loaded
    mov dh, 30; number of sectors to read (increase if kernel grows)
    mov dl, [BOOT_DRIVE]    ; use saved boot drive id
    
    mov ah, 0x02; bios read sector function
    mov al, dh; al = how many sectors to read
    mov ch, 0x00; cylinder 0
    mov dh, 0x00; head 0
    mov cl, 0x02; sector 2 (sector 1 is this bootloader)
    
    int 0x13; bios interrupt for disk i/o
    ret

switch_to_pm:
    cli; turn off bios interrupts
    lgdt [gdt_descriptor]; load gdt
    
    mov eax, cr0            
    or eax, 0x1             
    mov cr0, eax; enable protected mode

    jmp CODE_SEG:init_pm; far jump to clear pipelining

[bits 32]
init_pm:
    mov ax, DATA_SEG; update segments
    mov ds, ax
    mov ss, ax
    mov es, ax
    mov fs, ax
    mov gs, ax

    mov ebp, 0x90000; setup 32bit stack
    mov esp, ebp

    jmp 0x1000; jump straight to our kernel entry point!

BOOT_DRIVE db 0; variable to store boot drive index

times 510-($-$$) db 0
dw 0xaa55

ENTRY(_start)

SECTIONS
{
    . = 0x1000;

    .text : ALIGN(4)
    {
        obj/kernel/entry.o(.text)
        obj/kernel/kernel.o(.text)
        obj/kernel/idt.o(.text)
        obj/common/screen.o(.text)
        obj/common/print.o(.text)
        obj/common/getchar.o(.text)
        *(.text)
    }

    .rodata : ALIGN(4)
    {
        *(.rodata)
    }

    . = 0x5000;

    .data : ALIGN(4)
    {
        *(.data)
    }

    .bss : ALIGN(4)
    {
        *(COMMON)
        *(.bss)
    }
}

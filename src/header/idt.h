#pragma once
struct idt_entry_struct {
    unsigned short base_lo;
    unsigned short sel;
    unsigned char  always0;
    unsigned char  flags;
    unsigned short base_hi;
} __attribute__((packed));

struct idt_ptr_struct {
    unsigned short limit;
    unsigned int   base;
} __attribute__((packed));

void idt_set_gate(unsigned char num, unsigned int base, unsigned short sel, unsigned char flags);
void init_idt();
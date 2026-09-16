CC = gcc
AS = nasm
LD = ld
QEMU = qemu-system-i386

# FLAGS: Compile for 32-bit. -fno-pic and -fno-pie fix the GLOBAL_OFFSET_TABLE error
# FLAGS: Добавляем -fno-stack-protector, чтобы убрать ошибку __stack_chk_fail
CFLAGS = -m32 -std=gnu99 -ffreestanding -O0 -Wall -Wextra -Isrc/header -fno-pic -fno-pie -fno-stack-protector

ASFLAGS = -f elf32

# LINKER: Output pure binary without ELF headers
LDFLAGS = -m elf_i386 -T linker.ld -nostdlib --oformat binary -no-pie

OBJ_DIR = obj

# List of all kernel object files
KERNEL_OBJS = \
    $(OBJ_DIR)/kernel/entry.o \
    $(OBJ_DIR)/kernel/kernel.o \
    $(OBJ_DIR)/kernel/idt.o \
    $(OBJ_DIR)/common/screen.o \
    $(OBJ_DIR)/common/print.o \
    $(OBJ_DIR)/common/getchar.o 
# Main build target
all: os_image.img

obj/kernel/%.o: src/kernel/%.c
	gcc -c $< -o $@ -m32 -std=gnu99 -ffreestanding -O0 -Wall -Wextra -Isrc/header -fno-pic -fno-pie


$(OBJ_DIR)/boot/boot.bin: src/boot/boot.asm
	@mkdir -p $(@D)
	$(AS) -f bin $< -o $@

# Compile the GDT configuration
$(OBJ_DIR)/boot/gdt.o: src/boot/gdt.asm
	@mkdir -p $(@D)
	$(AS) $(ASFLAGS) $< -o $@

kernel.bin: $(OBJ_DIR)/boot/gdt.o $(KERNEL_OBJS)
	# Мы убрали -Tbss и жестко привязали и bss, и common, и данные к адресу 0x5000 через section-start!
	$(LD) -m elf_i386 -Ttext 0x1000 --section-start .data=0x5000 --section-start .bss=0x5050 -nostdlib -no-pie -o kernel.elf $(OBJ_DIR)/kernel/entry.o $(filter-out $(OBJ_DIR)/kernel/entry.o, $(KERNEL_OBJS))
	objcopy -O binary kernel.elf kernel.bin




os_image.img: $(OBJ_DIR)/boot/boot.bin $(OBJ_DIR)/boot/gdt.o kernel.bin
	dd if=$(OBJ_DIR)/boot/boot.bin of=os_image.img bs=512 count=1
	dd if=kernel.bin of=os_image.img bs=512 seek=1 conv=sync
	@echo "[SUCCESS] OS image is ready!"

run: os_image.img
	$(QEMU) -drive format=raw,file=os_image.img -machine smm=off -d int,guest_errors -no-reboot

# Rules for compiling source files from directories
$(OBJ_DIR)/kernel/%.o: src/kernel/%.c
	@mkdir -p $(@D)
	$(CC) -c $< -o $@ $(CFLAGS)

$(OBJ_DIR)/common/%.o: src/common/%.c
	@mkdir -p $(@D)
	$(CC) -c $< -o $@ $(CFLAGS)

$(OBJ_DIR)/kernel/%.o: src/kernel/%.asm
	@mkdir -p $(@D)
	$(AS) $(ASFLAGS) $< -o $@

$(OBJ_DIR)/boot/%.o: src/boot/%.asm
	@mkdir -p $(@D)
	$(AS) $(ASFLAGS) $< -o $@

# Delete old compiled files
clean:
	rm -rf $(OBJ_DIR) kernel.bin os_image.img
	@echo "[CLEANED]"

.PHONY: all clean run

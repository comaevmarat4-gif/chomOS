# chomOS 🚀

A minimalist, x86-based hobby **operating system written from scratch** in C and Assembly for the "bare metal" (x86 architecture).

This project is a deep dive into low-level systems programming, OS development, and hardware communication.

## 🛠️ Current Features

* **Custom Bootloader:** Written in x86 Assembly (`boot.asm`, `gdt.asm`) to initialize the system.
* **Kernel Entry:** Sets up the environment and jumps into the C kernel.
* **GDT & IDT Setup:** Implements Global Descriptor Table and Interrupt Descriptor Table to handle hardware interrupts.
* **Custom I/O Drivers:** Basic screen printing (`screen.c`, `print.c`) and keyboard input tracking (`getchar.c`).
* **Monolithic-style Architecture:** Built into a single executable `kernel.bin` and packaged into a bootable `os_image.img`.

## 📁 Project Structure

* `src/boot/` — Assembly source files for booting and CPU setup.
* `src/kernel/` — Main kernel logic and interrupt handling (IDT).
* `src/common/` — Custom hardware abstraction library (printing, screen handling, keyboard reading).
* `src/header/` — Core header files (`idt.h`, `print.h`, etc.).
* `linker.ld` — Linker script used to align memory sections correctly for the kernel.
* `Makefile` — Build automation script.

## 🚀 How to Build and Run

To compile and run this operating system, you will need `nasm`, `gcc` (configured for x86 target), `make`, and `qemu` installed on your system.

### Prerequisities (Arch Linux)
```bash
sudo pacman -S nasm make qemu gcc
```

### Building the OS Image
To compile the assembly and C source files, link them together, and generate the final bootable image:
```bash
make
```

### Running in Emulator
To launch **chomOS** inside QEMU emulator:
```bash
make run
```

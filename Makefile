CC = i686-elf-gcc

all: kernel bootloader run

kernel_libs: src/kernel/include
	$(CC)

kernel: src/kernel/kernel.c
	$(CC) -c $^ -o bin/kernel.o -std=gnu99 -ffreestanding -O2 -Wall -Wextra

bootloader: src/bootloader/boot.asm
	nasm -f bin $^ -o bin/boot.bin -I src/bootloader/include

run: bin/boot.bin
	qemu-system-i386 $< -net none

clean:
	rm -f bin/boot.bin bin/kernel.o

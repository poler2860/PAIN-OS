CC = i686-elf-gcc

all: bootloader run

kernel: src/kernel/kernel.c
	$(CC) -c $^ -o bin/kernel.o -std=gnu99 -ffreestanding -O2 -Wall -Wextra

bootloader: src/bootloader/boot.asm
	nasm -f bin $^ -o bin/boot.bin

run: bin/boot.bin
	qemu-system-i386 $^ -net none

clean:
	rm -f bin/boot.bin bin/kernel.o

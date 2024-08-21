CC = i686-elf-gcc
LD = i686-elf-ld

all: bootloader run

iso: bootloader kernel.o kernel_entry.o kernel.bin full zeros.bin
	cat bin/os.bin bin/zeros.bin > bin/os_padded.bin

full:
	cat bin/boot.bin bin/kernel.bin > bin/os.bin

kernel.bin: bin/kernel.o bin/kernel_entry.o
	$(LD) -m elf_i386 -o bin/$@ -Ttext 0x1000 $^ --oformat binary

kernel_entry.o: src/bootloader/kernel_entry.asm
	nasm -f elf -o bin/$@ $<

kernel.o: src/kernel/kernel.c
	$(CC) -c $^ -o bin/$@ -ffreestanding -m32 -fno-pie -nolibc -nostdlib

bootloader: src/bootloader/boot.asm
	nasm -f bin $< -o bin/boot.bin -I src/bootloader/include

zeros.bin: src/bootloader/zeros.asm
	nasm -f bin $< -o bin/zeros.bin

run: bin/os_padded.bin
	qemu-system-i386 -fda $< -net none

env:
	nix-shell --pure

clean:
	rm -rf bin/*

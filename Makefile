all: binary run

binary: src/bootloader/boot.asm
	nasm -f bin $^ -o bin/boot.bin

run: bin/boot.bin
	qemu-system-i386 $^ -net none

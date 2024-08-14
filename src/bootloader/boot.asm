[bits 16]
[org 7c00h]

; Set the location to load the kernel into the memory
KERNEL_OFFSET   equ   0x1000

; Save the boot drive number for later
mov     [BOOT_DRIVE], dl

; Setup the stack
mov     bp, 0x9000
mov     sp, bp

jmp     boot

%include "disk.asm"
%include "gdt.asm"

boot:

    call    load_kernel
    call    switch_to_32bit
    call    BEGIN_32bit


[bits 32]
BEGIN_32BIT:
    call KERNEL_OFFSET      ; give control to the kernel
    hlt

[bits 16]
load_kernel:
    mov bx, KERNEL_OFFSET   ; bx -> destination
    mov dh, 2               ; dh -> num sectors
    mov dl, [BOOT_DRIVE]    ; dl -> disk
    call disk_read
    ret

switch_to_32bit:
    cli                             ; Disable interrupts
    lgdt    [gdt_descriptor]        ; Load descriptor table

    ; Enable protected mode
    mov     eax, cr0
    or      cr0, 0x1
    mov     cr0, eax

    jmp     CODE_SEG:init_prot
    ret

init_prot:

    ; Setup the segment registers
    mov     ax, DATA_SEG
    mov     ds, ax
    mov     ss, ax
    mov     es, ax
    mov     fs, ax
    mov     gs, ax

    mov     ebp, 0x90000        ; Setup stack
    mov     esp, ebp

    ret

BOOT_DRIVE  db  0                   ; Set boot drive number

times 510-($-$$) db 0               ; Add padding to the rest of the sector
db 0x55, 0xAA                       ; Make it bootable

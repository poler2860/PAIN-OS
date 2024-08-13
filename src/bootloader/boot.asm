; Set origin after the the BIOS table
[bits 16]
[org 7c00h]

; Set the location to load the kernel into the memory
KERNEL_OFFSET   equ   0x1000

mov     [BOOT_DRIVE], dl

; Setup the stack
mov     bp, 0x9000
mov     sp, bp

jmp boot

%import

boot:
    cli         ; Disable all interrupts

    ; Setup segment registers
    ; Using the flat protected model
    xor     ax, ax
    mov     ss, ax
    mov     ds, ax
    mov     es, ax
    mov     fs, ax
    mov     gs, ax

    mov     ax, 0xFFFFFFFF
    mov     cs, ax

    hlt

BOOT_DRIVE  db  0                   ; Set boot drive number

; Fill the rest of the 512 bytes but the last 4 bytes with zeros and make the sector bootable
fill:
    times 510-($-$$) db 0
    db 0x55, 0xAA

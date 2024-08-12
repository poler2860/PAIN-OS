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

; ------ GDT ------


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

load_kernel:
; TODO: kernel load
; What did you expect


; DL is inserted as a parameter
disk_read:
    pusha
    push    dx                      ; Save number of sectors to read

    ; Read sector into memory
    mov     ah, 0x2                 ; Disk read function code
    mov     al, 0x2                 ; Sectors to read

    mov     ch, 0x0                 ; (Lower 8 bits) cylinder number
    mov     cl, 0x2                 ; Sector number
    mov     dh, 0x0                 ; Head number
    int     13h
    jc      disk_error              ; Check carry bit for disk read error

    pop     dx                      ; Get the origial number of sector to read
    cmp     al, dh                  ; Compare the sectors actuall read
                                    ; to the sectors wanted to read
    jne     sectors_error           ; Re-read the sectors if we could not read all the sectors

    popa
    ret

disk_error:
    jmp     disk_loop

sectors_error:
    jmp     disk_loop

disk_loop:
    jmp     $


BOOT_DRIVE  db  0                   ; Set boot drive number

; Fill the rest of the 512 bytes but the last 4 bytes with zeros and make the sector bootable
fill:
    times 510-($-$$) db 0
    db 0x55, 0xAA

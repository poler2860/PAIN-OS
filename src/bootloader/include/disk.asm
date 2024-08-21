[bits 16]
; DL is inserted as a parameter
disk_read:
    pusha
    push    dx                      ; Save number of sectors to read

    ; Read sector into memory
    mov     ah, 0x2                 ; Disk read function code
    mov     al, dh                  ; Sectors to read

    mov     ch, 0x0                 ; (Lower 8 bits) cylinder number
    mov     cl, 0x2                 ; Sector number
    mov     dh, 0x0                 ; Head number
    int     13h
    jc      .disk_error              ; Check carry bit for disk read error

    pop     dx                      ; Get the origial number of sector to read
    cmp     al, dh                  ; Compare the sectors actuall read
                                    ; to the sectors wanted to read
    jne     .sectors_error           ; Re-read the sectors if we could not read all the sectors

    popa
    ret

    .disk_error:
        mov    al, 'E'
        jmp    .error
        ;jmp     disk_loop

    .sectors_error:
        mov     al, 'S'
        jmp     .error
    ;jmp     disk_loop


    .error:
        mov     ah, 0x0e
        int     0x10
        hlt

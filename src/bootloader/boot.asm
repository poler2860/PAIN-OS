; Set origin after the the BIOS table
[org 7c00h]

; Set video mode to VGA something X something(but in Y axis)
mov     ah, 0
mov     al, 7
int 10h

; Set buffer for writing
k_buf   times  40   db  0

l1:
    call    keypress_to_screen
    jmp     l1

; End program
jmp     fill

; --------------------------------
; ---------- Functions -----------
; --------------------------------

; NOTE: Not needed for the project. Just to test input handling in the BIOS
; Staying here just in case this funtionality is needed
; ( But probably it will be rewritten better anyways )
; Display keystrokes to screen
; Also saves them to a buffer
keypress_to_screen:
    ; ; Save registers to stack
    ; push    eax
    ; push    ecx
    ; push    esi

    ; ; Setup registers
    ; xor     ah, ah
    ; mov     cx, 40                  ; To be used as counter
    ; mov     esi, k_buf              ; Set it to the start of the buffer


    ; ; Write keystoke to screen
    ; k2s_kpress:
    ;     ; Exit if enter is pressed
    ;     cmp     al, 0x0D
    ;     je      k2s_exit

    ;     ; Read char
    ;     xor     ah, ah
    ;     int 16h

    ;     mov     [esi],  al          ; Save to buffer
    ;     call    string_to_screen    ; Display character

    ;     dec     cx
    ;     inc     esi
    ;     cmp     cx, 1
    ;     jne     k2s_kpress          ; Continue if there is still space in the buffer

    ; k2s_exit:
    ;     mov     ah, 0x0E
    ;     mov     al, 0x0A
    ;     int 10h

    ;     ; Restore registers
    ;     pop     esi
    ;     pop     ecx
    ;     pop     eax

    ;     ret

; Function to write string to screen
; esi: Starting address of string to print to the screen
; bh: Page number ( Text modes )
; bl: Pixel colour ( Graphics modes )
string_to_screen:
    ; Save registers to be used
    push    eax
    push    esi

    ; Setup registers for character writing
    mov     ah, 0xE

    ; Loop for writing the string
    w_char:
        mov     al, [esi]           ; Move through the string
        cmp     al, 0               ; Check if we are at the null terminator
        je      w_end               ; exit write function if at null terminator
        int     10h

        inc     esi                 ; Go to the next char in the string
        jmp     w_char

    ; Return to the previous address
    w_end:
        ; Restore registers
        pop     esi
        pop     eax

        ret


; Fill the rest of the 512 bytes with zeros and make the sector bootable
fill:
    times 510-($-$$) db 0
    db 0x55, 0xAA

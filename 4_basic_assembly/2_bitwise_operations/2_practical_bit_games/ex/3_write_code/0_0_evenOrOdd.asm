;    0.0   Write a program that takes a number x as input, and returns:
;          - 0 if x is even.
;          - 1 if x is odd. 

format PE console
entry start

include 'win32a.inc'

section '.text' code readable executable

start:
    call    read_hex    ; x
    xor     ebx, ebx    ; Zero ebx

    shr     eax, 1      ; Shift LSB of eax into carry
    rcl     ebx, 1      ; Shift carry (LSB) into LSB of ebx

    mov     eax, ebx
    call    print_eax

exit:
    push    0
    call    [ExitProcess]

include 'training.inc'
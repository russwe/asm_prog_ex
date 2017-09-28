;    0.1   Write a program that takes three numbers x,y,z as input, and returns:
;          - 0 if (x+y+z) is even.
;          - 1 if (x+y+z) is odd.
;
;          (Note that here + means arithmetic addition).
;          Do it without actually adding the numbers.
;          HINT: Use the XOR instruction.

format PE console
entry start

include 'win32a.inc'

section '.text' code readable executable

start:
    xor     ebx, ebx    ; Zero ebx

    call    read_hex    ; x
    xor     ebx, eax
    
    call    read_hex    ; y
    xor     ebx, eax

    call    read_hex    ; z
    xor     ebx, eax

    xor     eax, eax    ; Zero eax

    shr     bl, 1       ; Shift LSB of ebx into carry
    rcl     al, 1       ; Shift carry (ebx LSB) into LSB of eax

    call    print_eax

exit:
    push    0
    call    [ExitProcess]

include 'training.inc'
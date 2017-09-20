;  0.0 Write a program that takes the value n as input, and finds the sum of
;      all the odd numbers between 1 and 2n+1, inclusive.

format PE console
entry start

include 'win32a.inc'

section '.text' code readable executable

start:
    call    read_hex    ; n
    add     eax, eax    ; eax = 2n
    add     eax, 1h     ; eax = 2n + 1

    mov     ecx, eax    ; ecx = 2n + 1
    mov     eax, 0h     ; eax = 0

sum: ; ecx: 2n + 1, 2n, 2n - 1, ..., 2, 1
    add     eax, ecx
    dec     ecx
    jnz     sum

    call    print_eax

exit:
    push	0
    call	[ExitProcess]

include 'training.inc'
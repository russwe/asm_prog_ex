;   1. Write a program that takes the number n as input, and prints back all the
;      pairs (x,y) such that x < y < n.

format PE console
entry start

include 'win32a.inc'

section '.text' code readable executable

start:
    call    read_hex        ; n

    mov     ecx, eax        ; y
yLoop:
    sub     ecx, 1
    jc      exit

    mov     ebx, ecx        ; x
xLoop:
    sub     ebx, 1
    jc      yLoop

    mov     eax, ebx
    call    print_eax       ; x

    mov     eax, ecx
    call    print_eax       ; y
    jmp     xLoop

exit:
    push    0
    call    [ExitProcess]

include 'training.inc'
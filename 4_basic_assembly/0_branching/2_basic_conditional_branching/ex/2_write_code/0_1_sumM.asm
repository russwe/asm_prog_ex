;  0.1 Write a program that takes the value m as input. It then receives m
;      consecutive numbers from the user, sums all those numbers and prints back
;      the total sum to the console.

format PE console
entry start

include 'win32a.inc'

section '.text' code readable executable

start:
    call    read_hex    ; m
    cmp     eax, 0h
    jz      exit

    mov     ecx, eax    ; ecx = m
    mov     ebx, 0
sum:
    call    read_hex    ; a
    add     ebx, eax    ; ebx += a
    dec     ecx
    jnz     sum

    mov     eax, ebx
    call    print_eax

exit:
    push    0
    call    [ExitProcess]

include 'training.inc'
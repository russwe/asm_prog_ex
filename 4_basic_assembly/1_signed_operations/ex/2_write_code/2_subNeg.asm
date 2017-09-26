;   2. Find out a way to implement NEG using the SUB instruction (And some other
;      instructions that we have learned). Write a small piece of code which
;      demonstrates your conclusion.

format PE console
entry start

include 'win32a.inc'

section '.text' code readable executable

start:
    call    read_hex    ; a
    
    ; 0 - a = -a
    mov     ebx, 0
    sub     ebx, eax

    ; display
    mov     eax, ebx
    call    print_eax

exit:
    push    0
    call    [ExitProcess]

include 'training.inc'
;  3.0   Write a program that takes a number m as input, and prints back 1 to the
;        console if m is a prime number. Otherwise, it prints 0.

format PE console
entry start

include 'win32a.inc'

section '.text' code readable executable

; eax: entry / numerator / div result
; edx: div remainder
; ebx: m
; ecx: odd number counter
start:
    call    read_hex    ; m

    cmp     eax, 3h
    jle     success

    mov     ebx, eax    ; ebx = m

    ; Check Even (Early Exit)
    mov     ecx, 2h
    mov     edx, 0h
    div     ecx
    cmp     edx, 0h
    je      failure

    mov     ecx, 3h
primeLoop:
    cmp     ebx, ecx
    jbe     success

    mov     edx, 0h
    mov     eax, ebx
    div     ecx
    cmp     edx, 0h
    je      failure

    add     ecx, 2h
    jmp     primeLoop
; primeLoop

failure:
    mov     eax, 0h
    call    print_eax
    jmp     exit

success:
    mov     eax, 1h
    call    print_eax

exit:
    push    0
    call    [ExitProcess]

include 'training.inc'
;  3.1   Write a program that takes a number n as input, and prints back to the
;        console all the primes that are larger than 1 but not larger than n.
;
;  This solution simply wraps 3_0, with minimal modification...
;
;  This solution is BAD, we need to run a euclidian sieve,
;  but we haven't gotten to the heap/stack yet :(


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
    cmp     eax, 1h
    jbe     exit

    mov     ebx, eax    ; ebx = m

outerLoop:
    ; Check Even (Early Exit)
    cmp     ebx, 2h
    je      success

    mov     ecx, 2h
    mov     edx, 0h
    mov     eax, ebx
    div     ecx
    cmp     edx, 0h
    je      nextOuter

    mov     ecx, 3h
primeLoop:
    cmp     ebx, ecx
    jbe     success

    mov     edx, 0h
    mov     eax, ebx
    div     ecx
    cmp     edx, 0h
    je      nextOuter

    add     ecx, 2h
    jmp     primeLoop
; primeLoop

success:
    mov     eax, ebx
    call    print_eax

nextOuter:
    dec     ebx         ; we could be smarter here and only move down odd numbers, but hey
    cmp     ebx, 1h
    ja      outerLoop

exit:
    push    0
    call    [ExitProcess]

include 'training.inc'
;   2. Write a program that takes the number n as input, and prints back all the
;      triples (a,b,c), such that a^2 + b^2 = c^2. 
;      
;      These are all the pythagorean triples not larger than n.

format PE console
entry start

include 'win32a.inc'

section '.text' code readable executable

; esi: a
; edi: b^2
; ebx: b
; ecx: c
; ebp: c^2
; edx:eax: a^2 + b^2

start:
    call    read_hex    ; n
    
    mov     ecx, eax    ; c
    inc     ecx
c:
    dec     ecx
    jc      exit

    mov     eax, ecx
    mul     eax
    
    mov     ebp, eax    ; c^2
    mov     ebx, ecx    ; b
    inc     ebx
b:
    sub     ebx, 1
    jc      c           ; bound
    mov     eax, ebx
    mul     eax
    
    mov     edi, eax    ; b^2
    mov     esi, ecx    ; a
    inc     esi
a:
    sub     esi, 1
    jc      b           ; bound
    mov     eax, esi
    mul     eax         ; a^2
    add     eax, edi    ; a^2 + b^2
    cmp     eax, ebp
    jne     a
    mov     eax, esi
    call    print_eax
    mov     eax, ebx
    call    print_eax
    mov     eax, ecx
    call    print_eax
    jmp     b           ; No other 'a' will work with this 'b' and 'c'

exit:
    push    0
    call    [ExitProcess]

include 'training.inc'
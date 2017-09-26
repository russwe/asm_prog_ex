;  0.2 Write a program that finds every double word (4 bytes) that satisfies the
;      following condition: When decomposed into 4 bytes, if we multiply those
;      four bytes, we get the original double word number.

format PE console
entry start

include 'win32a.inc'

section '.text' code readable executable

start:
    mov     esi, 0ffffffffh

outer:
    mov     eax, esi    ; dcba

inner: ; This is almost verbatim 0_1, hence the extra move (esi -> eax -> ecx)
    mov     ecx, eax    ; ecx = dcba

    movzx   edx, cl     ; a
    movzx   eax, ch     ; b
    mul     edx         ; edx:eax = a * b
    mov     edi, eax    ; edi = a * b

    mov     edx, 0
    mov     eax, ecx    ; eax = dcba
    mov     ebx, 10000h
    div     ebx         ; eax >> 16
    mov     ecx, eax    ; ecx = dc

    mov     eax, edi    ; eax = a * b
    movzx   edx, cl     ; c
    mul     edx         ; edx:eax = a * b * c

    movzx   edx, ch     ; d
    mul     edx         ; edx:eax = a * b * c * d

    cmp     eax, esi
    jne     nextOuter
    call    print_eax

nextOuter:
    dec     esi
    jno     outer

exit:
    push    0
    call    [ExitProcess]

include 'training.inc'
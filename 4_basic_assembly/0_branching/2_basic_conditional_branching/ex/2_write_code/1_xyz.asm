;   1.  Write a program that takes three numbers as input: x,y,z. Then it prints 1
;       to the console if x < y < z. It prints 0 otherwise.
;
;       NOTE: The comparison should be in the unsigned sense. That means for
;       example: 0x00000003 < 0x7f123456 < 0xffffffff

format PE console
entry start

include 'win32a.inc'

section '.text' code readable executable

start:
    mov     ecx, 1h     ; output (x < y < z -> 1, 0 otherwise)

x:
    call    read_hex    ; x
    mov     ebx, eax    ; ebx = x

y:
    call    read_hex    ; y
    cmp     ebx, eax    ; x < y
    mov     ebx, eax    ; ebx = y
    jl      z
    mov     ecx, 0h

z:
    call    read_hex    ; z
    cmp     ebx, eax    ; y < z
    jl      output
    mov     ecx, 0h

output:
    mov     eax, ecx
    call    print_eax

exit:
    push    0
    call    [ExitProcess]

include 'training.inc'
;  0.0 Write a program that takes a double word (4 bytes) as an argument, and
;      then adds all the 4 bytes. It returns the sum as output. Note that all the
;      bytes are considered to be of unsigned value.
;
;      Example: For the number 03ff0103 the program will calculate 0x03 + 0xff +
;      0x01 + 0x3 = 0x106, and the output will be 0x106
;
;      HINT: Use division to get to the values of the highest two bytes.

format PE console
entry start

include 'win32a.inc'

section '.text' code readable executable

start:
    call    read_hex    ; dcba
    movzx   ebx, al     ; a
    movzx   ecx, ah     ; b
    add     ebx, ecx    ; ebx = a + b

    mov     ecx, 10000h
    mov     edx, 0
    div     ecx         ; eax >> 16

    movzx   ecx, al     ; c
    add     ebx, ecx    ; ebx = a + b + c

    movzx   ecx, ah     ; d
    add     ebx, ecx    ; ebx = a + b + c + d

    mov     eax, ebx
    call    print_eax

exit:
    push    0
    call    [ExitProcess]

include 'training.inc'
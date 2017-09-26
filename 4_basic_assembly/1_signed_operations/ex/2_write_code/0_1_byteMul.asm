;  0.0 Write a program that takes a double word (4 bytes) as an argument, and
;      then adds all the 4 bytes. It returns the sum as output. Note that all the
;      bytes are considered to be of unsigned value.
;
;      Example: For the number 03ff0103 the program will calculate 0x03 + 0xff +
;      0x01 + 0x3 = 0x106, and the output will be 0x106
;
;      HINT: Use division to get to the values of the highest two bytes.
;
;  0.1 Write a program that does the same, except that it multiplies the four
;      bytes. (All the bytes are considered to be unsigned).

format PE console
entry start

include 'win32a.inc'

section '.text' code readable executable

start:
    call    read_hex    ; dcba
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

    call    print_eax

exit:
    push    0
    call    [ExitProcess]

include 'training.inc'
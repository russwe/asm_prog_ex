;   3.  Common number.
;   
;       Create a program that takes a number n as input, followed by a list of n
;       numbers b_1, b_2, ... b_n. You may assume that 0x0 <= b_i <= 0xff for every
;       1 <= i <= n.
;   
;       The program will output the most common number.
;   
;       Example:
;   
;       Assume that the input was n=7, followed by the list: 1,5,1,3,5,5,2.
;       The program will output 5, because this is the most common number.
;   
;       Note that if there is more than one most common number, the program will
;       just print one of the most common numbers.

format PE console
entry start

include 'win32a.inc'

section '.bss' readable writable
    numberCounts db 100h dup (?)
    numberCountsEnd:

    numberCountsLen = numberCountsEnd - numberCounts

section '.text' code readable executable

start:
    mov     ebx, numberCounts

    call    read_hex    ; n
    test    eax, eax
    jz      exit

    mov     ecx, numberCountsLen
clearNumberCounts:
    dec     ecx
    mov     byte [ebx + ecx * 1], 0
    test    ecx, ecx
    jnz clearNumberCounts

    mov     ecx, eax
computeCommonCounts:
    call    read_hex
    and     eax, 0ffh
    inc     byte [ebx + eax]
    loop    computeCommonCounts

    xor     edx, edx
    xor     edi, edi
    mov     eax, 0101h
    mov     ecx, numberCountsLen
findMostCommon:
    dec     ecx
    mov     dl, byte [ebx + ecx * 1]
    cmp     edx, edi
    jbe     next
    mov     edi, edx
    mov     eax, ecx

next:
    test    ecx, ecx
    jnz     findMostCommon

    call    print_eax

exit:
    push    0
    call    [ExitProcess]

include 'training.inc'
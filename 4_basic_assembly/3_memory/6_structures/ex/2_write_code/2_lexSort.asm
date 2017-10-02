;   2.  Lexicographic sort.
;   
;       We define the lexicographic order as follows:
;       For every two points (a,b), (c,d), we say that (a,b) < (c,d) if:
;   
;       (a < c) or (a = c and b < d)
;   
;       This order is similar to the one you use when you look up words in the
;       dictionary. The first letter has bigger significance than the second one,
;       and so on.
;       
;       Examples:
;   
;         (1,3) < (2,5)
;         (3,7) < (3,9)
;         (5,6) = (5,6)
;   
;       Write a program that takes 6 points as input (Two coordinates for each
;       point), and prints a sorted list of the points, with respect to the
;       lexicographic order.

; 1,3,2,5,3,7,3,9,5,6,5,6
; 5,6,3,9,5,6,2,5,1,3,3,7

format PE console
entry start

include 'win32a.inc'

struct PNT
    x db ?
    y db ?
ends

pointCount = 6

section '.bss' readable writable
    points db pointCount * sizeof.PNT dup (?)
points_end:

section '.text' code readable executable

start:
    ; Read in 6 points
    mov     ecx, pointCount
readPoints:
    dec     ecx
    lea     edi, [points + sizeof.PNT * ecx]

    call    read_hex
    mov     byte [edi + PNT.x], al

    call    read_hex
    mov     byte [edi + PNT.y], al

    test    ecx, ecx
    jnz     readPoints

    call    print_delimiter

    xor     eax, eax
    xor     ebx, ebx

    ; Sort point-list
    ;       ecx = 0
sortPoints:
    mov     edx, ecx
swapLowest:
    inc     edx
    cmp     edx, pointCount
    je      nextSortPoints

    lea     edi, byte [points + sizeof.PNT * ecx]
    lea     esi, byte [points + sizeof.PNT * edx]

    ; (a,b) < (c,d) IF:
    ; (a < c) or (a = c and b < d)
    mov     ax, word [esi]

    cmp     al, byte [edi + PNT.x]
    jb      swap
    ja      nextSwapLowest

    cmp     ah, byte [edi + PNT.y]
    jae     nextSwapLowest

swap:
    mov     bx, word [edi]
    mov     word [esi], bx
    mov     word [edi], ax

nextSwapLowest:
    jmp swapLowest

nextSortPoints:
    inc     ecx
    cmp     ecx, pointCount - 1
    jne     sortPoints

    ; Output sorted list
    xor     eax, eax
    xor     ecx, ecx
outputSortedList:
    call    print_delimiter

    lea     esi, [points + sizeof.PNT * ecx]

    mov     al, byte [esi + PNT.x]
    call    print_eax

    mov     al, byte [esi + PNT.y]
    call    print_eax

    inc     ecx
    cmp     ecx, pointCount
    jne     outputSortedList

exit:
    push    0
    call    [ExitProcess]

include 'training.inc'
;   3.  Sum of distances:
;       
;       For a binary number x, we define the "sum of 1 distances" to be the sum of
;       distances between every two "1" bits in x's binary representation.
;   
;       Small example (8 bits):
;   
;         x = {10010100}_2
;              7  4 2
;         
;         The total sum of distances: (7-4) + (7-2) + (4-2) = 3 + 5 + 2 = 10
;   
;   
;       Create a program that takes a number x (of size 4 bytes) as input, and
;       outputs x's "sum of 1 distances".

format PE console
entry start

include 'win32a.inc'

section '.text' code readable executable

; edi: output

; eax: outer stream
; ecx: outer counter

; ebx: inner stream
; edx: inner counter

start:
    call    read_hex        ; x
    call    print_eax_binary

    mov     ebx, eax
    xor     edi, edi
    mov     ecx, 32d
walkBits:
    rol     eax, 1
    rol     ebx, 1
    jnc     walkNext

    mov     edx, ecx
sumDistances:
    dec     edx
    jz      walkNext

    rol     ebx, 1
    jnc     sumDistances

    add     edi, ecx
    sub     edi, edx

    jmp     sumDistances

walkNext:
    ror     ebx             ; reset ebx
    loop    walkBits
    
    mov     eax, edi
    call    print_eax

exit:
    push    0
    call    [ExitProcess]

include 'training.inc'
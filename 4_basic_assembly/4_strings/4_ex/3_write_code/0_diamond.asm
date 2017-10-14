;   0.  Diamond
;   
;       Write a program that asks the user for a number n, and then prints a
;       "diamond" of size n, made of ASCII stars.
;   
;       Example:
;         For n = 1 the expected result is:
;   
;          *
;         ***
;          *
;   
;         For n = 2 the expected result is:
;   
;           *
;          ***
;         *****
;          ***
;           *
;   
;       HINT: You could use tri.asm exercise from the code reading section as a
;       basis for your program.

format PE console
entry start

include 'win32a.inc'

section '.const' data readable
    szSizePrompt    db  'Enter desired size of diamond: ', 0
    outMap          db  ' ', 0, '*', 0, ' ', 0, 'x', 0
    szNewline       db  13, 10, 0

section '.bss' readable writable
    nMiddleIndex    dd  ?

; n = 2 (len = 5)
; 0 1 2 3 4    t1               t2
;     *     0   | 2 - 0 = 2 | -> 5 - 2 = 3
;   * * *   1   | 2 - 1 = 1 | -> 5 - 1 = 4
; * * * * * 2   | 2 - 2 = 0 | -> 5 - 0 = 5
;   * * *   3   | 2 - 3 = 1 | -> 5 - 1 = 4 
;     *     4   | 2 - 4 = 2 | -> 5 - 2 = 3

; t1 = abs(n - nRow)
; t2 = len - t1

; eax: n
; ebx: idxCol
; ecx: idxRow
; edx: idxNextTransition = abs(n - idxRow) -> len - idxNextTransition
; edi: len = 2n + 1
; esi: print_str argument

section '.text' code readable executable
start:
    mov     esi, szSizePrompt
    call    print_str
    call    read_hex        ; n

    mov     edi, eax
    shl     edi, 1
    inc     edi             ; length = 2n + 1

    mov     esi, szNewline
    call    print_str

    xor     ecx, ecx
rows:
    mov     esi, outMap

    ; t1
    mov     edx, eax
    sub     edx, ecx
    test    edx, edx 
    jns     no_neg
    neg     edx

no_neg:
    xor     ebx, ebx
cols:
    cmp     ebx, edx
    jne     write
    
    ; t2
    neg     edx
    add     edx, edi

    ; Move idxOutMap
    add     esi, 2

write:
    call    print_str

    inc     ebx
    cmp     ebx, edi
    jne     cols

    mov     esi, szNewline
    call    print_str

    inc     ecx
    cmp     ecx, edi
    jnz     rows

exit:
    mov     esi, szNewline
    call    print_str
    call    print_str

    push    0
    call    [ExitProcess]

include 'training.inc'
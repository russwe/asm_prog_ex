;   1.  Matrix Fibonacci
;   
;       A matrix is a two dimensional table of numbers.
;       Assume we have two matrices of size 2X2:
;   
;       A =  | a  b |   ,    B = | e  f |
;            | c  d |            | g  h |
;   
;       We define their multiplication to be the following 2X2 matrix:
;       
;       AB = | ae + bg   af + bh |
;            | ce + dg   cf + dh |
;   
;       Example:
;   
;       For:  A = | 1 1 |  ,   B = | 1 1 |  We get:  AB = | 2 1 |
;                 | 1 0 |          | 1 0 |                | 1 1 |
;   
;       
;       We define matrix powers to be repetitive multiplication. A matrix M to the
;       power of k equals M*M*M...*M (k times). We also use the notation M^k to
;       express the k-th power of the matrix M.
;   
;       Example:
;   
;               2
;       | 1 1 |     =   | 2 1 |
;       | 1 0 |         | 1 1 |
;   
;   
;       0.    Consider the matrix  A = | 1 1 |
;                                      | 1 0 |
;   
;             Convince yourself that  A^n = | F_{n+1}  F_n     |
;                                           | F_n      F_{n-1} |
;   
;             Where F_n is the n-th element of the fibonacci series.
;   
;             Recall that the Fibonacci series is the series in which every element
;             equals to the sum of the previous two elements. It begins with the
;             elements: F_0 = 0, F_1 = 1, F_2 = 1, F_3 = 2, F_4 = 3, F_5 = 5.
;   
;       1.    Define a struct to hold the contents of a 2X2 matrix. 
;       
;       2.    Write a function that multiplies two matrices.
;   
;             HINTS: 
;               How to take matrices as arguments?
;               - Give the addresses of the matrices in memory as arguments.
;   
;               How to return a matrix from the function? There is more than one
;               option:
;               - You could supply a third argument to the function, which will be
;                 the address of the result.
;               - You could override one of the matrices that you got as an
;                 argument with the result.
;   
;   
;       3.    Write a function that takes a matrix M and an integer k as arguments,
;             and outputs M^k. (M to the power of k).
;   
;       4.    Read the number n from the user, and output F_n. (Fibonacci element
;             number n).
;   
;       5.    Bonus: How many matrix multiplications does it take to calculate F_n
;             using this method? Could you use less matrix multiplications?

format PE console
entry start

include 'win32a.inc'

struct MX2
    union
        a dd ?
        e dd ?
    ends
    union
        b dd ?
        f dd ?
    ends
    union
        c dd ?
        g dd ?
    ends
    union
        d dd ?
        h dd ?
    ends
ends

section '.const' data readable
    szPrompt    db      "Enter a number 'n' to get the nth Fibonacci number: ", 0
    szEndLine   db      13,10,0

section '.data' data readable writeable
    F           MX2     1,1,1,0

section '.text' code readable executable
start:
    mov     esi, szPrompt
    call    print_str
    call    read_hex

    push    eax
    cmp     eax, 1
    jbe     .result

    push    F
    call    mxexp

    mov     eax, [F + MX2.c]
.result:
    call    print_eax

.exit:
    push    0
    call    [ExitProcess]

; CONVENTION: Callee cleans stack
;
; IN
;   A: pointer to matrix A
;   exp:(onent)
;
; OUT
;   A <- A^exp
mxexp:
    push    ebp
    mov     ebp, esp
    .A   = 8
    .exp = 12
    sub     esp, sizeof.MX2
    .tmp = -sizeof.MX2

    push    eax ; result address
    push    ecx ; exp counter
    push    edi ; temp
    push    esi ; result

    ; Initialize
    mov     esi, [ebp + .A]
    lea     edi, [ebp + .tmp]
    
    push    edi
    push    esi

    mov     ecx, sizeof.MX2
    rep     movsb

    mov     ecx, [ebp + .exp]
    sub     ecx, 1
.doMult:
    call    mulma       ; A & B pushed above
    loop    .doMult

    add     esp, 4*2    ; clean up A & B

    pop     esi
    pop     edi
    pop     ecx
    pop     eax

    mov     esp, ebp
    pop     ebp
    ret     4*2

; CONVENTION: Caller cleans stack (optimization for repeated calls)
;
; IN
;   A: address for matrix A (also used for storing result)
;   B: address for matrix B
;
; OUT
;   eax: no change
;   A <- AB
;
; DESCRIPTION
;       A =  | a  b |   ,    B = | e  f |
;            | c  d |            | g  h |
;   
;       We define their multiplication to be the following 2X2 matrix:
;       
;       AB = | ae + bg   af + bh |
;            | ce + dg   cf + dh |
mulma:
    push    ebp
    mov     ebp, esp
    .A = 8
    .B = 12
    sub     esp, sizeof.MX2
    .tmp = -sizeof.MX2

    push    ecx
    push    edi
    push    esi

    mov     esi, [ebp + .A]
    mov     edi, [ebp + .B]

    ; ae + bg
    push    dword [edi + MX2.g]
    push    dword [esi + MX2.b]
    push    dword [edi + MX2.e]
    push    dword [esi + MX2.a]
    call    mulma_item
    mov     [ebp + .tmp + MX2.a], eax

    ; af + bh
    push    dword [edi + MX2.h]
    push    dword [esi + MX2.b]
    push    dword [edi + MX2.f]
    push    dword [esi + MX2.a]
    call    mulma_item
    mov     [ebp + .tmp + MX2.b], eax

    ; ce + dg
    push    dword [edi + MX2.g]
    push    dword [esi + MX2.d]
    push    dword [edi + MX2.e]
    push    dword [esi + MX2.c]
    call    mulma_item
    mov     [ebp + .tmp + MX2.c], eax

    ; cf + dh
    push    dword [edi + MX2.h]
    push    dword [esi + MX2.d]
    push    dword [edi + MX2.f]
    push    dword [esi + MX2.c]
    call    mulma_item
    mov     [ebp + .tmp + MX2.d], eax

    ; overwrite A
    lea     esi, [ebp + .tmp]
    mov     edi, [ebp + .A]
    mov     cx, sizeof.MX2
    rep     movsb

    pop     esi
    pop     edi
    pop     ecx

    mov     esp, ebp
    pop     ebp
    ret

; CONVENTION: Callee cleans stack
;
; IN
;   a
;   b
;   e
;   g
;
; OUT
;   eax = ae + bg
mulma_item:
    push    ebp
    mov     ebp, esp
    .a = 8
    .e = 12
    .b = 16
    .g = 20

    push    ebx
    push    edx

    xor     edx, edx
    mov     eax, [ebp + .a]
    mov     ebx, [ebp + .e]
    mul     ebx    
    push    eax

    xor     edx, edx
    mov     eax, [ebp + .b]
    mov     ebx, [ebp + .g]
    mul     ebx

    pop     ebx
    add     eax, ebx

    pop     edx
    pop     ebx

    mov     esp, ebp
    pop     ebp
    ret     4*4

include 'training.inc'
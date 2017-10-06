;   1.  Transpose.
;       
;       1.0   Create a new program. Add a two dimensional table A (of dwords) in the
;             bss section of your program, of sizes: HEIGHT X WIDTH. Initialize cell
;             number A(i,j) (Row number i, column number j) with the number i+j.
;   
;             Print some cells of the table A to make sure that your code works
;             correctly.
;   
;       1.1   Add another table B to your bss section, with dimensions WIDTH X
;             HEIGHT. (Note that this table has different dimensions!)
;   
;             Then add a piece of code that for every pair i,j: Stores A(i,j) into
;             B(j,i). 
;   
;             In another formulation:
;             B(j,i) <-- A(i,j) for every i,j.
;   
;             Example:
;   
;               Original A table:
;               
;                 0 1 2 3
;                 1 2 3 4
;   
;               Resulting B table:
;   
;                 0 1
;                 1 2
;                 2 3
;                 3 4
;   
;       1.2   Print some cells of table A and table B to make sure that your code
;             works correctly.

format PE console
entry start

include 'win32a.inc'

section '.bss' readable writable

    WIDTH  = 9
    HEIGHT = 9

    A  dd HEIGHT*WIDTH dup ?
    A_end:

    B  dd WIDTH*HEIGHT dup ?
    B_end:

section '.text' code readable writable

start:

    mov     esi, A
initialize:
    xor     edx, edx
    mov     eax, esi
    sub     eax, A
    mov     ebx, WIDTH
    div     ebx

    add     eax, edx
    mov     dword [esi], eax

    add     esi, 4
    cmp     esi, A_end
    jne     initialize

    mov     esi, A
transpose:
    xor     edx, edx
    mov     eax, esi
    sub     eax, A
    mov     ebx, WIDTH
    div     ebx

    mov     ecx, edx
    mov     ebx, HEIGHT
    mul     ebx
    add     eax, ecx
    lea     edi, dword [B + eax * 4]

    mov     ebx, dword [esi]
    mov     dword [edi], esi

    add     esi, 4
    cmp     esi, A_end
    jne     transpose

    mov     eax, [A + (0 * WIDTH  + 0) * 4]
    call    print_eax

    mov     eax, [A + (0 * HEIGHT + 0) * 4]
    call    print_eax

    mov     eax, [A + (1 * WIDTH  + 0) * 4]
    call    print_eax

    mov     eax, [A + (1 * HEIGHT + 0) * 4]
    call    print_eax

    mov     eax, [A + (2 * WIDTH  + 4) * 4]
    call    print_eax

    mov     eax, [A + (2 * HEIGHT + 4) * 4]
    call    print_eax

exit:
    push    0
    call    [ExitProcess]

include 'training.inc'
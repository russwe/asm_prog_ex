;   2.  Count paths.
;       
;       We consider a two dimensional table of size N X N:
;   
;         +---+---+---+---+
;         |   |   |   |   |
;         | S |   |   |   |
;         |   |   |   |   |
;         +---+---+---+---+
;         |   |   |   |   |
;         |   |   |   |   |
;         |   |   |   |   |
;         +---+---+---+---+
;         |   |   |   |   |
;         |   |   |   |   |
;         |   |   |   |   |
;         +---+---+---+---+
;         |   |   |   |   |
;         |   |   |   | E |
;         |   |   |   |   |
;         +---+---+---+---+
;   
;       With two special cells: Start (S) and End (E). Start is the top left cell,
;       and End is the bottom right cell. 
;       
;       A valid path from S to E is a path that begins with S, ends with E, and
;       every step in the path could either be in the down direction, or in the
;       right direction. (Up or left are not allowed).
;   
;         Example for a valid path: right, right, down, down, right, down:
;   
;         +---+---+---+---+
;         |   |   |   |   |
;         | S-|---|-+ |   |
;         |   |   | | |   |
;         +---+---+---+---+
;         |   |   | | |   |
;         |   |   | | |   |
;         |   |   | | |   |
;         +---+---+---+---+
;         |   |   | | |   |
;         |   |   | +-|-+ |
;         |   |   |   | | |
;         +---+---+---+---+
;         |   |   |   | | |
;         |   |   |   | E |
;         |   |   |   |   |
;         +---+---+---+---+
;   
;       We would like to count the amount of possible valid paths from S
;       to E.
;   
;   
;       2.0   Let T be some cell in the table:
;   
;                |   |   |
;                |   |   |
;              --+---+---+--
;                |   |   |
;                |   | R |
;                |   |   |
;              --+---+---+--
;                |   |   |
;                | Q | T |
;                |   |   |
;              --+---+---+--
;                |   |   |
;                |   |   |
;   
;             Prove that the amount of valid paths from S to T equals to the amount
;             of paths from S to Q plus the amount of paths from S to R.
;   
;       2.1   Define a constant N in your program, and create a two dimensional
;             table of size N X N (of dwords). Call it num_paths. We will use this
;             table to keep the amount of possible valid paths from S to any cell in
;             the table.
;   
;       2.2   The amount of paths from S to each of the cells in the top row, or the
;             leftmost column, is 1. 
;             
;             Write a piece of code that initializes all the top row and the
;             leftmost column to be 1.
;   
;       2.3   Write a piece of code that iterates over the table num_paths. For
;             every cell num_paths(i,j) it will assign:
;   
;             num_paths(i,j) <-- num_paths(i-1,j) + num_paths(i,j-1)
;   
;             Note that you should not iterate over the top row and the leftmost
;             column, because you have already assigned them to be 1.
;   
;       2.4   The last cell in num_paths, num_paths(N-1,N-1) contains the amount of
;             valid paths possible from S to E. 
;   
;             Add a piece of code to print this number.
;   
;       2.5   Bonus: Could you find out num_paths(N-1,N-1) with less memory?
;             Currently we use about O(N^2) dwords of memory. Could you do it with
;             about O(N) dwords of memory?
;
;       You don't need 'up', you can just use the existing values in the current "row" as "up"
;
;       2.6*  Bonus: Could you calculate the number num_paths(N-1,N-1) without using
;             the computer at all?
;
;       Yes, np(N-1, N-1) = 2*N - 2, where N > 1; and 1, where N = 1

;    0  1  2  3
; 0 *1  1  1  1
; 1  1 *2  3  4
; 2  1  3 *4  5
; 3  1  4  5 *6

format PE console
entry start

include 'win32a.inc'

section '.bss' readable writable
    N = 0ah
    num_paths dd N*N dup ?
    num_paths_end:

section '.text' code readable executable

start:
    xor     esi, esi
    xor     edi, edi
init_row_col:
    ; Init row
    mov     dword [num_paths + 4 * esi], 1

    ; Init col
    mov     dword [num_paths + 4 * edi], 1

    add     edi, N

    inc     esi
    cmp     esi, N
    jne     init_row_col

;   mov     esi, N
fill_table:
    mov     ecx, N-1
fill_row:
    mov     ebx, dword [num_paths + 4 * esi]  ; left
    inc     esi

    mov     eax, esi
    sub     eax, N
    add     ebx, dword [num_paths + 4 * eax]  ; left + up
    mov     dword [num_paths + 4 * esi], ebx

    loop    fill_row

    inc     esi
    cmp     esi, N*N
    jb      fill_table

output_total:
    mov     esi, num_paths_end
    sub     esi, 4

    mov     eax, [esi]
    call    print_eax

exit:
    push    0
    call    [ExitProcess]

include 'training.inc'
;   6.  Bonus: Identifying powers of two.
;       
;       6.0   Find the binary representation of the following numbers:
;             1,2,4,8,16,32 (Decimal representation).
;             What do all those binary representations have in common?
;
;               1:  0000 0001
;               2:  0000 0010
;               4:  0000 0100
;               8:  0000 1000
;               16: 0001 0000
;               32: 0010 0000
;   
;               They all have *only one* bit
;
;       6.1   Write a program that takes a number x and finds out if this number is
;             a power of 2. It outputs 1 if the number is a power of 2, and 0
;             otherwise.
;   
;       6.2   Try to write that program again, this time without any loops.
;             
;             HINT: try to decrease the original number by 1.
;
;       0001 - 1 = 0000 AND 0001 = 0
;       0010 - 1 = 0001 AND 0010 = 0
;       0100 - 1 = 0011 AND 0100 = 0
;       1000 - 1 = 0111 AND 1000 = 0

format PE console
entry start

include 'win32a.inc'

section '.text' code readable executable

start:
    call    read_hex
    mov     ebx, eax
    dec     ebx

    and     eax, ebx
    jz      output
    mov     eax, 1

output:
    call    print_eax   ; output 0 if power of 2; 1 otherwise

exit:
    push    0
    call    [ExitProcess]

include 'training.inc'
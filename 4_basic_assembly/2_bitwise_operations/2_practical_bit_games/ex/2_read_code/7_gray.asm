; Basic Assembly
; ==============
; 
; Bitwise operations - Practical bit games
; ----------------------------------------
;
; Gray
; @@@@
;
; 0.    Assemble and run this program.
; 
; 1.    How many inputs does this program expect?
;       1
;
; 2.    The input of this program corresponds to the amount of output printed.
;       Give it an input number of size about 0x10, and look at the result.
;
; 3.    Read the program's code below, and try to understand what does it do. 
;       Try to describe it as simply as you can. Add comments if needed.
;
;       Computes the first N binary-reflected gray codes.
;       This code computes the BRG for a given number:
;           mov eax, ecx
;           shr eax, 1
;           xor eax, ecx
;       
; 4.    Look at some output of the program. Pay attention to the following:
;       -   Every two consecutive numbers differ by at most one bit.
;           Try to understand why.
;
;       a    ^^ a>>1 = BRG
;       0000 ^^ 0000 = 0000
;       0001 ^^ 0000 = 0001
;       0010 ^^ 0001 = 0011
;       0011 ^^ 0001 = 0010
;       0100 ^^ 0010 = 0110
;       0101 ^^ 0010 = 0111
;       0110 ^^ 0011 = 0101
;       0111 ^^ 0011 = 0100
;       1000 ^^ 0100 = 1100
;       1001 ^^ 0100 = 1101
;       1010 ^^ 0101 = 1111
;       1011 ^^ 0101 = 1110
;       1100 ^^ 0110 = 1010
;       1101 ^^ 0110 = 1011
;       1110 ^^ 0111 = 1001
;       1111 ^^ 0111 = 1000
;
; 5.    Bonus: Write a program that "verifies" that every two consecutive
;       numbers on this list differ by at most one bit. check out all the
;       possible dwords.
;
; 6.    This list of numbers is called Gray Code. It is an alternative ;
;       method to count, in which every two consecutive numbers differ by only
;       one bit. 
;       
;       It has many interesting uses. Search and read about it a bit.
;
;       https://en.wikipedia.org/wiki/Gray_code
;
        

format PE console
entry start

include 'win32a.inc' 

; ===============================================
section '.text' code readable executable

start:
    call    read_hex            ; a
    mov     esi,eax             ; esi = a
    xor     ecx,ecx             ; Zero ecx.

show_one_num:
    mov     eax,ecx             ; eax = ecx = 0,1,2,...,a
    shr     eax,1               ; eax = ecx >> 1
    xor     eax,ecx             ; eax = (ecx >> 1) ^^ ecx
    call    print_eax_binary
    
    inc     ecx
    cmp     ecx,esi
    jnz     show_one_num        ; ++ecx != a -> show_one_num

    ; Exit the process:
	push	0
	call	[ExitProcess]


include 'training.inc'

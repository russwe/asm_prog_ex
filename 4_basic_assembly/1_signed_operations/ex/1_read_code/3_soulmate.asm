; Basic Assembly
; ==============
; 
; Signed Operations
; -----------------
;
; Soulmate
; @@@@@@@@
; 
; 0.    Assemble and run this program.
; 
; 1.    What are the numbers found by the program? Try to guess.
;
; 2.    Read the code below, and try to understand the meaning of the numbers
;       returned by the program.
;
;       0x00000000  -> zero, negated, is zero
;       0x80000000  -> negative number whose two's complement is the same number
;       This number has no positive analog for a the given bitness.
;       Thus, two's complement will always have: MaxValue = |MinValue| - 1
;
;       For 32-bits, those numbers are:
;           Max:  2^31 - 1  =  2147483647
;           Min: -2^31      = -2147483648
;
; 3.    Why does it take the program so long to complete? How many iterations
;       does the main loop go through?
;
;       The *only* loop goes through ffffffff iterations. (0 is skipped)
;       This is also why it takes so long.
;

format PE console
entry start

include 'win32a.inc' 

; ===============================================
section '.text' code readable executable

start:

    mov     ecx,0ffffffffh

iters:
    mov     eax,ecx
    neg     eax
    cmp     eax,ecx
    jnz     not_equal
    mov     eax,ecx
    call    print_eax
not_equal:
    dec     ecx
    cmp     ecx,0ffffffffh
    jnz     iters

    ; Exit the process:
	push	0
	call	[ExitProcess]

include 'training.inc'

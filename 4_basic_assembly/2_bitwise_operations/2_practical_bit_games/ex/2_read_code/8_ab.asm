; Basic Assembly
; ==============
; 
; Bitwise operations - Practical bit games
; ----------------------------------------
;
; Ab
; @@
;
; 0.    Assemble and run this program.
; 
; 1.    How many inputs does this program expect?
;       1
;
; 2.    Try to run the program with different inputs, and check out the results
;       that you get. Make sure to check the following inputs:
;       0,3,ffffffff,-5
;
;       Computes the absolute value of the input
; 
; 2.    Read the program's code below, and try to understand what does it do. 
;       Try to describe it as simply as you can. Add comments if needed.
;
; 3.    Remember the three important lines in this program by heart :)
;
        

format PE console
entry start

include 'win32a.inc' 

; ===============================================
section '.text' code readable executable

start:

    call    read_hex    ; a

    cdq                 ; a -> edx:eax, edx = 0 || ffffffff, eax = eax (a)
    xor     eax,edx     ; if edx = 0, no change to eax; if edx = 1, invert eax
    sub     eax,edx     ; if edx = 0, eax -> eax; if edx = 1, eax -> ~eax-1 (two's complement)

    call    print_eax

    ; Exit the process:
	push	0
	call	[ExitProcess]


include 'training.inc'

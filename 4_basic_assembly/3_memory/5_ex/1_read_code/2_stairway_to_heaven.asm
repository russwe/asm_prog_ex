; Basic Assembly
; ==============
; 
; Memory
; ------
;
; Stairway to heaven
; @@@@@@@@@@@@@@@@@@
; 
; 0.    Assemble and run this program.
;
; 1.    How many inputs does this program accept?
;       1
;
; 2.    Try to hand the program different inputs, and observe the different
;       outputs.
;
; 3.    Read the program's code below, and try to understand what does it do. 
;       Try to describe it as simply as you can. Add comments if needed.
;
;       outputs a number of 1's from the LSB towards the MSB based on the given input
;       (mod 20h)
;
; 4.    Choose some random inputs and try to predict the output. Verify your
;       predictions by running your program.
;
; 5.    What happens when the input is larger than 0x20 ? Why ?
;
;       You get all 1's, because the program happily keeps shifting left and adding 1
;       even after it has already 'filled' all bits. (mod 20h)
;

format PE console
entry start

include 'win32a.inc' 

    
; ===============================================
section '.text' code readable executable

start:

    call    read_hex            ; x
    mov     ecx,eax             ; ecx = x

    xor     eax,eax             ; Zero eax.
one_iter:
    lea     eax,[2*eax + 1]     ; eax = 2*0 + 1, 2*1 + 1, 2*4 + 1, 2*9 + 1, ... AKA: eax << 1 + 1
    loop    one_iter

    call    print_eax_binary    ; number of 1's from the LSB towards the MSB based on the given input

    ; Exit the process:
	push	0
	call	[ExitProcess]


include 'training.inc'

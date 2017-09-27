; Basic Assembly
; ==============
; 
; Bitwise operations - Practical bit games
; ----------------------------------------
;
; Hamming
; @@@@@@@
;
; 0.    Assemble and run this program.
; 
; 1.    How many inputs does this program expect?
;       2
;
; 2.    Try to give different inputs to this program, and check the results.
;
; 3.    Read the program's code below, and try to understand what does it do. Try
;       to describe it as simply as you can.
;       Add comments if needed.
;       
;       Guessing it computes the Hamming Distance between the two inputs.
;
; 4.    What is the largest output that you have managed to get from the program?
;       What is the largest possible output? Can you find a way to reach it?
;
;       Largest Possible output: 32d (20h), where all bits between 'a' and 'b' are different.
;       a: ffffffff, b: 0

format PE console
entry start

include 'win32a.inc' 

; ===============================================
section '.text' code readable executable

start:

    call    read_hex    ; a
    mov     edx,eax
    call    read_hex    ; b
    xor     eax,edx     ; eax = a+b

    xor     ebx,ebx     ; Zero ebx.
    mov     ecx,32d     ; 32 bits to process

add_bit: ; Compute pop. count of eax
    mov     esi,eax
    and     esi,1
    add     ebx,esi
    ror     eax,1
    loop    add_bit

    mov     eax,ebx
    call    print_eax   ; output pop. count of a+b (Hamming Distance)

    ; Exit the process:
	push	0
	call	[ExitProcess]


include 'training.inc'

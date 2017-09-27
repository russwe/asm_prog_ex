; Basic Assembly
; ==============
; 
; Bitwise operations - Practical bit games
; ----------------------------------------
;
; Endiana Jones
; @@@@@@@@@@@@@
;
; 0.    Assemble and run this program.
; 
; 1.    How many inputs does this program expect?
;
;       1
;
; 2.    Try to give different inputs to this program, and check the results.
;       Particularly, check the following input: 11223344.
;
; 3.    Read the program's code below, and try to understand what does it do. 
;       Try to describe it as simply as you can. Add comments if needed.
;
;       Changes the endianess of the input by reversing the bytestream
;       NOTE: Not the _bit_stream
;       
; 4.    Pick some random inputs and verify your predictions about what this
;       program does.
;

format PE console
entry start

include 'win32a.inc' 

; ===============================================
section '.text' code readable executable

start:
    call    read_hex
    mov     ecx,4       ; 4 * 8 = 32 bits
pass_byte:
    shl     ebx,8       ; ebx << 8 (one byte) ebx uninitialized, but doesn't matter as we are filling all bytes in this loop
    mov     bl,al       ; mov bottom byte of eax into bottom byte of ebx
    shr     eax,8       ; eax >> 8
    loop    pass_byte   ; --ecx != 0 -> pass_byte

    mov     eax,ebx     ; eax = reversed input bytestream
    call    print_eax

    ; Exit the process:
	push	0
	call	[ExitProcess]


include 'training.inc'

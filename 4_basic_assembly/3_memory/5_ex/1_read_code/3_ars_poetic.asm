; Basic Assembly
; ==============
; 
; Memory
; ------
;
; Ars Poetic
; @@@@@@@@@@
; 
; 0.    Assemble and run this program.
;
; 1.    Read the program's code below, and try to understand what does it do. 
;       Try to describe it as simply as you can. Add comments if needed.
;
;       Prints the bytestream of the assembled program
;       (at least, the bits between start and end_prog)
;
; 2.    Explain the program's output.
;
;       The output is itself, assembled
;
; 3.    Open the executable in a hex editor, and try to find the output inside
;       the hex data.
;
;       This is trivial, simply find the start of the '.text' section >.>
;
; 4.    How can you change the program so that it will also apply to the code
;       inside training.inc ?
;

format PE console
entry start

include 'win32a.inc' 
 
; ===============================================
section '.text' code readable executable

start:

    mov     esi,start
print_byte:
    movzx   eax, byte [esi]
    call    print_eax
    inc     esi
    cmp     esi,end_prog
    jnz     print_byte

    ; Exit the process:
	push	0
	call	[ExitProcess]

; A label that marks the end of our code.
end_prog:

include 'training.inc'

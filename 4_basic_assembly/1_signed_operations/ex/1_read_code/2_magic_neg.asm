; Basic Assembly
; ==============
; 
; Signed Operations
; -----------------
;
; Magic NEG
; @@@@@@@@@
; 
; 0.    Assemble and run this program.
; 
; 1.    How many inputs does this program expect?
;       1
;
; 2.    Try to give different inputs to this program, and check the results.
;
; 3.    Read the program's code below, and try to understand what does it do. Try
;       to describe it as simply as you can.
;
;       Nothing.  It outputs the input after a number of convolutions.
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

    call    read_hex    ; a
    neg     eax         ; eax = -a
    inc     eax         ; eax = -a + 1
    neg     eax         ; eax = -(-a + 1)
    inc     eax         ; eax = -(-a + 1) + 1 = a - 1 + 1 = a
    call    print_eax

    ; Exit the process:
	push	0
	call	[ExitProcess]

include 'training.inc'

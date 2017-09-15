; Basic fasm
; ==========
; 
; Read Code
; ---------
;
; Int Diff
; @@@@@@@@
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
;       
;       Note that the relevant part of the code is from the "start" label until
;       the [ExitProcess] call invocation. You do not need to read the input and
;       output subroutines.
;       
;       output: a^2 - b^2
;
; 4.    Pick some random inputs and verify your predictions about what this
;       program does.
;
; 5.    Use the following input values: 0xffffffff and 0x1. Explain the output
;       that you get back from the program.
;
;       output: 0
;       0xffffffff ^2 -> edx:eax, leaving '1' in eax
;       1^2 = 1
;       1 - 1 = 0

format PE console
entry start

include 'win32a.inc' 

; ===============================================
section '.text' code readable executable

start:
    ; The program begins here:

    call    read_hex    ; eax = a
    mul     eax         ; edx:eax = a^2
    mov     esi,eax     ; esi = a^2

    call    read_hex    ; eax = b
    mul     eax         ; edx:eax = b^2
    sub     esi,eax     ; esi = a^2 - b^2
    mov     eax,esi     ; eax = a^2 - b^2

    call    print_eax   

    ; Exit the process:
	push	0
	call	[ExitProcess]

include 'training.inc'

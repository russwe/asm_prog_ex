; Basic fasm
; ==========
; 
; Read Code
; ---------
;
; Strange Calc
; @@@@@@@@@@@@
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
;       output: 2 * (a + b) + 1
;       
; 4.    Pick some random inputs and verify your predictions about what this
;       program does.

format PE console
entry start

include 'win32a.inc' 

; ===============================================
section '.text' code readable executable

start:
    ; The program begins here:

    call    read_hex    
    mov     edx,eax     ; edx = a
    call    read_hex    ; eax = b
    add     eax,edx     ; eax = a + b
    add     eax,eax     ; eax = 2 * (a + b)
    inc     eax         ; eax = 2 * (a + b) + 1

    call    print_eax

    ; Exit the process:
	push	0
	call	[ExitProcess]

include 'training.inc'

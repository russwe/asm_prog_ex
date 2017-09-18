; Basic Assembly
; ==============
; 
; Basic Conditional Branching
; ---------------------------
;
; Read Code
; ---------
;
; Numeric Justice
; @@@@@@@@@@@@@@@
; 
; 0.    Assemble and run this program.
; 
; 1.    How many inputs does this program expect?
;
;       2
;
; 2.    Try to give different inputs to this program, and check the results.
;
; 3.    Read the program's code below, and try to understand it. 
;       Try to describe it as simply as you can.
;       
;       Note that the relevant part of the code is from the "start" label until
;       the [ExitProcess] call invocation. You do not need to read the input and
;       output subroutines.
;
;       prints '1' if a == b, '0' otherwise
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

    call    read_hex    ; a
    mov     ecx,eax     ; ecx = a
    call    read_hex    ; b
    sub     eax,ecx     ; eax = b - a
    jnz     l1          ; !0 -> l1 (b != a)

    mov     eax,1       ; eax = 1
    call    print_eax   ; print 1
    jmp     l2          ; -> l2

l1: ; b == a
    mov     eax,0       ; eax = 0
    call    print_eax   ; print 0
l2:

    ; Exit the process:
	push	0
	call	[ExitProcess]

include 'training.inc'

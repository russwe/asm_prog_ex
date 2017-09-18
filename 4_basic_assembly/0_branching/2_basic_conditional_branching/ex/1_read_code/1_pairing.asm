; Basic Assembly
; ==============
; 
; Basic Conditional Branching
; ---------------------------
;
; Read Code
; ---------
;
; Pairing
; @@@@@@@
; 
; 0.    Assemble and run this program.
; 
; 1.    How many inputs does this program expect?
;
;       4
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
;       prints '1', if (d + a) - (b + c) == 0, otherwise '0'
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
    mov     edx,eax     ; edx = b
    call    read_hex    ; c
    mov     esi,eax     ; esi = c
    call    read_hex    ; d
    add     eax,ecx     ; eax = d + a
    add     edx,esi     ; edx = b + c
    sub     eax,edx     ; eax = (d + a) - (b + c)

    jnz     g1          ; !0 -> g1

    mov     eax,1
    call    print_eax   ; print 1
    jmp     g2          ; -> g2

g1: ; (d + a) - (b + c) != 0
    mov     eax,0
    call    print_eax   ; print 0
g2:

    ; Exit the process:
	push	0
	call	[ExitProcess]

include 'training.inc'

; Basic Assembly
; ==============
; 
; Signed Operations
; -----------------
;
; Diva
; @@@@
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
;       Computes a / b, with respect to signed numbers.
;       
; 4.    Pick some random inputs and verify your predictions about what this
;       program does.
; 
; 5.    What happens if you try to give the program negative values? (Note that
;       you may just use the minus symbol, for example: -10.
;       Is the result correct? What happens if both of the of the arguments are
;       negative?
;
;       Yes.  The two's complement output is correct.
;       - / - = +
;
; 6.    Try to change the "cdq" instruction to "mov edx,0", and check what
;       results do you get now. Do you still get correct results for negative
;       numbers?
;
;       No.  0 != correct sign extension for negative numbers.
;       You'd have to check the sign first, and either mov 0 or ffffffff into EDX
;       
; 7.    Implement the "cdq" instruction yourself, using an IF style
;       conditional (With CMP and the relevant JCC instruction). 
;       Make sure that you get the same results as in the original program.
;

format PE console
entry start

include 'win32a.inc' 

; ===============================================
section '.text' code readable executable

start:

    call    read_hex
    mov     esi,eax
    call    read_hex
    mov     edi,eax

    mov     eax,esi
    ; START cdq
    mov     edx,2
    mul     edx
    jc      negExtend
posExtend:
    mov     edx,00000000h
    jmp     continue
negExtend:
    mov     edx,80000000h
continue:
    mov     eax,esi
    ; END cdq
    idiv    edi

    call    print_eax
    

    ; Exit the process:
	push	0
	call	[ExitProcess]

include 'training.inc'

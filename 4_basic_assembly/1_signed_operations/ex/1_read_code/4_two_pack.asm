; Basic Assembly
; ==============
; 
; Signed Operations
; -----------------
;
; Two Pack
; @@@@@@@@
; 
; 0.    Assemble and run this program.
; 
; 1.    How many inputs does this program expect?
;       1
;
; 2.    Try to give different inputs to this program, and check the results.
;       Specifically, try the following inputs: 
;       12345, 0101, 0202, 0203, 01ff.
;
; 3.    Read the program's code below, and try to understand what does it do. Try
;       to describe it as simply as you can.
;       
;       sign-extends and multiplies the low and high 4 bits of the input
;       and returns the result
;
; 4.    Pick some random inputs and verify your predictions about what this
;       program does.
;
; 5.    Describe what happens for input ff01 against what happens for input
;       01ff.
;

format PE console
entry start

include 'win32a.inc' 

; ===============================================
section '.text' code readable executable

start:

    call    read_hex        ; a
    cmp     eax,0ffffh
    ja      exit_program    ; a > 0xffff -> exit_program

    movsx   esi,al          ; esi = low 4 bits of a (sign-extended)
    movzx   eax,ah          ; eax = high 4 bits of a (sign-extended)

    imul    esi             ; edx:eax = a_h * a_l
    call    print_eax       ; print result of a_h * a_l

exit_program:
    ; Exit the process:
	push	0
	call	[ExitProcess]

include 'training.inc'

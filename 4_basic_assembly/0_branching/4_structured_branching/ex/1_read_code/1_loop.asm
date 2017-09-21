; Basic Assembly
; ==============
; 
; Structured branching
; --------------------
;
; loop
; @@@@
; 
; The loop instruction is a great addition to your vocabulary of known
; instructions. It's signature is:
;
;   loop    label
;
; It is equivalent in operation to the following two instructions:
; 
;   dec     ecx
;   jnz     label
;
; The following program is going to make use of the loop instruction.
; 
;
; 0.    Assemble and run this program.
; 
; 1.    How many inputs does this program expect?
;       1
;
; 2.    Try to give different inputs to this program, and check the results.
;
; 3.    Read the program's code below, and try to understand what does it do. 
;       Try to describe it as simply as you can.
;       
;       Returns the result of: a^2 + (a-1)^2 + (a-2)^2 + ... + 2^2 + 1^2
;                              Sum(i^2, n, 1, -1)
;
; 4.    Pick some random inputs and verify your predictions about what this
;       program does.
; 
; 5.    Identify the different structured branching constructs inside this
;       code: Identify IF,FOR,WHILE and BREAK.
;

format PE console
entry start

include 'win32a.inc' 

; ===============================================
section '.text' code readable executable

start:

    call    read_hex    ; a
    mov     ecx,eax     ; ecx = a
    mov     esi,0       ; esi = 0

again:  ; FOR i=<in>; i > 0; --i
    mov     eax,ecx     ; eax = a
    mul     eax         ; edx:eax = a^2
    add     esi,eax     ; esi += a^2        ; a^2 + (a-1)^2 + (a-2)^2 + ... + 2^2 + 1^2 + 0^2
    loop    again       ; The new loop instruction:
                        ; It is equivalent to those two instructions:
                        ; dec   ecx     ; --a
                        ; jnz   again   ; !! input '0' will cause kaboom

    mov     eax,esi
    call    print_eax   ; print summation result

    ; Exit the process:
	push	0
	call	[ExitProcess]

include 'training.inc'

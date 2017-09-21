; Basic Assembly
; ==============
; 
; Structured branching
; --------------------
;
; mx
; @@@
; 
; 0.    Assemble and run this program.
; 
; 1.    How many inputs does this program expect?
;       1 + n
;
; 2.    Try to give different inputs to this program, and check the results.
;
; 3.    Read the program's code below, and try to understand what does it do. Try
;       to describe it as simply as you can.
;
;       Accepts N numbers and returns the maximum (where is N is also provided by the user)       
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

    call    read_hex        ; a
    mov     esi,eax         ; esi = a
    mov     edx,0           ; edx = 0

looper: ; FOR a = <in>; a > 0; --a
    call    read_hex        ; b
    cmp     eax,edx         ; IF eax > edx

    jbe     eax_is_smaller
    mov     edx,eax         ; edx = eax

eax_is_smaller:
    dec     esi             ; --a
    jnz     looper

    mov     eax,edx
    call    print_eax       ; print max number
    

    ; Exit the process:
	push	0
	call	[ExitProcess]

include 'training.inc'

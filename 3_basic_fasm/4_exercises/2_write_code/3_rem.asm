; Basic Assembly
; ==============
; 
; Memory
; ------
;
; Template
; @@@@@@@@
;

format PE console
entry start

include 'win32a.inc' 

start:
    ; Program begins here..
;3.  Write a program that receives two numbers a,b as input, and outputs the
;    remainder of dividing a by b.

    call read_hex   ; a
    mov edx, eax    ; edx = a

    call read_hex   ; b
    mov ebx, eax    ; ebx = b

    mov eax, edx    ; eax = a
    mov edx, 0      ; edx = 0
    div ebx         ; 0:a / b

    mov eax, edx    ; remainder
    call print_eax

    ; Exit the process:
	push	0
	call	[ExitProcess]

include 'training.inc'

;	1.  Write a program that receives two numbers a,b and calculates their integral
;		average.

format PE console
entry start

include 'win32a.inc' 

; ===============================================
section '.text' code readable executable

start:
    ; Program begins here.
    call read_hex   ; a
    mov edx, eax

    call read_hex   ; b
    add eax, edx

    mov edx, 0      ; 0:eax / 2
    mov ebx, 2
    div ebx

    call print_eax

    ; Exit the process:
	push	0
	call	[ExitProcess]

include 'training.inc'

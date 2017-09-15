; 	2.  Write a program that receives a number x as input, and outputs to the
;    	console the following values: x+1, x^2 , x^3, one after another.

format PE console
entry start

include 'win32a.inc' 

; ===============================================
section '.text' code readable executable

start:
    ; Program begins here..
    call read_hex   ; eax = x
    mov ebx, eax    ; ebx = x

    ; x+1
    inc eax
    call print_eax

    ; x^2
    mov eax, ebx    ; mov is faster than inc/dec
    mul ebx
    call print_eax

    ; x^3
    mul ebx
    call print_eax

    ; Exit the process:
	push	0
	call	[ExitProcess]

include 'training.inc'

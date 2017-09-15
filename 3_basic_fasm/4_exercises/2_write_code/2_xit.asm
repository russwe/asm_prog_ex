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

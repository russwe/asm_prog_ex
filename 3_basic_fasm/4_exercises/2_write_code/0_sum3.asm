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
    ; Program begins here.
    call read_hex   ; a
    mov edx, eax

    call read_hex   ; b
    add edx, eax
    
    call read_hex   ; c
    add eax, edx

    call print_eax

    ; Exit the process:
	push	0
	call	[ExitProcess]

include 'training.inc'

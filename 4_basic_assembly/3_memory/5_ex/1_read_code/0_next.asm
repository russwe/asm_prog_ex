; Basic Assembly
; ==============
; 
; Memory
; ------
;
; Next
; @@@@
; 
; 0.    Assemble and run this program.
;
; 1.    Read the program's code below, and try to understand what does it do. 
;       Try to describe it as simply as you can. Add comments if needed.
;
;       Add one to the last byte of the DWORD in x_num
;
; 2.    Explain the program's output.
;
;       11223344 is stored in memory as:
;
;       x_num -> x_num + 3
;       44  33  22  11
;
;       Thus, increasing the first byte of x_num in memory, adds 1 to 44.
;       The final output is equivalent to adding 1 to the dword: 11223345
;

format PE console
entry start

include 'win32a.inc' 


; This is the data section:
; ===============================================
section '.data' data readable writeable
    x_num   dd  11223344h

    
; ===============================================
section '.text' code readable executable

start:

    inc     byte [x_num] ; Increase the first byte.
    mov     eax, dword [x_num]
    call    print_eax 

    ; Exit the process:
	push	0
	call	[ExitProcess]


include 'training.inc'

; Basic Assembly
; ==============
; 
; Bitwise operations - Practical bit games
; ----------------------------------------
;
; Party
; @@@@@
;
; 0.    Assemble and run this program.
; 
; 1.    How many inputs does this program expect?
;       1
;
; 2.    Try to give different inputs to this program, and check the results.
;       Particularly: Check the results you get for the following inputs:
;       0,1,2,4,8,ffffffff
;
; 3.    Read the program's code below, and try to understand what does it do. 
;       Try to describe it as simply as you can. Add comments if needed.
;       
;       Simple parity computation.  If bitcount is odd, return 1; otherwise 0
;
; 4.    What is the largest output that you have managed to get from the program?
;       What is the largest possible output? Can you find a way to reach it?
;
;       ... 1, any odd bit-count input, including input in the sample set
;

format PE console
entry start

include 'win32a.inc' 

; ===============================================
section '.text' code readable executable

start:
    call    read_hex    ; a

    xor     ebx,ebx     ; Zero ebx.
    mov     ecx,32d

xor_bit:
    mov     esi,eax     ; esi = eax (a ROR ...)
    and     esi,1       ; trim out last bit
    xor     ebx,esi     ; xor last bit of a ROR with current parity bit
    ror     eax,1       ; eax = ROR1 eax
    loop    xor_bit     ; --ecx != 0 -> xor_bit

    mov     eax,ebx     ; move parity to eax
    call    print_eax   ; print parity

    ; Exit the process:
	push	0
	call	[ExitProcess]


include 'training.inc'

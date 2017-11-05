; Basic Assembly
; ==============
; 
; Subroutines and the stack - Calling conventions
; -----------------------------------------------
; 
; Summer party
; @@@@@@@@@@@@
;    
; 0.    Skim the code. Understand the dependencies between the
;       functions (Which function calls which function).
;
; 1.    Assemble and run the program. Check the output, and try to predict its
;       meaning.
;
; 1.    Look at how the summer function is being called.
;
; 2.    Read the contents of the summer function, and try to understand how it
;       works. How many arguments does it get?
;
; 3.    A function of this type is called a Variadic function. 
;
;       - Which calling convention is being used: STDCALL or CDECL?
;           STDCALL
;
;       - Is it possible to get a Variadic function using the other calling
;         convention?
;           Sure, but not any we covered.  STDCALL allows the caller to clean up the stack
;           and only the caller knows how many inputs were added to the stack.
;           (RET does not take a register for the value to clean up)
;

format PE console
entry start

include 'win32a.inc' 

; ===============================================
section '.data' data readable writeable
    summerp         db  'Welcome to the summer party!',13,10,0

; ===============================================
section '.text' code readable executable

start:
    ; Print: Welcome to the summer party!
    mov     esi,summerp
    call    print_str

    ; Call summer a few times:
    push    1
    push    2
    push    4
    push    3
    call    summer
    add     esp,4*4
    call    print_eax

    push    5
    push    3
    push    2
    call    summer
    add     esp,4*3
    call    print_eax

    push    0
    call    summer
    add     esp,4
    call    print_eax

    push    5
    push    1
    call    summer
    add     esp,4*2
    call    print_eax

    ; Exit the process:
	push	0
	call	[ExitProcess]


; =============================================
; summer(dword... val)
; 
; Input:
;   0 or more dwords
; Output:
;   eax = i0 + i1 + ... + iN
; Operation:
;   Sums the input
summer:
    push    ecx     ; Keep registers to the stack.
    push    edi

    mov     ecx,dword [esp + 4 + 2*4]
    lea     edi,[esp + 8 + 2*4]
    xor     eax,eax

    jecxz   .no_args
.process_arg:
    add     eax,dword [edi]
    add     edi,4
    loop    .process_arg
.no_args:

    pop     edi     ; Restore registers from the stack.
    pop     ecx
    ret

include 'training.inc'

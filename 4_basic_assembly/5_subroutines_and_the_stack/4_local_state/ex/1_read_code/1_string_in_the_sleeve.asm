; Basic Assembly
; ==============
; 
; Subroutines and the stack - Local state
; ---------------------------------------
; 
; String in the sleeve
; @@@@@@@@@@@@@@@@@@@@
;
; 0.    Assemble and run this program.
;
; 1.    Observe the output.
;
; 2.    Skim the code. Take a look at the functions and their descriptions.
;       Understand the dependencies between the functions (Which function calls
;       which function), and what is the special purpose of every function.
;
; 3.    Read the program's code below, and try to understand what does it do. 
;       Try to describe it as simply as you can. Add comments if needed.
;
; 4.    Note the string in the middle of the text section. Explain how is it
;       printed to the console.
;       Carefully understand what happens to the stack.
;
;       call .skip pushes the return address (next EIP value) onto the stack
;       the return address just so happens to be the start of the string to print
;       therefore the call to the print method keeps that address as its arg1
;       and the string is printed out.
;

format PE console
entry start

include 'win32a.inc' 

; ===============================================
section '.text' code readable executable

start:

    call    .skip               ; pushes return address onto stack (start of string)
    db      'Living in the text section',13,10
    db      '   my life is not a life...',13,10,0
.skip:
    call    print_str2          ; arg1 = start of string
    add     esp,4               ; remove arg1 from the stack

    ; Exit the process:
	push	0
	call	[ExitProcess]

; ===============================================
; print_str2(str_addr)
;
; Input:
;   str_addr - Address of a string.
; Operation:
;   Print the string at str_addr to the console.
;   Assumes that str_addr is null terminated.
;
print_str2:
    .str_addr = 8
    enter   0,0
    push    esi
    mov     esi,dword [ebp + .str_addr]
    call    print_str
    pop     esi
    leave
    ret

include 'training.inc'

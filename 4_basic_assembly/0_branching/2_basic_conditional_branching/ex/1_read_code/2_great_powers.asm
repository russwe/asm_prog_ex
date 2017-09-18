; Basic Assembly
; ==============
; 
; Basic Conditional Branching
; ---------------------------
;
; Read Code
; ---------
;
; Great Powers
; @@@@@@@@@@@@
; 
; 0.    Assemble and run this program.
; 
; 1.    How many inputs does this program expect?
;       1
;
; 2.    Try to give different inputs to this program, and check the results.
;
; 3.    Read the program's code below, and try to understand it. 
;       Try to describe it as simply as you can.
;       
;       Note that the relevant part of the code is from the "start" label until
;       the [ExitProcess] call invocation. You do not need to read the input and
;       output subroutines.
;
;       Outputs the result of raising 2 to the input -power
;       
; 4.    Pick some random inputs and verify your predictions about what this
;       program does.
;
; 5.    Given the input of 0, what is the output of this program?
;       Why does it take so long for the program to compute it?
;
;       Is it the right output?
;       If not, fix the program to give back the right output.
;
;       Infinite Loop, and no.  Wrong output.

format PE console
entry start

include 'win32a.inc' 

; ===============================================
section '.text' code readable executable

start:
    ; The program begins here:

    call    read_hex    ; eax = a
    mov     ecx,1       ; ecx = 1

    cmp     eax,0h      ; is the input 0?
    jz      output      ; if so: skip straight to output

lb1:
    add     ecx,ecx     ; ecx = 2 * ecx // 2 4 8 16 32 64 128 ...
    dec     eax         ; --a
    jnz     lb1         ; a != 0 -> lb1

output:
    mov     eax,ecx     ; eax = ecx
    call    print_eax   ; print the result of 2^a

    ; Exit the process:
	push	0
	call	[ExitProcess]

include 'training.inc'

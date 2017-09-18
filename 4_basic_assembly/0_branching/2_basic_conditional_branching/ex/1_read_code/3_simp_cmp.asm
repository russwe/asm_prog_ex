; Basic Assembly
; ==============
; 
; Basic Conditional Branching
; ---------------------------
;
; Read Code
; ---------
;
; simp cmp
; @@@@@@@@
; 
; 0.    Assemble and run this program.
; 
; 1.    How many inputs does this program expect?
;       2
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
;       Compute b - a and print '1' if there was a borrow, otherwise '0'
;
; 4.    Pick some random inputs and verify your predictions about what this
;       program does.
;
;       Question: How does this program work with signed numbers, like
;       0xffffffff?
;
;       Yes/No.  It will output correctly whether there was a lessThan or not.
;       However, for signed numbers it should be checking overflow/underflow to have the same logical meaning.
;
; 5.    Give better names to the labels in the program, so that it would be
;       easier to read and understand. Make sure that the program still
;       assembles and runs correctly after your modifications.

format PE console
entry start

include 'win32a.inc' 

; ===============================================
section '.text' code readable executable

start:
    ; The program begins here:

    call    read_hex    ; a
    mov     ecx,eax     ; ecx = a
    call    read_hex    ; b
    sub     eax,ecx     ; eax = b - a
    jc      lessThan    ; if subtraction 'borrowed' -> lessThan


greaterOrEqual: ; non-borrow path
    mov     eax,0       ; eax = 0
    call    print_eax   ; print 0
    jmp     exit        ; -> exit
    
lessThan: ; borrow path
    mov     eax,1       ; eax = 1
    call    print_eax   ; print 1

exit:
    ; Exit the process:
	push	0
	call	[ExitProcess]

include 'training.inc'

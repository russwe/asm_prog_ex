; Basic Assembly
; ==============
; 
; Signed Operations
; -----------------
;
; Higher Window
; @@@@@@@@@@@@@@
; 
; 0.    Assemble and run this program.
; 
; 1.    How many inputs does this program expect?
;       1
;
; 2.    Try to give different inputs to this program, and check the results.
;
; 3.    Read the program's code below, and try to understand what does it do. Try
;       to describe it as simply as you can.
;
;       Returns 1 if number is negative, 0 otherwise
;       
; 4.    Pick some random inputs and verify your predictions about what this
;       program does.
;
; 5.    How could you implement this program without the cdq instruction? Write
;       your implementation as a new program, and make sure that it has the same
;       results.
;
;       See 1_higher_window_no_edq.asm
;

format PE console
entry start

include 'win32a.inc' 

; ===============================================
section '.text' code readable executable

start:

    call    read_hex        ; eax = a
    cdq                     ; edx = sign_extend(a)
    cmp     edx,0           ; eax is a positive number?
    jz      edx_is_zero     ; yes -> edx_is_zero
    mov     eax,1           ; no:
    call    print_eax       ; output 1
    jmp     end_if
edx_is_zero:
    mov     eax,0
    call    print_eax       ; output 0
end_if:

    ; Exit the process:
	push	0
	call	[ExitProcess]

include 'training.inc'

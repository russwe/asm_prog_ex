; Basic Assembly
; ==============
; 
; Basic Conditional Branching
; ---------------------------
;
; Read Code
; ---------
;
; bad cmp
; @@@@@@@
;
; 0.    Note that this program is the same as "simp cmp", except for one
;       instruction. Find it.
;
;       jc b1 -> js b1
; 
; 1.    Has the behaviour of this program changed as a result? Check some inputs
;       for example. If you think that the behaviour has changed, prove it by
;       finding input that gives different results in this program and in simp_cmp
;       program.
;
;       HINT: How does it work with signed numbers?
;
;       ffffffff
;       0
;       1/0
;
;       0
;       ffffffff
;       0/1
; 
; 2.    *Bonus*: Could you make this program understand comparison of signed
;       numbers using only the Sign Flag and the Overflow Flag? Make the
;       necessary modifications to the code.
; 

format PE console
entry start

include 'win32a.inc' 

; ===============================================
section '.text' code readable executable

start:
    ; The program begins here:

    call    read_hex
    mov     ecx,eax
    call    read_hex
    sub     eax,ecx
    jo      overflow
    js      b1          ; OF = 0, SF = 1 -> b1
    jmp     s1          ; OF = 0, SF = 0 -> s1

overflow:
    jns     b1          ; OF = 1, SF = 0 -> b1
                        ; OF = 1, SF = 1 -> s1
s1: ; b >= a
    mov     eax,0
    call    print_eax
    jmp     c1
    
b1: ; b < a
    mov     eax,1
    call    print_eax

c1:
    ; Exit the process:
	push	0
	call	[ExitProcess]

include 'training.inc'

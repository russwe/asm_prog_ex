; Basic Assembly
; ==============
; 
; Structured branching
; --------------------
;
; Pasta
; @@@@@
; 
; You are given a piece of spaghetti code, and you are going to understand it
; and then fix it, to be a normal readable piece of code.
; 
; Enjoy your food :)
; 
;
; 0.    Assemble and run this program.
; 
; 1.    How many inputs does this program expect?
;       1
;
; 2.    Try to give different inputs to this program, and check the results.
;
; 3.    Read the program's code below, and try to understand what does it do. 
;       Try to describe it as simply as you can.
;       
;       Sums the numbers between (0, n] which aren't evenly divisible by 5
;
; 4.    Pick some random inputs and verify your predictions about what this
;       program does.
; 
; 5.    Try to think about a better design for this code:
;       What kinds of loops are you going to use?
;       What kind of branches are you going to use?
;
;       Make the changes to the code. Make sure your new code has no
;       intersecting branches. Also make sure that it is readable, and well
;       commented. Finally, make sure that it has exactly the same output as the
;       original code.
;

format PE console
entry start

include 'win32a.inc' 

; ===============================================
section '.text' code readable executable

; edx: div-h / mod result / output
; eax: div-l / output

; ebx: total (output)
; ecx: cur, [n, 0):-1
; esi: div-d (5)

start:
    mov     esi,5d          ; esi = 5 (constant)

    call    read_hex        ; n
    mov     ecx,eax         ; ecx = n (cur)

    mov     ebx,0           ; ebx = 0
iters:
    mov     edx,0           ; edx = 0
    mov     eax,ecx         ; eax = cur
    div     esi             ; edx = 0:cur % 5, eax = 0:cur / 5
    cmp     edx,0           ; (no remainder)
    je      nextIter        ; if no remainder -> nextIter
    add     ebx,ecx         ; total += cur
nextIter:
    loop    iters           ; if --cur != 0 -> iters

output:   
    mov     eax,ebx         ; print total
    call    print_eax

exit:
    ; Exit the process:
	push	0
	call	[ExitProcess]

include 'training.inc'

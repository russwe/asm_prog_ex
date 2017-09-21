; Basic Assembly
; ==============
; 
; Structured branching
; --------------------
;
; Perfect
; @@@@@@@
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
;       (Hint: Search about Perfect numbers on the web.)
;
;       Outputs all perfect numbers between [2,n)
;
; 4.    Add comments to the code, to make it more readable.
;       
; 5.    Pick some random inputs and verify your predictions about what this
;       program does.
; 
; 6.    Identify the different structured branching constructs inside this
;       code: Identify IF,FOR,WHILE and BREAK.
; 
; 7.    Try to give the program input of 0x100000. Why does it take the program
;       so long to finish the calculation?

format PE console
entry start

include 'win32a.inc' 

; ===============================================
section '.text' code readable executable

start:
    
    call    read_hex        ; n
    mov     esi,eax         ; esi = n
    mov     ecx,2           ; ecx = o = 2

iters:  ; FOR o = 2; o < n; ++o
    mov     edi,1           ; edi = i = 1
    mov     ebx,0           ; ebx = j = 0

sum_divisors: ; FOR i = 1; i < o; ++i
    mov     eax,ecx         ; eax = o
    mov     edx,0           ; edx = 0
    div     edi             ; IF edx:eax % i == 0
    cmp     edx,0
    jnz     non_divisible
    add     ebx,edi         ; ebx = j + i
non_divisible:
    inc     edi             ; IF ++i == o
    cmp     edi,ecx
    jnz     sum_divisors

    cmp     ebx,ecx         ; IF j == o
    jnz     not_perfect
    mov     eax,ecx         ; eax = o
    call    print_eax       ; print o

not_perfect:
    inc     ecx             ; LOOP ++o != n ; !! KABOOM: 0,1,2 !! doesn't include 'n'
    cmp     ecx,esi
    jnz     iters

    ; Exit the process:
	push	0
	call	[ExitProcess]

include 'training.inc'

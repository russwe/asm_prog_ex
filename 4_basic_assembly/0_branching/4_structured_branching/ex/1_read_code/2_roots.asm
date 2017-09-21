; Basic Assembly
; ==============
; 
; Structured branching
; --------------------
;
; Roots
; @@@@
;
; 0.    Assemble and run this program.
; 
; 1.    How many inputs does this program expect? (Maybe non at all?)
;       0
;
; 2.    Read the program's code below, and try to understand what does it do. 
;       Try to describe it as simply as you can. What are the numbers seen at
;       the outputs? What do they mean?
;
;       Finds solutions to the equation: i^3 - 18d * i^2 + 101d * i - 168d = 0, between 1 and 10000000h ... talk about wasteful
;
; 3.    Add comments to the code, to make it more readable.
; 
; 4.    Identify the different structured branching constructs inside this
;       code: Identify IF,FOR,WHILE and BREAK.
;
; 5.    What happens if you change the first "mov ecx,10000000h" instruction?
;       For example, to the number 0ffffffffh? Why?
;
;       I am betting catastrophe due to overflow of edx register.

        The official answer says slower, with more outputs... while that is likely
        true, I don't believe all the outputs will be accurate, due to the overflow issue.

format PE console
entry start

include 'win32a.inc' 

; ===============================================
section '.text' code readable executable

start:
    
    mov     ecx,10000000h   ; i

looper: ; FOR i = 10000000h; i > 0; --i
    mov     eax,ecx     ; eax = i
    mul     ecx         ; edx:eax = i^2
    mov     esi,eax     ; esi = i^2
    mul     ecx         ; edx:eax = i^3
    mov     edi,eax     ; edi = i^3

    mov     eax,esi     ; eax = i^2
    mov     esi,18d     ; esi = 18d
    mul     esi         ; edx:eax = i^2 * 18d
    sub     edi,eax     ; edi = i^3 - i^2 * 18d

    mov     eax,ecx     ; eax = i
    mov     ebx,101d    ; ebx = 101d
    mul     ebx         ; edx:eax = i * 101d
    add     edi,eax     ; edi = i^3 - i^2 * 18d

    sub     edi,168d    ; edi = i^3 - 18d * i^2 - 168d

    cmp     edi,0       ; IF edi == 0
    jnz     skip_print

    mov     eax,ecx     ; eax = i
    call    print_eax   ; print i

skip_print:
    loop    looper


    ; Exit the process:
	push	0
	call	[ExitProcess]

include 'training.inc'

; Basic Assembly
; ==============
; 
; Bitwise operations - Practical bit games
; ----------------------------------------
;
; Leave
; @@@@@
;
; 0.    Assemble and run this program.
; 
; 1.    How many inputs does this program expect?
;       2
;
; 2.    Try to give different inputs to this program, and check the results.
;       Particularly, try the following input pair: (ffffffff,00000000).
;
; 3.    Read the program's code below, and try to understand what does it do. 
;       Try to describe it as simply as you can. Add comments if needed.
;       
;       Outputs the bits of the low word of a, interleaved with the bits of the low word of b.
;       i.e.: a7b7a6b6...a1b1a0b0
;
; 4.    Pick some random inputs and verify your predictions about what this
;       program does.
;

format PE console
entry start

include 'win32a.inc' 

; ===============================================
section '.text' code readable executable

start:
    call    read_hex            ; a
    mov     edx,eax             ; edx = a
    call    read_hex            ; b
    mov     esi,eax             ; esi = b

    mov     eax,edx             ; eax = a
    call    print_eax_binary
    mov     eax,esi             ; eax = b
    call    print_eax_binary

    ; Note that we only use the lower part of edx and esi.
    ; The upper part is ignored.

    mov     ecx,16d             ; 16 bits (1 WORD)

two_bits_iter:
    rol     dx,1                ; ROL1 dx (low-word of edx(a))
    movzx   edi,dx              ; edi = 0000 <dx>
    and     edi,1               ; edi = dx & 1
    shl     eax,1               ; eax = output << 1  NOTE: eax has b in it to start, but this loop overwrites
    or      eax,edi             ; eax |= edi

    rol     si,1                ; ROL1 si (low-word of esi(b))
    movzx   edi,si              ; edi = 0000 <dx>
    and     edi,1               ; edi = dx & 1
    shl     eax,1               ; eax = output << 1
    or      eax,edi             ; eax |= edi

    loop    two_bits_iter

    call    print_eax_binary    ; output is interleaved bits of a and b: a7b7a6b6...a1b1a0b0 

    ; Exit the process:
	push	0
	call	[ExitProcess]


include 'training.inc'

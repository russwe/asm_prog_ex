; Basic Assembly
; ==============
; 
; Memory ideas
; ------------
;
; Popcorn
; @@@@@@@
;
; 0.    Assemble and run this program.
;
; 1.    How many inputs does this program require? 
;       Try to give the program some inputs, and check out the results. 
;       1
;
; 2.    Read the program's code below, and try to understand what does it do. 
;       Try to describe it as simply as you can. Add comments if needed.
;
;       This appears to be a very strange way to do a population count.
;       The table as the pre-computed population counts for any given byte
;       as is used as a lookup table, byte by byte.
;
; 3.    Note the instruction: "add  dl,byte [esi + edi]". Is there a danger
;       of wraparound in dl? Why?
;
;       Nope:
;       - A byte ranges 0 to ff.
;       - There four passes in the loop.
;       - The maximum pop count for a byte is 8 (for ff)
;       - 8 * 4 = 32d (20h) < ff

format PE console
entry start

include 'win32a.inc' 

; ===============================================
section '.data' data readable writeable

                 ;  0  1  2  3  4  5  6  7  8  9  a  b  c  d  e  f
                 ;  ==============================================
    popcorn     db  0, 1, 1, 2, 1, 2, 2, 3, 1, 2, 2, 3, 2, 3, 3, 4  ; 0
                db  1, 2, 2, 3, 2, 3, 3, 4, 2, 3, 3, 4, 3, 4, 4, 5  ; 1
                db  1, 2, 2, 3, 2, 3, 3, 4, 2, 3, 3, 4, 3, 4, 4, 5  ; 2
                db  2, 3, 3, 4, 3, 4, 4, 5, 3, 4, 4, 5, 4, 5, 5, 6  ; 3
                db  1, 2, 2, 3, 2, 3, 3, 4, 2, 3, 3, 4, 3, 4, 4, 5  ; 4
                db  2, 3, 3, 4, 3, 4, 4, 5, 3, 4, 4, 5, 4, 5, 5, 6  ; 5
                db  2, 3, 3, 4, 3, 4, 4, 5, 3, 4, 4, 5, 4, 5, 5, 6  ; 6
                db  3, 4, 4, 5, 4, 5, 5, 6, 4, 5, 5, 6, 5, 6, 6, 7  ; 7
                db  1, 2, 2, 3, 2, 3, 3, 4, 2, 3, 3, 4, 3, 4, 4, 5  ; 8
                db  2, 3, 3, 4, 3, 4, 4, 5, 3, 4, 4, 5, 4, 5, 5, 6  ; 9
                db  2, 3, 3, 4, 3, 4, 4, 5, 3, 4, 4, 5, 4, 5, 5, 6  ; a
                db  3, 4, 4, 5, 4, 5, 5, 6, 4, 5, 5, 6, 5, 6, 6, 7  ; b
                db  2, 3, 3, 4, 3, 4, 4, 5, 3, 4, 4, 5, 4, 5, 5, 6  ; c
                db  3, 4, 4, 5, 4, 5, 5, 6, 4, 5, 5, 6, 5, 6, 6, 7  ; d
                db  3, 4, 4, 5, 4, 5, 5, 6, 4, 5, 5, 6, 5, 6, 6, 7  ; e
                db  4, 5, 5, 6, 5, 6, 6, 7, 5, 6, 6, 7, 6, 7, 7, 8  ; f

; ===============================================
section '.text' code readable executable

start:
    call    read_hex            ; x
    call    print_eax_binary

    xor     edx,edx             ; edx = 0
    mov     ecx,4               ; ecx = 4
    mov     esi,popcorn         ; esi = popcorn

one_iter:
    movzx   edi,al              ; edi = 0 + x.lowNibble             // 0 .. ff
    add     dl,byte [esi + edi] ; dl += [ popcorn + x.lowNibble ]   // edx
    ror     eax,8               ; eax >>= 8                         // x
    loop    one_iter            ; --ecx != 0 -> one_iter            // (4 loops)

    mov     eax,edx
    call    print_eax

    ; Exit the process:
	push	0
	call	[ExitProcess]

include 'training.inc'

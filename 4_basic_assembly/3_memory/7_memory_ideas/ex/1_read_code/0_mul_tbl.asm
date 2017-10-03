; Basic Assembly
; ==============
; 
; Memory ideas
; ------------
;
; Multiplication table
; @@@@@@@@@@@@@@@@@@@@
; 
; This program multiplies two numbers, but in a strange way.
;
; It first calculates all the possible multiplications of pairs of numbers
; between 0 and 9.
;
; Then it requests for input: A pair of numbers x,y.
; Finally it finds out the value in the cell (x,y) inside the table, and prints
; it as output.
;
; 0.    Read the following code. Make sure that you understand how to create and
;       access a two dimensional table.
; 
; 1.    Try to give the program the input numbers: a,a. What is the result? Why?
;       Make a small modification in the source code below so that the input a,a
;       will return the correct result.
;
;       0.  Lucky result, since '10' is not in the table as either a row, or a column
;
; 2.    Try to give the program an input of two very large numbers. Example:
;       10000,10000. What happens? Why?
;
;       Kersplode.  We finally reached a page we didn't have read (write?) access to.
;       (I'm betting on write access, since .text should follow .bss)
;

format PE console
entry start

include 'win32a.inc' 

WIDTH  = 11 ; 0 .. 10
HEIGHT = 11 ; 0 .. 10
; ===============================================
section '.bss' readable writeable
    ; Declare the uninitialized table in memory:
    mul_tbl     dd      WIDTH*HEIGHT dup (?)

; ===============================================
section '.text' code readable executable

start:
    ; Fill in the multiplication table:
    ; ---------------------------------
    mov     esi,mul_tbl         ; Cell ptr.
    mov     ecx,0               ; Row counter.

next_row:
    mov     ebx,0               ; Column counter.
next_column:
    mov     eax,ecx             ; eax = row #
    mul     ebx                 ; edx:eax = (row #) * (col #)
    mov     dword [esi],eax     ; [esi] = eax (low dword of result)

    add     esi,4               ; esi += 4  // move to the next DWORD in the array
    inc     ebx                 ; ebx++
    cmp     ebx,WIDTH           ; ebx != WIDTH
    jnz     next_column

    inc     ecx                 ; ecx++
    cmp     ecx,HEIGHT          ; ecx != HEIGHT
    jnz     next_row

    ; We read coordinates inside the table as input,
    ; And then print back the contents of the relevant cell:
    ; ------------------------------------------------------

    call    read_hex            ; Column
    mov     ebx,eax             ; ebx = col

    call    read_hex            ; Row   
    mov     ecx,eax             ; ecx = eax = row

    mov     edi,WIDTH*4         ; edi = WIDTH*4  // row offset: 4 is the size of a DWORD/cell in the table
    mul     edi                 ; edx:eax = eax * rowOffset
    lea     eax,[eax + ebx*4]   ; eax = (row * rowOffset) + col * 4  // again, 4 is the DWORD/cell size
    mov     esi,mul_tbl         ; esi = mul_tbl

    mov     eax,dword [esi+eax] ; eax = [ mul_tbl + (row * rowOffset) +(col * 4) ]
    call    print_eax

exit:
    ; Exit the process:
    push    0
    call    [ExitProcess]

include 'training.inc'

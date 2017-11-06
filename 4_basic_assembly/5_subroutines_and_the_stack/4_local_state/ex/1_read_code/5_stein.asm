; Basic Assembly
; ==============
; 
; Subroutines and the stack - Local state
; ---------------------------------------
; 
; Stein
; @@@@@
;
; 0.    Assemble and run this program.
;
; 1.    Give the program some example inputs, and observe the output.
;
; 2.    Skim the code. Take a look at the functions and their descriptions.
;       Understand the dependencies between the functions (Which function calls
;       which function), and what is the special purpose of every function.
;
; 3.    Read the program's code below, and try to understand what does it do. 
;       Try to describe it as simply as you can. Add comments if needed.
;
;       Fill in briefly the Input, Output and Operation comments for every
;       function in the code.
;
; 4.    Follow the contents of the stack as stein is being executed.
;       Hint: You can print the contents of a and b to the console at every
;       invocation of the stein function.
;
; 5.    Bonus: What is the complexity of this algorithm? How many invocations of
;       stein are expected for an initial pair of numbers (a,b)?
;
;       O(n^2)
;
;       https://en.wikipedia.org/wiki/Binary_GCD_algorithm
;

format PE console
entry start

include 'win32a.inc' 

; ===============================================
section '.data' data readable writeable
    enter_two       db  'Enter two numbers:',13,10,0
    result          db  'Result: ',0
; ===============================================
section '.text' code readable executable

start:
    ; Ask for two numbers:
    mov     esi,enter_two
    call    print_str

    ; Read two numbers:
    call    read_hex
;   mov     edx,eax
    push    eax

    call    read_hex
    push    eax

    ; Calculate result:
;   push    eax
;   push    edx
    call    stein
    add     esp,2*4

    ; Print result:
    mov     esi,result
    call    print_str
    call    print_eax

    ; Exit the process:
	push	0
	call	[ExitProcess]

; ===========================================================
; stein(a,b)
;
; Input:
;   a: int dword
;   b: int dword
; Output:
;   eax: ?
; Operations:
;   ?
;
stein:
    .a = 8                      ; Local Variable Offsets from EBP
    .b = 0ch
    enter   0,0                 ; Establish Frame
    push    esi                 ; Save Register State
    push    edi
    push    ecx
    push    ebx

    mov     esi,[ebp + .a]      ; esi = a
    mov     edi,[ebp + .b]      ; edi = b

    mov     eax,esi             ; eax = a
    test    edi,edi
    jz      .end_func           ; b == 0 -> end     // eax = a

    mov     eax,edi             ; eax = b
    test    esi,esi
    jz      .end_func           ; a == 0 -> end     // eax = b

    cmp     esi,edi
    jz      .end_func           ; a == b -> end     // eax = b

    xor     ebx,ebx             ; zero ebx

    mov     ecx,esi             ; ecx = a
    not     ecx                 ; ecx = ~a
    and     ecx,1               ; ecx = ~a && 1                 // ecx = 0, odd; 1, otherwise
    shr     esi,cl              ; esi = as = a >> (~a && 1)     // shift 'a' right by 0 or 1
    add     ebx,ecx             ; ebx = 0, if ecx low bit was 1 (odd); 1, otherwise (even)

    mov     ecx,edi             ; ecx = b
    not     ecx                 ; ecx = ~b
    and     ecx,1               ; ecx = ~b && 1                 // ecx = 0, odd; 1, otherwise
    shr     edi,cl              ; edi = bs = b >> (~b && 1)     // shift 'b' right by 0 or 1
    add     ebx,ecx             ; ebx = 0, both odd; 1, only one even; 2, both even

    test    ebx,ebx
    jnz     .not_both_odd       ; ebx != 0 -> .not_both_odd

    cmp     esi,edi
    jae     .a_bigger_equal     ; a >= b -> .a_bigger_equal
    xchg    esi,edi             ; Exchanges the contents of esi,edi (if b > a)
.a_bigger_equal:

    sub     esi,edi             ; esi = max(a,b) - min(a,b)     // neither 'a' nor 'b' have been shifted (both were odd)
    shr     esi,1               ; esi >>= 1
.not_both_odd:
    
    push    edi                 ; a = bs || min(a,b)
    push    esi                 ; b = as || (max(a,b) - min(a,b)) >> 1
    call    stein               ; recursively call stein
    add     esp,4*2             ; clean up stack

    mov     ecx,ebx             ; ecx = 0, if both were odd; 1, if only one was even; 2, if both were even
    shr     ecx,1               ; ecx >>= 1     // 1, if both were even; else 0
    shl     eax,cl              ; eax = a, if b == 0    // terminating state
                                ;       b, if a == 0    // terminating state
                                ;       b, if a == b    // terminating state
                                ;       r << 1, if a & b were both even
                                ;       r, otherwise

.end_func:
    pop     ebx
    pop     ecx
    pop     edi
    pop     esi

    leave
    ret

include 'training.inc'

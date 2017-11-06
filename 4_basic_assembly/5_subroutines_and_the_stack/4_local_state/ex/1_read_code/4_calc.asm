; Basic Assembly
; ==============
; 
; Subroutines and the stack - Local state
; ---------------------------------------
; 
; Calc
; @@@@
;
; 0.    Assemble and run this program.
;
; 1.    Observe the output.
;
; 2.    Skim the code. Take a look at the functions and their descriptions.
;       Understand the dependencies between the functions (Which function calls
;       which function), and what is the special purpose of every function.
;
; 3.    Read the program's code below, and try to understand what does it do. 
;       Try to describe it as simply as you can. Add comments if needed.
;
;       For every function: Fill in the Input, Output and Operation. Be brief
;       and to the point.
;
; 4.    Edge cases:
;
;       - What happens when the operator is not identified? How is it being
;         checked?
;           'def_op' is called.
;       - What happens if a digit is not identified? How is it being checked?
;           '0' is substituted, it checks by subtraciting '0' from the character
;           which will leave a number in the valid range 0 - 9 OR will be greater than
;           9 either due to actually being above the 0 - 9 range, or underflow.
;
; 5.    Add support for the XOR (^) and the OR (|) operators.
;
; 6.    Currently the program only supports decimal digits. Add support for
;       hexadecimal digits too.
;

format PE console
entry start

include 'win32a.inc' 

MAX_EXPR = 4
; ===============================================
section '.data' data readable writeable
    enter_exp       db  'Enter an expression of the form [digit][operator]'
                    db  '[digit]',13,10
                    db  'Examples: 1+2,3-5,4*3:',13,10
                    db  '>',0

    result          db  'The result is: ',0
    expr            db  MAX_EXPR dup (0)

    oper_tbl:  
    dd      def_op, def_op, def_op, def_op, def_op, def_op, def_op, def_op      ; 0
    dd      def_op, def_op, def_op, def_op, def_op, def_op, def_op, def_op      ; 1
    dd      def_op, def_op, def_op, def_op, def_op, def_op, def_op, def_op      ; 2
    dd      def_op, def_op, def_op, def_op, def_op, def_op, def_op, def_op      ; 3
    dd      def_op, def_op, def_op, def_op, def_op, def_op, and_op, def_op      ; 4
    dd      def_op, def_op, star_op, plus_op, def_op, minus_op, def_op, def_op  ; 5
    dd      def_op, def_op, def_op, def_op, def_op, def_op, def_op, def_op      ; 6
    dd      def_op, def_op, def_op, def_op, def_op, def_op, def_op, def_op      ; 7
    dd      def_op, def_op, def_op, def_op, def_op, def_op, def_op, def_op      ; 8
    dd      def_op, def_op, def_op, def_op, def_op, def_op, def_op, def_op      ; 9
    dd      def_op, def_op, def_op, def_op, def_op, def_op, def_op, def_op      ; 10
    dd      def_op, def_op, def_op, def_op, def_op, def_op, xor_op, def_op      ; 11
    dd      def_op, def_op, def_op, def_op, def_op, def_op, def_op, def_op      ; 12
    dd      def_op, def_op, def_op, def_op, def_op, def_op, def_op, def_op      ; 13
    dd      def_op, def_op, def_op, def_op, def_op, def_op, def_op, def_op      ; 14
    dd      def_op, def_op, def_op, def_op, or_op,  def_op, def_op, def_op      ; 15
    dd      def_op, def_op, def_op, def_op, def_op, def_op, def_op, def_op      ; 16
    dd      def_op, def_op, def_op, def_op, def_op, def_op, def_op, def_op      ; 17
    dd      def_op, def_op, def_op, def_op, def_op, def_op, def_op, def_op      ; 18
    dd      def_op, def_op, def_op, def_op, def_op, def_op, def_op, def_op      ; 19
    dd      def_op, def_op, def_op, def_op, def_op, def_op, def_op, def_op      ; 20
    dd      def_op, def_op, def_op, def_op, def_op, def_op, def_op, def_op      ; 21
    dd      def_op, def_op, def_op, def_op, def_op, def_op, def_op, def_op      ; 22
    dd      def_op, def_op, def_op, def_op, def_op, def_op, def_op, def_op      ; 23
    dd      def_op, def_op, def_op, def_op, def_op, def_op, def_op, def_op      ; 24
    dd      def_op, def_op, def_op, def_op, def_op, def_op, def_op, def_op      ; 25
    dd      def_op, def_op, def_op, def_op, def_op, def_op, def_op, def_op      ; 26
    dd      def_op, def_op, def_op, def_op, def_op, def_op, def_op, def_op      ; 27
    dd      def_op, def_op, def_op, def_op, def_op, def_op, def_op, def_op      ; 28
    dd      def_op, def_op, def_op, def_op, def_op, def_op, def_op, def_op      ; 29
    dd      def_op, def_op, def_op, def_op, def_op, def_op, def_op, def_op      ; 30
    dd      def_op, def_op, def_op, def_op, def_op, def_op, def_op, def_op      ; 31

; ===============================================
section '.text' code readable executable

start:
    ; Ask the user for expression:
    mov     esi,enter_exp
    call    print_str

    ; Read expression:
    mov     ecx,MAX_EXPR
    mov     edi,expr
    call    read_line

    ; Evaluate expression:
    push    expr
    call    eval
    add     esp,4

    ; Print result to console:
    mov     esi,result
    call    print_str
    call    print_eax

    ; Exit the process:
	push	0
	call	[ExitProcess]


; ===========================================================
; digit_to_num(digit_addr)
;
; Input:
;   &digit: A character representing a digit in b10
; Output:
;   eax: converted number
; Operation:
;   Converts a string into a double word
;
digit_to_num:
    .digit_addr = 8
    push    ebp
    mov     ebp,esp
    push    esi

    mov     esi,dword [ebp + .digit_addr]
    lodsb

    sub     al,'0'
    cmp     al,9
    jbe     .good_digit ; '0' >= && <= '9'
    cmp     al, 49
    jb      .bad_digit  ; < 'a'
    cmp     al, 54
    ja      .bad_digit  ; > 'f'

.good_hex:
    sub     al, 39      ; 49 - 39 = 10!
    jmp     .good_digit

.bad_digit:
    ; If invalid digit, we return zero:
    xor     eax,eax
.good_digit:
    movzx   eax,al
    pop     esi
    leave
    ret

; ===========================================================
; func_by_operator(oper_addr)
;
; Input:
;   &oper: Operator to map
; Output:
;   function pointer to the handler for a given operation
; Operation:
;   Maps an operator into the address of method which handles it
;
func_by_operator:
    .oper_addr = 8
    push    ebp
    mov     ebp,esp
    push    esi

    mov     esi,dword [ebp + .oper_addr] 
    lodsb
    movzx   eax,al
;   call    print_eax   ; DEBUG: Operator Discovery

    mov     esi,oper_tbl
    mov     eax,dword [esi + 4*eax]

    pop     esi
    leave
    ret


; ===========================================================
; eval(str_addr)
;
; Input:
;   &str: input of format # <op> #
; Output:
;   eax: The result of the operation on the two numbers.
; Operation:
;   Parses and process the numerical operation from the input string
;
eval:
    .str_addr = 8
    push    ebp
    mov     ebp,esp

    mov     esi,dword [ebp + .str_addr]
    push    esi
    call    digit_to_num
    add     esp,4
    mov     edx,eax

    inc     esi
    push    esi
    call    func_by_operator
    add     esp,4
    mov     edi,eax

    inc     esi
    push    esi
    call    digit_to_num
    add     esp,4

    push    eax
    push    edx
    call    edi
    add     esp,2*4

    leave
    ret

; ===========================================================
; op(a,b)
;
; Input:
;   a: number 1
;   b: number 2
; Output:
;   ?
; Operation:
;   ?
;

def_op:     ; *
    xor     eax,eax
    ret

and_op:     ; 0x26
    .a = 8
    .b = 0ch
    push    ebp
    mov     ebp,esp
    
    mov     eax, [ebp + .a]
    and     eax, [ebp + .b]
    
    leave
    ret

or_op:      ; 0x7c
    .a = 8
    .b = 0ch
    push    ebp
    mov     ebp,esp
    
    mov     eax, [ebp + .a]
    or      eax, [ebp + .b]
    
    mov     esp, ebp
    pop     ebp
    ret

xor_op:     ; 0x5e
    .a = 8
    .b = 0ch
    push    ebp
    mov     ebp,esp
    
    mov     eax, [ebp + .a]
    xor     eax, [ebp + .b]
    
    mov     esp, ebp
    pop     ebp
    ret

star_op:    ; 0x2a
    .a = 8
    .b = 0ch
    push    ebp
    mov     ebp,esp
    push    edx

    mov     eax,dword [ebp + .a]
    mul     dword [ebp + .b]
    
    pop     edx
    mov     esp, ebp
    pop     ebp
    ret

plus_op:    ; 0x2b
    .a = 8
    .b = 0ch
    push    ebp
    mov     ebp,esp

    mov     eax,dword [ebp + .a]
    add     eax,dword [ebp + .b]
    
    leave
    ret

minus_op:   ; 0x2d
    .a = 8
    .b = 0ch
    push    ebp
    mov     ebp,esp

    mov     eax,dword [ebp + .a]
    sub     eax,dword [ebp + .b]
    
    leave
    ret

include 'training.inc'

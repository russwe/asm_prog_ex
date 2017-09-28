;   8.  Bonus: Addition using bitwise operations.
;   
;       8.0   You are given two bits a,b. Show that their arithmetic sum is of the
;             form (a AND b, a XOR b).
;   
;             Example:
;   
;             1 + 0 = 01
;             And indeed: 0 = 1 AND 0, 1 = 1 XOR 0.
;   
;             ab      a^b   a+b
;             00      0     0
;             01      0     1
;             10      0     1
;             11      1     0
;   
;             Truth table looks good to me.
;   
;       8.1   Write a program that gets as inputs two numbers x,y (Each of size 4
;             bytes), and calculates their arithmetic sum x+y using only bitwise
;             instructions. (ADD is not allowed!).
;   
;             HINT: Try to divide the addition into 32 iterations.
;                   In each iteration separate the immediate result and the carry
;                   bits that are produced from the addition.
;

format PE console
entry start

include 'win32a.inc' 

; ===============================================
section '.text' code readable executable

;   eax: y
;   ebx: x
;   ecx: counter
;   edx: result

;   esi: carry / temp immediate
;   edi: immediate

;   ebp: temp/partial immediate

start:

    call    read_hex    ; x
    mov     ebx, eax

    call    read_hex    ; y

    xor     edx, edx
    xor     esi, esi
    mov     ecx, 32d
addLoop:
    ; x + c
    xor     edi, edi
    ror     ebx, 1
    rcl     edi, 1
    
    mov     ebp, edi    ; copy immediate to ebp (temp)
    xor     edi, esi    ; add the carry
    and     esi, ebp    ; compute the next carry
    
    mov     ebp, edi    ; copy immediate to ebp (temp)
    
    ; y + (x + c)
    xor     edi, edi
    ror     eax, 1
    rcl     edi, 1

    cmp     esi, 0
    je      noCarry
carry:
    mov     esi, edi
    xor     edi, ebp    ; add (x + c)
    mov     esi, 1      ; restore carry
    jmp     continue
noCarry:
    mov     esi, edi
    xor     edi, ebp    ; add (x + c)
    and     esi, ebp    ; compute the next carry
continue:
    ror     edi, 1
    rcr     edx, 1

    loop    addLoop

    mov     eax, edx
    call    print_eax

    ; Exit the process:
	push	0
	call	[ExitProcess]


include 'training.inc'
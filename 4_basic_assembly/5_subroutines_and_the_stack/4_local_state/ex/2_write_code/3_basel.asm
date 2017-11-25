;   3.  Basel
;       
;       Consider fractions. A fraction is denoted as a/b, where a and b are
;       integers. a is called the numerator, and b is called the denominator. For
;       this exercise we assume a >= 0, b > 0.
;   
;       The sum of two fractions is also a fraction. 
;   
;       In order to calculate the sum of a/b and c/d, we first find the least common
;       multiple (LCM) of b and d (Call it L), and then we get:
;       
;           a     c     a*(L/b) + c*(L/d)
;           -  +  -  =  -----------------
;           b     d             L
;   
;       Example:
;           1/2 + 1/3 = 5/6
;   
;       
;       Every fraction has a unique representation as a Reduced fraction. A reduced
;       fraction is a fraction where the numerator and the denominator have no
;       common divisors.
;   
;       Examples for reduced fractions:
;         1/3, 7/4, 18/61.
;   
;       Examples for fractions which are not in the reduced form:
;         2/4, 21/6, 42/164
;   
;   
;       0.  Define a struct to represent a fraction.
;   
;       1.  Write a function that transforms a fraction into the reduced form.
;   
;       2.  Write a function that takes the following arguments: a, b, dest_addr.
;           The function then creates a fraction a/b at address dest_addr. The
;           fraction will be stored in its reduced form.
;   
;       2.  Write a function that calculates the sum of two fractions. 
;           The result will be in the reduced form.
;           HINT: LCM(a,b) = (a*b) / GCD(a,b).
;   
;       3.  Write a function that prints a fraction nicely to the screen.
;   
;       4.  Calculate the following sum:
;           
;             1     1     1           1
;            --- + --- + --- + ... + ---  =  ?
;            1^2   2^2   3^2         9^2
;         
;       5.  Bonus: What value does this sum approximate?
;
;           pi^2 / 6  (https://en.wikipedia.org/wiki/Basel_problem)
;   
format PE console
entry start

include 'win32a.inc'

struct FRAC
    nm dd ? ; numerator
    dm dd ? ; denominator
ends

section '.const' data readable
    fmtBar  db  '%u / %u',13,10,0

section '.text' code readable executable
start:
    mov     ebp, esp
    sub     esp, sizeof.FRAC * 2
    .fa = sizeof.FRAC * -1
    .f1 = sizeof.FRAC * -2

    ; eax: numerator
    ; ebx: denominator
    ; ecx: counter (denom base)
    ; edi: frac dest
    ; esi: acc

.initAccumulator:
    
    lea     edi, [ebp + .fa]
    mov     eax, 1
    mov     ebx, 1
    call    buildFraction
    mov     esi, edi

    lea     edi, [ebp + .f1]
    mov     ecx, 1
.addLoop:
    inc     ecx

    ; ecx^2 -> ebx
    xor     edx, edx
    mov     eax, ecx
    mul     ecx
    mov     ebx, eax

    mov     eax, 1  ; reset eax 
    call    buildFraction
    
    push    edi
    push    esi
    call    addFraction

    cmp     ecx, 9
    jb      .addLoop

    push    esi
    call    printFraction

    add     esp, sizeof.FRAC * 2

exit:
    push    0
    call    [ExitProcess]

; CONVENTION: Callee cleans stack
;
; IN
;   f1:   fraction 1 (overwritten with result)
;   f2:   fraction 2
;
; OUT
;   f1 <- f1 + f2
;
;   f1n   f2n   f1n * f2d + f2n * f1d
;   --- + --- = ---------------------  >>  REDUCE 
;   f1d   f2d         f1d * f2d
;
addFraction:
    push    ebp
    mov     ebp, esp
    .f1 = 8
    .f2 = 12

    sub     esp, sizeof.FRAC * 1
    .dest = sizeof.FRAC * -1

    push    eax ; mult (left, edx:eax)
    push    ebx ; mult (right)
    push    ecx ; dest
    push    edx ; mult (edx:eax)
    push    edi ; frac ptr 1
    push    esi ; frac ptr 2

    lea     ecx, [ebp + .dest]
    mov     edi, dword [ebp + .f1]
    mov     esi, dword [ebp + .f2]

    ; DENOM (f1d * f2d)
    xor     edx, edx
    mov     eax, dword [esi + FRAC.dm]
    mov     ebx, dword [edi + FRAC.dm]
    mul     ebx
    mov     dword [ecx + FRAC.dm], eax

    ; NUM L (f1n * f2d)
    xor     edx, edx
    mov     eax, dword [esi + FRAC.nm]
    mov     ebx, dword [edi + FRAC.dm]
    mul     ebx
    mov     dword [ecx + FRAC.nm], eax

    ; NUM (L + f2n * f1d)
    xor     edx, edx
    mov     eax, dword [edi + FRAC.nm]
    mov     ebx, dword [esi + FRAC.dm]
    mul     ebx
    add     dword [ecx + FRAC.nm], eax

    push    ecx
    call    reduceFraction

    ; mov edi <- ecx (dest)
    mov     esi, ecx
    mov     ecx, sizeof.FRAC
    rep     movsb

    pop     esi
    pop     edi
    pop     edx
    pop     ecx
    pop     ebx
    pop     eax

    mov     esp, ebp
    pop     ebp
    ret     4*2

; CONVENTION: Callee cleans stack
;
; IN
;   f: fraction to reduce
; OUT
;   f: modified with redced value
;
; L = LCM(b,d)
;   a     c     a*(L/b) + c*(L/d)
;   -  +  -  =  -----------------
;   b     d             L 
reduceFraction:
    push    ebp
    mov     ebp, esp
    .f = 8

    push    eax ; gcd result, div (nm/dm)
    push    ebx ; div (gcd)
    push    edx ; div (0:eax)
    push    esi ; ptr frac

    mov     esi, dword [ebp + .f]
    push    dword [esi + FRAC.dm]
    push    dword [esi + FRAC.nm]
    call    gcd
    mov     ebx, eax

    xor     edx, edx

    mov     eax, dword [esi + FRAC.nm]
    div     ebx
    mov     dword [esi + FRAC.nm], eax

    mov     eax, dword [esi + FRAC.dm]
    div     ebx
    mov     dword [esi + FRAC.dm], eax

    pop     esi
    pop     edx
    pop     ebx
    pop     eax

    mov     esp, ebp
    pop     ebp
    ret     4*1

; LCM(a,b) = (a*b) / GCD(a,b).
lcm:
    mov     eax, 0
    ret     4*2

; Copied from local_state > read_code > stein.asm
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
gcd:
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
;   add     esp,4*2             ; clean up stack

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
    ret     4*2

; CONVENTION: register
;
; IN
;   eax: a
;   ebx: b
;   edi: dest addr
;
; OUT
;   FRAC struct @ dest addr (esi)
;
buildFraction:
    mov     dword [edi + FRAC.nm], eax
    mov     dword [edi + FRAC.dm], ebx
    ret

; CONVENTION: callee cleans stack
;
; IN
;   fraction pointer
;
; OUT
;   fraction displayed to STDOUT
;
printFraction:
    push    ebp
    mov     ebp, esp
    .pFrac = 8

    push    eax

    mov     eax, dword [ebp + .pFrac]
    push    dword [eax + FRAC.dm]
    push    dword [eax + FRAC.nm]
    push    fmtBar
    call    [printf]
    add     esp, 4*3

    pop     eax

    mov     esp, ebp
    pop     ebp
    ret     4

.exit:
    mov     eax, ecx
    pop     ecx
    ret

include 'training.inc'
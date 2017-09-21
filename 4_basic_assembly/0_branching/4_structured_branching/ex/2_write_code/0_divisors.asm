;   0. Write a program that takes the number n as input. Then it prints all the
;      numbers x below n that have exactly 2 different integral divisors (Besides 1
;      and x). 
;      
;      For example: 15 is such a number. It is divisible by 1,3,5,15. (Here 3 and 5
;      are the two different divisiors, besides 1 and 15).
;   
;      However, 4 is not such a number. It is divisible by 1,2,4.

format PE console
entry start

include 'win32a.inc'

section '.text' code readable executable

; Taking the dumb solution and just attempting division by all numbers >= 2 one after
; the other.  Prime factorization would speed this up considerably.

; esi: n
; edi: count of divisors

; ebx: current number (cur): from [6 to n)
; ecx: test number (test): from [2 to cur)

; eax: l-numerator/div result
; edx: h-numerator/remainder
start:
    call    read_hex
    cmp     eax, 7d         ; 6 is the first "two integral" number
    jb      exit

    mov     esi, eax        ; n = <in>
    mov     ebx, 6d         ; cur = 6
curLoop:
    mov     edi, 0d         ; count = 0
    mov     ecx, 2d         ; denom = 2
checkLoop:
    mov     edx, 0d
    mov     eax, ebx        ; numerator (cur)
    div     ecx             ; denominator (test)
    cmp     edx, 0d
    jne     nextCheckLoop   ; cur % test != 0
    inc     edi             ; ++count

nextCheckLoop:
    inc     ecx
    cmp     ecx, ebx
    jb      checkLoop

    cmp     edi, 2d
    jne     nextCurLoop
    mov     eax, ebx
    call    print_eax

nextCurLoop:
    inc     ebx
    cmp     ebx, esi
    jb      curLoop

exit:
    push    0
    call    [ExitProcess]

include 'training.inc'
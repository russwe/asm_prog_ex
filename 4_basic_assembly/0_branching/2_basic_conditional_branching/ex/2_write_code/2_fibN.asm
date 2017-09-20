;   2.  The Fibonacci series is the series of numbers where every number is the sum
;       of the two previous numbers. It begins with the numbers: 1,1,2,3,5,8,...
;       Write a program that takes as input the number n, and prints back the n-th
;       element of the fibonacci series.
;
;       Bonus question: What is the largest n that can be given to your program such
;       that it still returns a correct answer? What happens when it is given larger
;       inputs?
;
;       Max n: 2d (45 => 2971215073 ... anything more overflows 32-bits)
;       NOTE: The real fibbonacci sequesnce starts 0 1 1 2, not 1 1 2, and is
;             zero-indexed, so this won't match up with offical numbers found below:
;             http://www.maths.surrey.ac.uk/hosted-sites/R.Knott/Fibonacci/fibtable.html
;
;       If given larger inputs, the result overflows and continues without error, it
;       simply returns an incorrect value.

format PE console
entry start

include 'win32a.inc'

section '.text' code readable executable

; eax: n
; ebx: fibN-2
; ecx: fibN-1
; edx: fibN
start:
    call    read_hex    ; eax = n

    cmp     eax, 1h     ; index starting @ 0
    jle     simple

    mov     ecx, 1h     ; n-1
    mov     edx, 1h     ; n
fib:
    mov     ebx, ecx    ; n-2
    mov     ecx, edx    ; n-1

    add     edx, ebx
    
    dec     eax
    jnz     fib

    mov     eax, edx
    jmp     output

simple:
    mov     eax, 1h

output:
    call    print_eax

exit:
	push	0
	call	[ExitProcess]

include 'training.inc'
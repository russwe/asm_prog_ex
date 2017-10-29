;   0.  Prime counting
;   
;       We want to calculate the amount of prime numbers between 1 and n.
;   
;       Recall that a prime number is a positive integer which is only divisible by
;       1 and by itself. The first prime numbers are 2,3,5,7,11,13. (1 is not
;       considered to be prime).
;   
;       We break down this task into a few subtasks:
;   
;       0.  Write a function that takes a number x as input. It then returns 
;           eax = 1 if the number x is prime, and eax = 0 otherwise.
;   
;       1.  Write a function that takes a number n as input, and then calculates the
;           amount of prime numbers between 1 and n. Use the previous function that
;           you have written for this task.
;   
;       Finally ask for an input number from the user, and use the last function you
;       have written to calculate the amount of prime numbers between 1 and n.
;   
;       Bonus Question: After running your program for some different inputs, Can
;       you formulate a general rough estimation of how many primes are there
;       between 1 and n for some positive integer n?

format PE console
entry start

include 'win32a.inc'

section '.text' code readable executable
start:
    call    read_hex
    call    count_primes
    call    print_eax

exit:
    push    0
    call    [ExitProcess]

; IN: eax = n
; OUT: eax = count of primes from 2:n
count_primes:
    push    ebx
    push    ecx

    mov     ecx, eax
    xor     ebx, ebx
.count:
    mov     eax, ecx
    call    is_prime
    add     ebx, eax
    dec     ecx
    cmp     ecx, 1
    ja      .count

    mov     eax, ebx

.exit:
    pop     ecx
    pop     ebx
    ret

; IN: eax = n
; OUT: eax = 1 (prime), 0 (not prime)
is_prime:
    push    ebx
    push    ecx
    push    edx

    mov     ebx, eax
    cmp     ebx, 1
    jbe     .not_prime
    cmp     ebx, 3
    jbe     .prime
    test    bl, 1
    jz      .not_prime

    mov     ecx, 3
.check_prime:
    xor     edx, edx
    mov     eax, ebx
    div     ecx
    test    edx, edx    ; divided evenly?
    jz      .not_prime

    add     ecx, 2
    cmp     ecx, ebx
    jb      .check_prime

.prime:
    mov     eax, 1
    jmp     .exit

.not_prime:
    xor     eax, eax
.exit:
    pop     edx
    pop     ecx
    pop     ebx
    ret

include 'training.inc'
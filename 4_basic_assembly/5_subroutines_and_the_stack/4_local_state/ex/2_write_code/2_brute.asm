;   2.  Caesar
;       
;       The ROT13 transformation changes a latin letter into another latin letter in
;       the following method:
;   
;       We order all the latin letters 'a'-'z' on a circle. A letter is transformed
;       into the letter which could be found 13 locations clockwise.
;   
;       Example:
;         ROT13(a) = n
;         ROT13(b) = o
;         ROT13(p) = c
;         ROT13(c) = p
;   
;       Note that the ROT13 transform is its own inverse. That means:
;       ROT13(ROT13(x)) = x for every letter x.
;       We will use this transform to encode and decode text made of latin letters.
;   
;       Example:
;         'Somebody set up us the bomb.' -> 'Fbzrobql frg hc hf gur obzo.'
;         'Fbzrobql frg hc hf gur obzo.' -> 'Somebody set up us the bomb.'
;   
;       0.  Write a function that implements the ROT13 transform, and extend it a
;           bit: The function takes a character as input. If the character is a
;           latin letter, it is transformed. (13 places clockwise). If the character
;           is not a latin letter, it is left unchanged.
;   
;           Capital latin letters will result in capital letters after the
;           transform. Minuscule letters will result in minuscule letters.
;   
;           The function finally returns the transformed character.
;   
;       1.  Write a function that transforms a string. The function takes a null
;           terminated string as an argument, and transforms every letter in the
;           string, using the previously written function.
;   
;       2.  Write a program that takes a string from the user, and prints back to
;           the user the transformed string.
;   
;       3.  Tbbq wbo! Jryy qbar! -> Good job! Well done!
;           Unvy Pnrfne!

format PE console
entry start

include 'win32a.inc'

section '.const' data readable
    szPrompt    db      'Enter a string to ROT13 (Hail Caesar!): ', 0

section '.data' data readable writeable
    szText      db      255 dup(0)
    cch.szText = $ - szText + 1

section '.text' code readable executable
start:
    mov     esi, szPrompt
    call    print_str

    mov     edi, szText
    mov     ecx, cch.szText
    call    read_line

    mov     esi, edi
    call    transformString

    call    print_str

exit:
    push    0
    call    [ExitProcess]

; CONVENTION: ?
;
; IN
;   edi: null-terminated string to transform
; OUT
;   esi: transformed string (null terminated)
transformString:
    push    eax
    push    ecx
    push    edi
    push    esi

    xor     eax, eax
.doTransform:
    lodsb
    test    eax, eax
    jz      .terminate
    call    transformChar
    stosb
    jmp     .doTransform

.terminate:
    stosb   ; ax will be 0

    pop     esi
    pop     edi
    pop     ecx
    pop     eax
    ret

; CONVENTION: register
;
; IN
;   eax: character to transform
;
; OUT
;   eax: transformed character
;
; DESCRIPTION
;   If the character is a latin letter, it is transformed. (13 places clockwise).
;   If the character is not a latin letter, it is left unchanged.
;   
;   Capital latin letters will result in capital letters after the
;   transform. Minuscule letters will result in minuscule letters.
;
transformChar:
    .MOD = 'z' - 'a' + 1
    push    ebx

    ; A (65) - Z (90), a (97) - z (122)
    cmp     eax, 'a'
    jb      .maybeUpper
    cmp     eax, 'z'
    ja      .default

.latinLower:
    mov     ebx, eax
    mov     eax, 'a'
    sub     ebx, eax
    add     ebx, 13
    cmp     ebx, .MOD
    jb      .rotate
    jmp     .modulus

.maybeUpper:
    cmp     eax, 'A'
    jb      .default
    cmp     eax, 'Z'
    ja      .default
.latinUpper:
    mov     ebx, eax
    mov     eax, 'A'
    sub     ebx, eax
    add     ebx, 13
    cmp     ebx, .MOD
    jb      .rotate

.modulus:
    sub     ebx, .MOD

.rotate:
    add     eax, ebx

.default:
    ; eax = eax (no change)

    pop     ebx
    ret

include 'training.inc'
;   5.  Rotation overflow.
;   
;       The ror/rol instructions receive two arguments: dest and k. k is the amount
;       of bit locations we rotate. (k=1 means rotate one bit location).
;   
;       What happens if k is larger than the size of the argument? For example, what
;       would the following instructions do:
;   
;       5.0   ror   eax,54d
;   
;       5.1   rol   bx,19d
;   
;       5.2   ror   dh,10d
;   
;       5.3   mov   cl,0feh
;             ror   edx,cl
;   
;       5.4   ror   eax,1001d
;   
;       For each of those instructions:
;       - Check if it assembles.
;       - Write some code that includes that instruction, and find out what it does.

    ; in the cases where the rot amount exceeds the size of the data to roate,
    ; the data is instead roated by (rot amount) MOD (size of data)

    ror   eax,54d   ; 54d % 32d = 22d

    rol   bx,19d    ; 19d % 16d = 3d

    ror   dh,10d    ; 10d % 8d = 2d

    mov   cl,0feh   ; 0feh % 8d = 6d
    ror   edx,cl

;   ror   eax,1001d ; does not assemble.  1001d is out of range

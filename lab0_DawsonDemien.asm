%include "io.inc"

section .data
outmsg  db  "char["          ; label 'outmsg' is address of the first byte
chout   db  0,0,0,0,0,']'
        db  0

section .text
global CMAIN
CMAIN:
    mov ebp, esp     ; for correct debugging

    mov eax, 0       ; Set whole 4 byte register to 0
    mov ebx, 0       ;
    mov ecx, 5       ; Loop counter
    mov bl, 'a'      ; ASCII 'a' is 0x61
    mov bh, ' '      ; ASCII Blank character ' ' is 0x20
    mov esi,chout    ; label 'chout' is an address
next:
    PRINT_CHAR bl    ; Use 'help' to see the built-in I/O functions
    PRINT_CHAR bh    ;
    PRINT_HEX  1,bl  ; Prints 1 byte in hex
    NEWLINE
    mov  [esi],bl    ; [...] means touch the memory at the specified address
    inc  esi         ; increment (add 1) to the number (address) in ESI
    inc  bl          ; increment the number (an ASCII character) in BL
    dec  ecx         ; The instruction leaves status results in flags register
    jnz  next        ; Jump if zero flag is not set (result from previous instr)
    PRINT_STRING outmsg ; Print memory bytes (characters), starting from address outmsg
    NEWLINE
    
                     ; YOUR CODE STARTS AFTER THIS LINE
    mov esi, outmsg  ;address of outmsg is put into esi
tol:                 ;new label called tol used for the loop
    mov bl, [esi]    ;sets bl equal to the current byte in esi address
    and bl, bl       ;registers bl with itself checking that the bytes are the same (not sure how it affects staus flag)
    jz bol           ;jumps to the bol label if the flag is 0
    xor bl, 32       ;registers bl with the number 32 similar to AND but this does change bl
    mov [esi], bl    ;moves bl into the byte that the address esi is currently at
    inc esi          ;move to the next byte in the esi address
    jmp tol          ;moves back to the top of the tol loop
bol:
    PRINT_STRING outmsg ;prints the adress outmsg (esi)

                     ; YOUR CODE ENDS BEFORE HERE
    xor eax, eax
    ret
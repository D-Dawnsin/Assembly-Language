; STUDENT NAME: Dawson Demien 
;
%include "io.inc"
;
; Reads a ascii single character hex digit, '0' to '9' or 'a' to 'f'
;  (it is OK to ignore upper case 'A' to 'F')
;
; Converts this to the number, numerically 0 to 15
;
; Reads a string (up to 99 characters) a byte at a time,
;  xor-s each character with the number read in earlier,
;  saves both the original character and the munged version in buffers
;  and prints both the original and munged output.
;
; For example:
;  Input string:  O It Happens?
;  Result string: J%Lq%Mduu`kv:
;
; PUT YOUR DIGIT AND THE STRING TO CONVERT IN THE SASM INPUT WINDOW BEFORE
; YOU START EXECUTING THIS PROGRAM.  When you read a string in SASM
; it does not wait for your typing.
;
; 5O It Happens?   (will convert O It Happens?" with the number 5)
;
; If the encrypted result is a 0x7f, just don't encrypt it!
;
;--------------------------------------------------------------
; initialized data is put in the .data segment
;
section .data
;
; Messages
origmsg	db	"Originally: ", 0
nowmsg	db	" Now it is: ", 0
errmsg  db      " Non-hex digit encryption key.", 0
;
; uninitialized data is put in the .bss segment.
;
section .bss
fromstr resb 100    ; string to convert (reserve 100 byte)
tostr   resb 100    ; encrypted result

; code is put in the .text segment
;
section .text
        global  CMAIN
CMAIN:
    mov ebp, esp    ; Save stack frame in ebx

; Read a hex character
    GET_CHAR dl
    cmp dl, '0'     ;compares character to 0
    jl err          ;jl = jump if less than
    cmp dl, '9'
    jg L10          ;jg = jumps if greater than to L10
    sub dl, 48      ;else dl is between 0 and 9 so subtract 48
                    ;to convert to between 0 and 9 
    jmp L30         ;jumps to L30 when dl is between 0 and 15
    
    
L10:
    cmp dl, 'a'
    jl err          ;jumps to err if less than 'a' 
    cmp dl, 'f'
    jg err          ;jumps to err if greater than 'f'
    sub dl, 97      ;else dl is between a and f so subtract 97
                    ;to convert to between 10 and 15
    jmp L30         ;jumps to L30 when dl is between 0 and 15
         
;
; Pseudocode to Convert 0 to 9 digit:
;     if (dl >= '0' and dl <= '9') dl = dl - '0'  (48)
; 
;-----------
;  compare dl to '0', go to error if too small, compare to '9', go to L10 if bigger
;   then convert '0' to 0 in dl, and go to L30

;-------------------------
;  Here we start reading and processing the string
;---------------------------

L30:
;** HERE IS THE CODE THAT GOES BEFORE THE LOOP
; Starting address of unconverted string (which hasn't been read in yet!)
    mov  esi, fromstr
; Starting address of result string
    mov	ebx, tostr
    jmp next

; Here we will loop obtaining characters from the users
;  
next:
    GET_CHAR al     ;read a character
    mov	[esi],al    ;Save the character into fromstr
    inc esi         ;Need to increment because we are moving to the next spot in address
    
    cmp al, 10      ;if byte is equal to newline
    je loopdone     ;jump to loopdone
    cmp al, 00      ;if byte is equal to 00
    je loopdone     ;jump to loopdone
    
    xor al, dl
    cmp al, 0x7f
    jne notdel
    
    xor al, dl
    mov [ebx], al
    inc ebx         ;Need to increment because we are moving to the next spot in address
     
    jmp	next	    ;back to top of loop
    

; If the byte is a newline or a zero are done, 
;    then exit the loop by jumping to loopdone
;
;**

;  xor al with the key byte.  
;  check for 7f in the result, and xor-back in that case
;  put the result in tostr
;**

; ADVANCE THE TWO STRING ADDRESSES
;**
notdel:
    mov [ebx], al
    inc ebx
    jmp next

; Get here when finished
loopdone:
    xor	al,al	;put zero in al
    mov	[ebx], al ; zero-termination of the munged string
    mov	[esi], al ; zero-termination of the input string

; Print the original string using SASM I/O
;
    PRINT_STRING origmsg    ;  "Originally" message
    PRINT_STRING fromstr    ; The input string
    NEWLINE	           ; Call subroutine to print a newline

; Print the transformed string using SASM I/O
;
    PRINT_STRING nowmsg
    PRINT_STRING tostr
    
; All done
done:
    mov     eax, 0          ; return value from this method          
    ret
    
 ; Oops! Error message if the byte is not a valid hex character
 ; Print an error
 err:
    PRINT_STRING errmsg     ;prints error message
    jmp done
   
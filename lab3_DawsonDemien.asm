; Lab Bin (binary) program skeleton. Edit your name into the top of this file.
; Prints a number in binary and hex, also whether the number is plus or minus
;  This is a SASM lab
;
; -- Read a number
; -- Convert to 32 ascii '0' and '1' chars
; -- Convert to 8 ascii '0' through 'f' chars
; -- Print result
; -- Repeat, with negated number
; -- Print whether the original number is positive or negative
;
; The special number 12345 exits
;
%include "io.inc"
%define NEWLINE 10

section .data

break:  db   0Ah, 0Ah, 0
out1:   db   "The number is: ",0
out2:   db   0Ah , 0Ah, "The negative:  ",0
out3:   db   0Ah , 0Ah, "Your number is positive.",0
out4:   db   0Ah , 0Ah, "Your number is negative.",0
 
hexdig:   db   '0123456789abcdef'   ; Used for creating hex digit output


binbuf:    times 32 db 0            ; 32 bytes initialized to 0   
           db  " ", 0               ; I have binbuf and hexbuf called seperately now instead of only calling binbuf
hexbuf:    times 8 db 0             ; 8 bytes initialized to 0
           db   NEWLINE, 0          ; I end up calling hex buf too just so output looks better


section	.bss
N:	resd   1



section .text

global  CMAIN
CMAIN:
    mov ebp, esp; for correct debugging


; Fetch user's number
topofloop:
    GET_DEC 4,eax
    cmp	 eax,12345     ;Compare to exit number
    je	 byebye	      ;

; Conversions
    mov     	[N],eax
    call    	bincvt
    call    	hexcvt

; Print result
    PRINT_STRING out1
    PRINT_STRING binbuf
    PRINT_STRING break
    PRINT_STRING hexbuf
    

; Negate and do it again.
    mov	    eax,[N]
    neg	    eax
    call    	bincvt
    call    	hexcvt
    PRINT_STRING out2
    PRINT_STRING binbuf
    PRINT_STRING break      ;I added in a break print so that there is a line between outputs
    PRINT_STRING hexbuf     ;I also adjusted hexbuf and binbuf so that the output looks nicer


; Now print positive or negative by calling posneg
    call posneg
    jmp	topofloop
	
; Bye bye
byebye:
    mov     eax, 0
    ret

;-----
;  Put the printable '0' and '1' digits for the number in EAX into binbuf, suitable for printing.
bincvt:
    pusha   ; Save registers
    mov ecx, 32
    mov esi, binbuf
    
    l1:
        Rol eax, 1 
        mov ebx, eax
        AND ebx, 1
        ADD ebx, 30h 
        mov [esi], BL
        inc esi
        loop l1
        
    popa    ; Restore registers
    ret

;-----
;  Put the printable '0' to 'f' figits for the number in EAX into hexbuf, suitable for printing.

hexcvt:
    pusha
    mov ecx, 8
    mov esi, hexbuf
    
    l2:
        Rol eax, 4 
        mov ebx, eax
        AND ebx, 0fh
        mov edi, hexdig
        ADD edi, ebx
        mov BL, [edi]
        mov [esi], BL
        inc esi
        loop l2
        
    popa
    ret

;----
;  Print whether the number in EAX is positive or negative
posneg:
    pusha
    and	eax,eax	; Set flags without changing eax
    js	pn10
    PRINT_STRING out4
    jmp	pn20
    
pn10:	
    PRINT_STRING out3
pn20:
	popa
	ret
    ret
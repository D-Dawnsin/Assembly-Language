;
; file: lab8.asm
;
; Computes Ackermann's function recursively
;
; This is the skeleton program. The student fills in the ack() subroutine below.
;
; Main program:
; Reads two numbers x and y, calls ack(x,y) for each pair of numbers.
; Then prints result.
; Goes back and reads more numbers.
; Exits when x is negative.
;
; Ackerman's function int ack(int x, int);
;
; Parameters:
;    x  integer dword
;    y  integer dword
;    
; Return value in eax


%include "io.inc"


section .data
xeq     db      "x=", 0
yeq     db      ", y=", 0
ans	db	" ack(x,y)= ", 0

section .text
global CMAIN
CMAIN:
    mov ebp, esp; for correct debugging

        

; MAIN PROGRAM:
;   Read x
;   If x <0 just print a 0
;



next:
; Read next number x, if it is negative we are done.
    GET_DEC 4,eax    ; Read number from user
    and	eax,eax
    js	done

;  Now read number y, if it is negative we are done.
    GET_DEC 4,ebx    ; Read number from user
    and	ebx,ebx
    js	done

; Print both numbers

    PRINT_STRING xeq
    PRINT_DEC 4,eax
    PRINT_STRING yeq
    PRINT_DEC 4,ebx
    
;  Input is OK, call ack(x,y)

    push    ebx    ; put y on the stack, the 2nd argument to ack
    push    eax     ; put x on the stack, the 1st argument
    call    ack    ; call function, it returns answer in eax
    add	    esp,8  ; remove x, y from the stack

;  Result is in eax, print it.
printit:
    PRINT_STRING  ans ; print 'ack='
    PRINT_DEC 4,eax  ; print result
    NEWLINE
    jmp next
        
; All done
done  mov     eax, 0            ; return value from this method                  
      ret

; Ackermann's function
;
%define x       dword [ebp+8]   ; 1st argument on the stack
%define y       dword [ebp+12]  ; 2nd argument
;
ack:
        push    ebp         ; Set up base pointer
        mov     ebp, esp    ; Base pointer 
	push    ebx         ; Save 5 registers, we can use
        push    ecx
        push    edx
        push    esi
        push    edi

; If x == 0 return y + 1
	mov	eax, x	    ; Load argument x from stack
        mov     ebx, y      ; Load argument y from stack
	and	eax,eax     ; if x==0, the answer will be y+1
	jnz	ack10
	inc     ebx	    ; answer = y+1
        mov     eax,ebx     ;  (return answer in eax)
	jmp    ack90        ;    and return

; Rest of ack computation is here!

ack10:
    ;if y==0, return a(x-1, 1)
    and ebx, ebx            
    jnz ack20           ;if y == 0, the answer will be x-1
    mov ebx, 1          ;y = 1
    push ebx            ;push y=1 to stack
    dec eax             ;x = x-1
    push eax            ;push x-1 to stack
    call ack            ;a(x-1, 1)
    add esp, 8          ;push stack pointer back to top
    call printit
    
ack20:
    ;if both x and y are nonzero, return a(x-1, a(x, y-1)) or z = a(x, y-1) then a(x-1, z)
    dec ebx             ;y = y-1
    push ebx            ;push y-1
    push eax            ;push x
    cmp ebx, 1
    call ack            ;a(x, y-1)
    add esp, 8          ;add esp, 8
    mov ebx, eax        ;makes y = z
    push ebx            ;push result (z)
    dec eax             ;x = x-1
    push eax            ;push x-1
    call ack            ;call ack = a(x-1, z)
    add esp, 8
    call printit     

; Get here to return, with answer in eax
ack90:
        pop     edi
        pop     esi
        pop     edx
        pop     ecx
        pop     ebx       ; restore saved registers
        mov     esp, ebp
        pop     ebp
        ret

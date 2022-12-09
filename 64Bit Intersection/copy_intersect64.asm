; -----------------------------------------------------------------------------
; 64-bit program that treats all its command line arguments as integers and
; displays their average as a floating point number.  This program uses a data
; section to store intermediate results, not that it has to, but only to
; illustrate how data sections are used.
; -----------------------------------------------------------------------------

;    int main(int argc, char * argv[])    ;  2 arg function: integer arg count, array of strings holds the args. 
;
;    How to run program:   ./average  11 12 33 44
;    So rdi = argc = 5   (5 arguments)
;    rsi = address of array of pointers (addresses)
;         argv[0] ->  "./average"    argv[0] is an 8 byte quantity, holding the address of the first character of the str
;         argv[1] ->  "11"            8 byte quantity, holding the address of the first character of the str
;         argv[...]
;         argv[4] ->  "44"
;

        global   main
        extern   atoi
        extern   printf
        default  rel

        section  .text
main:
        dec      rdi                    ; argc-1, since we don't count program name
        jz       done
        mov      [count], rdi           ; save number of real arguments
accumulate:
        push     rdi                    ; save register across call to atoi
        push     rsi
        mov      rdi, [rsi+rdi*8]       ; argv[rdi]
        call     atoi                   ; now rax has the int value of arg (returns 						values of address)

        pop      rsi                    ; restore registers after atoi call
        pop      rdi
	mov	[nums + rdi*8], rax	;put converted argument into nums array
        dec      rdi                    ; count down
        jnz      accumulate             ; more arguments?

average:
        cvtsi2sd xmm0, [a]
        cvtsi2sd xmm1, [c]
        mov      rdi, format            ; 1st arg to printf
        mov      rax, 2                 ; printf is varargs, there is 1 non-int argument'
	subsd	xmm0, xmm1		;subtracts c from a and stores in a
	jnz 	nonparallel		;jumps if a is not zero
	movss xmm1, xmm0		;puts 0 into other pointer
       	jmp print

        ret

nonparallel:
	
	;x-intercept
	
	cvtsi2sd xmm2, [b]		;loads in b to xmm2
        cvtsi2sd xmm3, [d]		;loads in d to xmm3
	subsd xmm3, xmm2		;d = d-b
	divsd xmm3, xmm0		;d = d/a
	movss xmm0, xmm3			;stores the xptr into xmm0

	;y-intercept
	
	cvtsi2sd xmm4, [a]		;a = xmm4
        mulsd xmm4, xmm0		;a = a*xptr
	cvtsi2sd xmm5, [b]
	addsd xmm5, xmm4		;b = b+xptr(a)[in other words "a"]
	movss xmm1, xmm5			;moves result (yptr) into xmm1

	jmp done		

print:

	sub      rsp, 8                 ; align stack pointer
        call     printf                 ; printf(format, xptr/yptr [xmm0/xmm1])
        add      rsp, 8                 ; restore stack pointer
	ret

no_inter_print:

	mov 	rdi, no_inter           ; align stack pointer
	sub	rsp, 8
        call     printf                 ; printf(format, xptr/yptr [xmm0/xmm1])
        add      rsp, 8                 ; restore stack pointer
	ret

done: 
	xor      rax, rax 
	call     printf 
	ret


        section  .data
count:  dq       0                        ; dq = 8 bytes, 64 bits
sum:    dq       0
nums:	dq	0
a:	dq	0
b:	dq	0
c:	dq	0
d:	dq	0
format:	db	"x-intercept=%g y-intercept=%g", 10, 0 ;printf
no_inter:db	"There is no intercept for the two lines", 10, 0

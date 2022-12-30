.section .rodata
invalid_input_message:	.string	"invalid input!\n"

.text
.globl pstrlen
.type pstrlen, @function
pstrlen:
	pushq   %rbp            #save the old frame pointer
	movq    %rsp, %rbp	    #create the new frame pointer

    movzbq  (%rdi), %rax    #saves the length of the pstring in the return value.

    movq    %rbp, %rsp      #restore the old stack pointer - release all used memory.
	popq    %rbp            #restore old frame pointer (the caller function frame)
	ret                     #return to caller function (OS)

.globl replaceChar
.type replaceChar, @function
replaceChar:
	pushq   %rbp            #save the old frame pointer
	movq    %rsp, %rbp	    #create the new frame pointer

    movb    (%rdi), %r8b    #saves the length of the pstring.
    movq    %rdi, %r9       #duplicates the pstring's address for the iteration.
string_iterator:
        incq %r9            #moving to the next place in the string. 
        cmpb %sil, (%r9)    #cmpb between the old-letter and the current letter.
        jne no_swap         #if they are not equal we don't wanna swap them so we will skip it.
        movb %dl, (%r9)     #if we didn't jump we wanna swap them.
no_swap:
        decb %r8b           #decreasing the counter.
        jnz string_iterator #if the counter is equal to 0 we need to finish the iteration.

    movq    %rbp, %rsp      #restore the old stack pointer - release all used memory.
	popq    %rbp            #restore old frame pointer (the caller function frame)
	ret                     #return to caller function (OS)


.globl pstrijcpy
.type pstrijcpy, @function
pstrijcpy:
	pushq	%rbp        #save the old frame pointer
	movq	%rsp, %rbp  #create the new frame pointer
    pushq   %rdi        #save the address of the src pstring.

    movzbq  %dl, %rdx   #reset the rest of %rdx that is not %dl. 

    cmpb    %dl, %cl            #cmpb the relation between i and j.
    jb      pstrijcpy_error     #if j < i we will jump to the error section.

    cmpb    $0, %dl             #cmpb the relation between i and 0.
    jb      pstrijcpy_error     #if i < 0 we will jump to the error section.

    cmpb    %cl, (%rdi)         #cmpb the relation between j and the first pstring's length.
    jbe      pstrijcpy_error     #if length <= j we will jump to the error section.

    cmpb    %cl, (%rsi)         #cmpb the relation between j and the second pstring's length.
    jbe      pstrijcpy_error     #if length <= j we will jump to the error section.


    leaq    1(%rdi), %r8    #r8 now points to the dest string without the length.
    leaq    1(%rsi), %r9    #r9 now points to the src string without the length.
    addq    %rdx, %r8       #we jump to the i-th letter in the dest string.
    addq    %rdx, %r9       #we jump to the i-th letter in the src string.
    movq    %rdx, %r10      #copy the value of i to the %r10 register.
    decq    %r10
pstrijcpy_string_iterator:
    movb    (%r9), %r11b            #saves the letter in the k-th place (k changes) in src pstring.
    movb    %r11b, (%r8)            #changes the letter in the k-th place (k changes) in dst pstring to the correct letter.
    incq    %r8                     #moving to the next place in the dst string. 
    incq    %r9                     #moving to the next place in the src string. 
    incq    %r10                    #inq the counter.
    cmpb    %r10b, %cl              #cmpb between our counter (%r10b) and j (%cl)
    jne pstrijcpy_string_iterator   #if %r10b == %cl, that means we iterated the entire string (from i to j) so we will stop.
    jmp pstrijcpy_no_error          #we finished the iteration without problen so we will jump to the end of the function.


pstrijcpy_error:
    movq	$invalid_input_message, %rdi    #the string is the only paramter passed to the printf function
    movq    $0, %rax                        #resets %rax for the printf function.
    pushq   %rax                            #push 8 byte to the stack for the 16-aline (for the printf function).
    call    printf                          #calling printf
    popq    %rax                            #pop the previous rax - we won't use it!
pstrijcpy_no_error:


    popq    %rax        #restore the address of the src pstring as the return value.
    movq	%rbp, %rsp	#restore the old stack pointer - release all used memory.
	popq	%rbp		#restore old frame pointer (the caller function frame)
	ret			#return to caller function (OS)

.globl swapCase
.type swapCase, @function
swapCase:
	pushq	%rbp        #save the old frame pointer
	movq	%rsp, %rbp  #create the new frame pointer

    movq    %rdi, %rcx      #duplicates the pstring address for the iterator
    cmpb    $0, 1(%rcx)  #if the first letter is \0 so the string is "" and we will finish.
    je skip_iteration       #as I wrote before we will finish in case they are equal.
swapCase_string_iterator:
    incq %rcx           #moving to the next place in the string. 
    cmpb $123, (%rcx)   #
    jae swapCase_finish #
    cmpb $64, (%rcx)    #
    jbe swapCase_finish #
    cmpb $97, (%rcx)    #
    jb not_lowercase    #
    subb $32, (%rcx)    #
    jmp swapCase_finish #
not_lowercase:
        cmpb $91, (%rcx)
        jae swapCase_finish
        addb $32, (%rcx)
swapCase_finish:
        cmpb $0, 1(%rcx)
        jne swapCase_string_iterator
skip_iteration:

    movq    %rdi, %rax
    movq	%rbp, %rsp	#restore the old stack pointer - release all used memory.
	popq	%rbp		#restore old frame pointer (the caller function frame)
	ret			#return to caller function (OS)


.globl pstrijcmp
.type pstrijcmp, @function
pstrijcmp:
	pushq	%rbp        #save the old frame pointer
	movq	%rsp, %rbp  #create the new frame pointer

    movq    $0, %r11
    pushq   %r11

    cmpb    %dl, %cl            #cmpb the relation between i and j.
    jb      pstrijcmp_error     #if j < i we will jump to the error section.

    cmpb    $0, %dl             #cmpb the relation between i and 0.
    jb      pstrijcmp_error     #if i < 0 we will jump to the error section.

    cmpb    %cl, (%rdi)         #cmpb the relation between j and the first pstring's length.
    jbe      pstrijcmp_error    #if length < j we will jump to the error section.

    cmpb    %cl, (%rsi)         #cmpb the relation between j and the second pstring's length.
    jbe      pstrijcmp_error    #if length < j we will jump to the error section.


    leaq    1(%rdi), %r8    #r8 now points to the dest string.
    leaq    1(%rsi), %r9    #r9 now points to the src string.
    addq    %rdx, %r8       #we jump to the i-th letter in the dest string.
    addq    %rdx, %r9       #we jump to the i-th letter in the src string.
    movq    %rdx, %r10      #copy the value of i to the %r10 register.
    incb    %cl
pstrijcmp_string_iterator:
    movb (%r8), %al        #move the i-th letter in the dest string to a register.
    movb (%r9), %r11b
    cmpb %al, %r11b         #compare the letters.
    ja pstr2_is_larger      #if pstr2 is larger we will jump to pstr2_is_larger.
    jb pstr1_is_larger      #if pstr1 is larger we will jump to pstr1_is_larger.
    incq    %r8             #moving to the next place in the dst string. 
    incq    %r9             #moving to the next place in the src string. 
    incq    %r10            #inq the counter      
    cmpb    %r10b, %cl      #cmpb between our counter (%r10b) and j (%cl)
    jne pstrijcmp_string_iterator   #if they are not equal we will continue the iteration.
    jmp pstrijcmp_no_error

pstr1_is_larger:    #if pstr1 is larger we will push 1 to the stack and continue.
    movq    $1, %r11
    pushq   %r11
    jmp     pstrijcmp_no_error
pstr2_is_larger:    #if pstr2 is larger we will push -1 to the stack and continue.
    movq    $-1, %r11
    pushq   %r11
    jmp     pstrijcmp_no_error
pstrijcmp_error:    #if pstr1 is larger we will push 1 to the stack and print error message.
    movq    $-2, %r11
    pushq   %r11                            
    movq	$invalid_input_message, %rdi	#the string is the only paramter passed to the printf function
    movq    $0, %rax                        #reseting %rax for the printf function.
    call    printf
pstrijcmp_no_error:

    popq    %rax        #saving the return number in %rax as the return value.
    movq	%rbp, %rsp	#restore the old stack pointer - release all used memory.
	popq	%rbp		#restore old frame pointer (the caller function frame)
	ret			        #return to caller function (OS)


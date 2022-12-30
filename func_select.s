    .section .rodata
    case_31_printf_format:	    .string	"first pstring length: %d, second pstring length: %d\n"
    case_32_33_printf_format:	.string	"old char: %c, new char: %c, first string: %s, second string: %s\n"
    case_32_33_scanf_format:    .string " %c %c"
    case_35_printf_format:	    .string	"length: %d, string: %s\n"
    case_35_37_scanf_format:    .string " %d"
    case_36_printf_format:	    .string	"length: %d, string: %s\n"
    case_37_printf_format:	    .string	"compare result: %d\n"
    invalid_option:             .string "invalid option!\n"


    .align 8    # Align address to multiple of 8
.L10:
    .quad .L0   # Case 31
    .quad .L1   # Case 32
    .quad .L2   # Case 33
    .quad .L7   # Case 34
    .quad .L4   # Case 35
    .quad .L5   # Case 36
    .quad .L6   # Case 37
    .quad .L7   # Defualt case


.text
.globl run_func
.type run_func, @function
run_func:
	pushq	%rbp        #save the old frame pointer
	movq	%rsp, %rbp	#create the new frame pointer

    #saves the registers in order to use them inside this function.
    pushq   %r12
    pushq   %r13
    pushq   %r14
    pushq   %r15

    movq    %rsi, %r12
    movq    %rdx, %r13

    # Set up the jump table access
    movq    %rdi,%rsi       
    sub     $31, %rsi       # Compute xi = x-31
    cmpq    $7,%rsi         # Compare xi:6
    ja      .L7             # if >, goto default-case
    jmp     *.L10(,%rsi,8)  # Goto jt[xi]

.L3:
end_jump:
    #restores the registers.
    popq   %r15
    popq   %r14
    popq   %r13
    popq   %r12

    movq    %rbp, %rsp  #restore the old stack pointer - release all used memory.
	popq	%rbp        #restore old frame pointer (the caller function frame)
	ret                 #return to caller function (OS)



.L0:
    movq	%r12, %rdi	#copy the address of the first string in order for it to be the first argument. 
    call	pstrlen		#runs a function that will return the length of the first string.
    movq	%rax, %r14	#r14 will hold the length of the first string.

    movq	%r13, %rdi	#copy the adress of the second string in order for it to be the first argument.
    call	pstrlen		#runs a function that will return the length of the second string.
    movq	%rax, %rdx	#rdx will hold the length of the second string.


    movq	%r14, %rsi	#copy the length of the first string in order for it to be the first argument in printf.

    movq	$case_31_printf_format, %rdi	#passing the string format as the first argument of printf.
    call	printf				            #calling printf
    jmp     end_jump

.L1:
.L2:
    subq	$16, %rsp                       #allocating 16 bytes in the stack memory in order to call scanf.

    movq	$case_32_33_scanf_format, %rdi  #passing the string format as the first argument of scanf.
    leaq	16(%rsp), %rsi			        #passing the address for the old char as the second argument of scanf.
    leaq    15(%rsp), %rdx
    call	scanf				            #calling scanf.
    movzbq	16(%rsp), %r14			        #saving the char in a register.
    movzbq  15(%rsp), %r15

    movq	%r12, %rdi			#passing the first pstring's address as the first parameter of replaceChar.
    movq	%r14, %rsi			#passing the old char as the second parameter of replaceChar.
    movq	%r15, %rdx			#passing the new char as the third paramenter of replaceChar.
    call	replaceChar			#calling replaceChar.

    movq	%r13, %rdi			#passing the second pstring's address as the first parameter of replaceChar.
    movq	%r14, %rsi			#passing the old char as the second parameter of replaceChar.
    movq	%r15, %rdx			#passing the new char as the third paramenter of replaceChar.
    call	replaceChar			#calling replaceChar.

    movq	$case_32_33_printf_format, %rdi	#passing the string format as the first argument of scanf.
    movq	%r14, %rsi			#passing the old char as the second parameter of printf.
    movq	%r15, %rdx			#passing the new char as the third parameter of printf.
    leaq	1(%r12), %rcx       #passing the first string's address as the fourth parameter of printf.
    leaq 	1(%r13), %r8		#passing the second string's address as the fifth parameter of printf.
    call	printf				#calling replaceChar.
    addq	$16, %rsp           #allocating 16 bytes in the stack memory in order to call scanf.
    jmp     end_jump


.L4:
    subq	$16, %rsp	                    #allocating 16 bytes in the stack memory in order to call scanf.

    movq	$case_35_37_scanf_format, %rdi	#passing the string format as the first argument of scanf.
    leaq	16(%rsp), %rsi			        #passing an address as the second parameter of scanf.
    call	scanf				            #calling scanf.

    movq	$case_35_37_scanf_format, %rdi	#passing the string format as the first argument of scanf.
    leaq	8(%rsp), %rsi			        #passing an address as the second parameter of scanf.
    call	scanf				            #calling scanf.

    movq	%r12, %rdi	                    #passing the first pstring's address as the first argument of pstrijcpy.
    movq	%r13, %rsi	                    #passing the second pstring's address as the second argument of pstrijcpy.
    movl	16(%rsp), %edx	                #passing i as the third argument of pstrijcpy. 
    movl	8(%rsp), %ecx	                #passing j as the fourth argument of pstrijcpy. 
    call	pstrijcpy	                    #calling pstrijcpy.
    movzbq	(%rax), %rsi                    #passing the pstring's length as the fourth argument of printf.
    leaq	1(%rax), %rdx                   #passing the pstring's address as the third argument of printf.
    movq	$case_35_printf_format, %rdi    #passing the string format as the first argument of scanf.
    movq    $0, %rax
    call	printf                          #calling printf.

    movq	$case_35_printf_format, %rdi    #passing the string format as the first argument of scanf.
    movzbq	(%r13), %rsi                    #passing the pstring's length as the fourth argument of printf.
    leaq    1(%r13), %rdx
    movq    $0, %rax
    call	printf                          #calling printf.

    addq    $16, %rsp
    jmp     end_jump

.L5:
    movq    %r12, %rdi                      #passing the first pstring's address as the first argument of swapCase.
    call    swapCase                        #calling swapCase.
    movzbq  (%r12), %rsi                    #passing the pstring's length as the second argument of printf.
    movq    $case_36_printf_format, %rdi    #passing the string format as the first argument of printf.
    leaq    1(%r12), %rdx                   #passing the pstring's address as the third argument of printf.
    movq    $0, %rax
    call    printf                          #calling printf.

    movq    %r13, %rdi                      #passing the second pstring's address as the first argument of swapCase.
    call    swapCase                        #calling swapCase.
    movzbq  (%r13), %rsi                    #passing the pstring's length as the second argument of printf.
    movq    $case_36_printf_format, %rdi    #passing the string format as the first argument of printf.
    leaq    1(%r13), %rdx                   #passing the pstring's address as the third argument of printf.
    movq    $0, %rax
    call    printf                          #calling printf.
    jmp     end_jump


.L6:
    subq    $16, %rsp                       #allocating 16 bytes in the stack memory in order to call scanf.

    movq	$case_35_37_scanf_format, %rdi	#passing the string format as the first argument of scanf.
    leaq    16(%rsp), %rsi                  #passing an address as the second parameter of scanf.
    call    scanf                           #calling scanf.

    movq	$case_35_37_scanf_format, %rdi	#passing the string format as the first argument of scanf.
    leaq    8(%rsp), %rsi                   #passing an address as the second parameter of scanf.
    call    scanf                           #calling scanf.

    movq    %r12, %rdi                      #passing the first pstring's address as the first argument of pstrijcmp.
    movq    %r13, %rsi                      #passing the second pstring's address as the second argument of pstrijcmp.
    movl    16(%rsp), %edx                   #passing i as the third argument of pstrijcpy.
    movl    8(%rsp), %ecx                   #passing j as the third argument of pstrijcpy.
    call    pstrijcmp

    movq    $case_37_printf_format, %rdi    #passing the string format as the first argument of printf.
    movq    %rax, %rsi                      #passing the pstrijcmp function's return value as the second parameter of printf.
    movq    $0, %rax
    call    printf                          #calling printf.
    jmp     end_jump

.L7:
    
    movq    $invalid_option, %rdi    #passing the string format as the first argument of printf.
    movq    $0, %rax
    call    printf                          #calling printf.
    jmp     end_jump

 

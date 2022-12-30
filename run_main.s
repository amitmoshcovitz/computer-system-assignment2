.section .rodata
invalid_input_message:	.string	"invalid input!\n"
number_format:  .string " %d"
string_format:  .string "%s"

.text
.globl run_main
.type run_main, @function
run_main:
	pushq	%rbp        #save the old frame pointer
	movq	%rsp, %rbp  #create the new frame pointer

    subq	$512, %rsp  #allocating 512 bytes in the stack memory in order to call scanf.

    #saving from the user the length of the first pstring in the first byte.
    movq    $number_format, %rdi
    leaq    256(%rsp), %rsi
    movq    $0, %rax
    call    scanf

    #saving from the user string itself in the next bytes.
    movq    $string_format, %rdi
    leaq    257(%rsp), %rsi
    movq    $0, %rax
    call    scanf

    #saving from the user the length of the second pstring in the first byte.
    movq    $number_format, %rdi
    leaq    (%rsp), %rsi          
    movq    $0, %rax                
    call    scanf               

    #saving from the user string itself in the next bytes.
    movq    $string_format, %rdi
    leaq    1(%rsp), %rsi
    movq    $0, %rax
    call    scanf

    #saving from the user the option number.
    subq	$16, %rsp   #allocating 16 bytes in the stack memory in order to call scanf.
    movq    $number_format, %rdi
    leaq    (%rsp), %rsi          
    movq    $0, %rax                
    call    scanf     

    #moving everything to the arguments of run_func and calling run_func.
    movl    (%rsp), %edi
    leaq    272(%rsp), %rsi
    leaq    16(%rsp), %rdx  
    call    run_func

    movq	%rbp, %rsp	#restore the old stack pointer - release all used memory.
	popq	%rbp		#restore old frame pointer (the caller function frame)
    ret


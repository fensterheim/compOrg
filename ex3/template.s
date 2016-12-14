#-----------readOnlyData--------------
	.section .rodata
#---------------data------------------
	.data
#---------------text------------------
	.text
.globl main
	.type	main, @function
main:
	pushq	%rbp
	movq	%rsp,	%rbp
	#...save callee-save registered if needed
	#...the program code
	#...restoring calee-save registers if needed
	movq	%rbp,	%rsp
	popq	%rbp
	ret
	


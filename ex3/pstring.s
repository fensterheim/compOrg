#-----------readOnlyData--------------

	.section .rodata

.TESTSTRING:
	.string "in case %d\n"

#---------------data------------------

	.data

#---------------text------------------

	.text

.globl pstrlen
	.type	pstrlen, @function
.globl replaceChar
	.type	replaceChar, @function
.globl pstrijcpy
	.type	pstrijcpy, @function
.globl swapCase
	.type	swapCase, @function
.globl pstrijcmp
	.type	pstrijcmp, @function

pstrlen:
	pushq	%rbp
	movq	%rsp,	%rbp
	#...save callee-save registered if needed
	movzbq	(%rdi),%rax	#put return value the first char of the pstring
	#...restoring calee-save registers if needed
	movq	%rbp,	%rsp
	popq	%rbp
	ret

replaceChar:
	#%rdi - pstring
	#%rsi - oldChar
	#%rdx - newChar
	pushq	%rbp
	movq	%rsp,	%rbp
	#...save callee-save registered if needed
	movq	$1,%rdx		#index
	movzbq	%dil,%r11	#get the length
.replaceFor:
	#TODO test if this works
	leaq	(%rdi, %rdx,),%r10
	cmpb	%r10,%rsi
	jne	.continueFor
	movb	%dl,%r10
.continueFor:
	addq	$1,%rdx
	cmpq	%rdx,%r11
	ja	.replaceFor
	movq	%rdi,%rax
	#...restoring calee-save registers if needed
	movq	%rbp,	%rsp
	popq	%rbp
	ret

pstrijcpy:
	pushq	%rbp
	movq	%rsp,	%rbp
	#...save callee-save registered if needed
	movq	$.TESTSTRING, %rdi
	movq	$52,%rsi
	call	printf
	#...restoring calee-save registers if needed
	movq	%rbp,	%rsp
	popq	%rbp
	ret
swapCase:
	pushq	%rbp
	movq	%rsp,	%rbp
	#...save callee-save registered if needed
	movq	$.TESTSTRING, %rdi
	movq	$53,%rsi
	call	printf
	#...restoring calee-save registers if needed
	movq	%rbp,	%rsp
	popq	%rbp
	ret

pstrijcmp:
	pushq	%rbp
	movq	%rsp,	%rbp
	#...save callee-save registered if needed
	movq	$.TESTSTRING, %rdi
	movq	$54,%rsi
	call	printf
	#...restoring calee-save registers if needed
	movq	%rbp,	%rsp
	popq	%rbp
	ret
	


#-----------readOnlyData--------------
	
	.section .rodata

.DFST:
	.string "invalid option!\n"
.INPC:
	.string "%c%c"
.INPI:
	.string "%d%d"
.LEN:
	.string "first pstring length: %d, second pstring length: %d\n"
.RPLCR:
	.string "old char: %c, new char: %c, first string: %s, second string: %s\n"
.teststring:
	.string "in case %d\n"
	.align	8
.JTBL:
	.quad	.CS50
	.quad	.CS51
	.quad	.CS52
	.quad	.CS53
	.quad	.CS54 

#---------------data------------------
	
	.data

#---------------text------------------
	
	.text

.globl run_func
	.type	run_func, @function

run_func:
	#%rdi - opt
	#%rsi - p1
	#%rdx - p2
	pushq	%rbp
	movq	%rsp,%rbp
	pushq	%rbx	#push calee saved
	pushq	%r12
	pushq	%r13
	pushq	%r14
	pushq	%r15
	pushq	%rbp	#end push calee saved
	leaq	-50(%rdi),%r11
	cmpq	$4,%r11
	ja	.DFLT
	jmp	*.JTBL(,%r11,8)
	#...save callee-save registered if needed
	#...the program code
	#...restoring calee-save registers if needed
.endf:
	pop	%rbp	#pop calee saved
	pop	%r15
	pop	%r14
	pop	%r13
	pop	%r12
	pop	%rbx	#end pop calee saved
	movq	%rbp,%rsp
	popq	%rbp
	ret
.CS50:
	pushq	%rax		#push caller for pstrlen1
	pushq	%rdi
	pushq	%rsi
	pushq	%rdx		#finish push caller for pstrlen1
	movq	%rsi,%rdi	#moving address of pstr1 from run_func arg2 to pstrlen arg1
	call	pstrlen
	movq	%rax,%rbx
	popq	%rdx		#pop caller for pstrlen1
	popq	%rsi
	popq	%rdi
	popq	%rax		#finish pop caller for pstrlen1
	pushq	%rax		#push caller for pstrlen2
	pushq	%rdi
	pushq	%rsi
	pushq	%rdx		#finish push caller for pstrlen2
	movq	%rdx,%rdi
	call	pstrlen
	movq	%rax,%r12
	popq	%rdx		#pop caller for pstrlen1
	popq	%rsi
	popq	%rdi
	popq	%rax		#finish pop caller for pstrlen1
	pushq	%rax		#push caller for printf
	pushq	%rdi
	pushq	%rsi
	pushq	%rdx		#finish push caller for printf
	movq	$.LEN, %rdi
	movq	%rbx,%rsi
	movq	%r12,%rdx
	call	printf
	popq	%rdx		#pop caller for printf
	popq	%rsi
	popq	%rdi
	popq	%rax		#finish pop caller for printf
	jmp	.DN
.CS51:
	pushq	%rax		#push caller for replaceChar1
	pushq	%rdi
	pushq	%rsi
	pushq	%rdx		#finish push caller for replaceChar1
	movq	%rsi,%rdi	#send p1 as arg
	movq	$61,%rsi	#send 'a' as old char dummy
	movq	$42,%rdx	#send 'B' as new char dummy
	call	replaceChar
	movq	%rax,%rbx
	popq	%rdx		#pop caller for replaceChar1
	popq	%rsi
	popq	%rdi
	popq	%rax		#finish pop caller for replaceChar1
	pushq	%rax		#push caller for replaceChar2
	pushq	%rdi
	pushq	%rsi
	pushq	%rdx		#finish push caller for replaceChar2
	movq	%rdx,%rdi	#send p2 as arg
	movq	$0x61,%rsi	#send 'a' as old char dummy
	movq	$0x42,%rdx	#send 'B' as new char dummy
	call	replaceChar
	movq	%rax,%r12
	popq	%rdx		#pop caller for replaceChar2
	popq	%rsi
	popq	%rdi
	popq	%rax		#finish pop caller for replaceChar2
	pushq	%rax		#push caller for printf
	pushq	%rdi
	pushq	%rsi
	pushq	%rdx		
	pushq	%rcx
	pushq	%r8		#finish push caller for printf
	movq	$.RPLCR, %rdi
	movq	$0x61,%rsi
	movq	$0x42,%rdx
	leaq	1(%rbx),%rcx
	leaq	1(%r12),%r8
	call	printf
	popq	%r8		#pop caller for printf
	popq	%rcx
	popq	%rdx	
	popq	%rsi
	popq	%rdi
	popq	%rax		#finish pop caller for printf
	jmp	.DN
.CS52:
	call	pstrijcpy
	jmp	.DN
.CS53:
	call	swapCase
	jmp 	.DN
.CS54:
	call	pstrijcmp
	jmp	.DN
.DFLT:
	movq	$.DFST, %rdi
	call	printf
.DN:
	jmp	.endf
	


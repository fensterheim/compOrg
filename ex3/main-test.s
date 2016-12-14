	.file	"main-test.c"
	.section	.rodata
.LC0:
	.string	"%d"
.LC1:
	.string	"%s"
	.text
	.globl	main
	.type	main, @function
main:
.LFB0:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$528, %rsp
	leaq	-516(%rbp), %rax
	movq	%rax, %rsi
	movl	$.LC0, %edi
	movl	$0, %eax
	call	__isoc99_scanf
	leaq	-256(%rbp), %rax
	addq	$1, %rax
	movq	%rax, %rsi
	movl	$.LC1, %edi
	movl	$0, %eax
	call	__isoc99_scanf
	movl	-516(%rbp), %eax
	movb	%al, -256(%rbp)
	leaq	-516(%rbp), %rax
	movq	%rax, %rsi
	movl	$.LC0, %edi
	movl	$0, %eax
	call	__isoc99_scanf
	leaq	-512(%rbp), %rax
	addq	$1, %rax
	movq	%rax, %rsi
	movl	$.LC1, %edi
	movl	$0, %eax
	call	__isoc99_scanf
	movl	-516(%rbp), %eax
	movb	%al, -512(%rbp)
	leaq	-520(%rbp), %rax
	movq	%rax, %rsi
	movl	$.LC0, %edi
	movl	$0, %eax
	call	__isoc99_scanf
	movl	-520(%rbp), %eax
	leaq	-512(%rbp), %rdx
	leaq	-256(%rbp), %rcx
	movq	%rcx, %rsi
	movl	%eax, %edi
	movl	$0, %eax
	call	run_func
	movl	$0, %eax
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE0:
	.size	main, .-main
	.ident	"GCC: (Debian 6.1.1-11) 6.1.1 20160802"
	.section	.note.GNU-stack,"",@progbits

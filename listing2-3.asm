
nl				=		10
maxLen	=		256

	.data
titleStr	byte	'Listing 2-3', 0

prompt1	byte	"Enter an integer value between 0 and 127:", 0
fmtStr1		byte	"Value in hexadecimal: %x", nl, 0
fmtStr2		byte	"Invert all the bits (hexadecimal): %x", nl, 0
fmtStr3		byte	"Add 1 (hexadecimal): %x", nl, 0
fmtStr4		byte	"Output as signed integer: %d", nl, 0
fmtStr5		byte	"Using neg instruction: %d", nl, 0

intValue	sqword	?
input		byte		maxLen	dup (?)

	.code
	
	externdef	printf:proc
	externdef	atoi:proc
	externdef	readLine:proc
	
	
	public getTitle
getTitle proc

	lea	rax,	titleStr
	ret
	
getTitle endp


	public asmMain
asmMain proc

	; Has something to do with stack alignment
	sub	rsp,	56
	
	; Prompt user (readLine calls fgets)
	
	lea	rcx,	prompt1
	call	printf
	
	lea	rcx,	input
	mov	rdx,	maxLen
	call	readLine
	
	; Call atoi
	
	lea	rcx,	input
	call	atoi
	and	rax,	0ffh
	mov	intValue,	rax
	
	; Print hex value
	
	lea	rcx,	fmtStr1
	mov	rdx,	rax
	call	printf
	
	; Negate by using two's complement operation
	; Demonstrates rdx and rl register overlay
	
	mov	rdx,	intValue
	not	dl
	lea	rcx,	fmtStr2
	call	printf
	
	; Actual negation
	
	mov	rdx,	intValue
	not	rdx
	add	rdx,	1
	and	rdx, 0ffh
	lea	rcx,	fmtStr3
	call	printf
	
	; Demonstrating C++ %d format output (32bit int)
	; HO 32 bits get ignored
	
	mov	rdx,	intValue
	not	rdx
	add	rdx, 1
	lea	rcx,	fmtStr4
	call	printf
	
	; Using neg instruction
	
	mov	rdx,	intValue
	neg	rdx
	lea	rcx, fmtStr5
	call	printf
	
	add	rsp,	56
	ret
	
asmMain endp
	
	end
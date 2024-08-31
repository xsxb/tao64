
	option casemap:none
	
NULL	=	0
nl			=	10
maxLen	=	265

	.const
ttlStr		byte		'Listing2-4', 0
dayPrompt	byte	'Enter current day:', 0
monthPrompt	byte	'Enter current month:', 0
yearPrompt	byte	'Enter current year '
					byte	'(last 2 digits only): ', 0
					
packed		byte	'Packed date is: %04x', nl, 0
theDate	byte	'The date is %02d/%02d/%02d'
				byte nl, 0

badDayStr	byte	'Bad day value was entered ' 
	byte '(expected 1-31)', nl, 0

badMonthStr	byte	'Bad month value was entered ' 
	byte '(expected 1-12)', nl, 0

badYearStr	byte	'Bad year value was entered ' 
	byte '(expected 00-99)', nl, 0

	
	.data
	
day	byte ?
month	byte ?
year	byte ?
date	word ?

input	byte maxLen dup (?)


	.code
	
	externdef printf:proc
	externdef readLine:proc
	externdef atoi:proc
	
	public getTitle
getTitle proc
	lea	rax,	ttlStr
	ret
getTitle endp


readNum proc

	sub	rsp,	56
	
	call	printf
	lea	rcx, input
	mov	rdx, maxLen
	call	readLine
	
	cmp	rax, NULL
	je		badInput
	
	lea	rcx,	input
	call	atoi
	
badInput:
	add	rsp,	56
	ret

readNum endp


	public asmMain
asmMain proc

	sub	rsp, 56
	
	lea	rcx, dayPrompt
	call	readNum
	
	cmp	rax, 1
	jl		badDay
	cmp	rax, 31
	jg		badDay
	
	mov	day,	al
	
	lea	rcx, monthPrompt
	call	readNum
	
	cmp	rax, 1
	jl		badMonth
	cmp	rax, 12
	jg		badMonth
	
	mov	month,	al
	
	lea	rcx,	yearPrompt
	call	readNum
	
	cmp	rax,	0
	jl		badYear
	cmp	rax, 99
	jg		badYear
	
	mov	year,	al

	; Pack data:
	; d d d d d m m m m y y y y y y y
	
	movzx	ax,	day
	shl		ax,	4
	or			al,	month			;setting month bits, leave rest in tact
	shl		ax,	7
	or			al,	year
	mov		date,	ax
	
	lea		rcx,	packed
	movzx	rdx,	date
	call		printf
	
	; Unpack
	
	movzx	rdx,	date
	mov		r9,	rdx			; year
	and		r9,	7fh			; 7 bits
	shr		rdx,	7				; shift to month
	mov		r8,	rdx
	and		r8,	0fh			; 5 bits
	shr		rdx,	4
	lea		rcx,	theDate
	call		printf
	
	jmp		allDone
	
badDay:
	lea		rcx,	badDayStr
	call		printf
	jmp		allDone
	
badMonth:
	lea		rcx,	badMonthStr
	call		printf
	jmp		allDone
	
badYear:
	lea		rcx,	badYearStr
	call		printf
	
allDone:
	add		rsp,	56
	ret
	
asmMain endp
	
	end
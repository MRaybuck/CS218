; *****************************************************************
;  Must include:
;	name
;	assignmnet #
;	section #

; -----
;  Write a simple assembly language program to compute the
;  the provided formulas.

;  Focus on learning basic arithmetic operations
;  (add, subtract, multiply, and divide).
;  Ensure understanding of sign and unsigned operations.


; *****************************************************************
;  Data Declarations (provided).

section	.data
; -----
;  Define constants.

NULL		equ	0			; end of string

TRUE		equ	1
FALSE		equ	0

EXIT_SUCCESS	equ	0			; successful operation
SYS_exit	equ	60			; call code for terminate

; -----
;  Assignment #3 data declarations

; byte data
bnum1		db	29
bnum2		db	19
bnum3		db	13
bnum4		db	12
bnum5		db	-7
bnum6		db	-15
bans1		db	0
bans2		db	0
bans3		db	0
bans4		db	0
bans5		db	0
bans6		db	0
bans7		db	0
bans8		db	0
bans9		db	0
bans10		db	0
wans11		dw	0
wans12		dw	0
wans13		dw	0
wans14		dw	0
wans15		dw	0
bans16		db	0
bans17		db	0
bans18		db	0
brem18		db	0
bans19		db	0
bans20		db	0
bans21		db	0
brem21		db	0

; word data
wnum1		dw	127
wnum2		dw	276
wnum3		dw	47
wnum4		dw	6218
wnum5		dw	-235
wnum6		dw	-59
wans1		dw	0
wans2		dw	0
wans3		dw	0
wans4		dw	0
wans5		dw	0
wans6		dw	0
wans7		dw	0
wans8		dw	0
wans9		dw	0
wans10		dw	0
dans11		dd	0
dans12		dd	0
dans13		dd	0
dans14		dd	0
dans15		dd	0
wans16		dw	0
wans17		dw	0
wans18		dw	0
wrem18		dw	0
wans19		dw	0
wans20		dw	0
wans21		dw	0
wrem21		dw	0

; double-word data
dnum1		dd	2034915
dnum2		dd	5871
dnum3		dd	9815
dnum4		dd	42338
dnum5		dd	-2703
dnum6		dd	-249
dans1		dd	0
dans2		dd	0
dans3		dd	0
dans4		dd	0
dans5		dd	0
dans6		dd	0
dans7		dd	0
dans8		dd	0
dans9		dd	0
dans10		dd	0
qans11		dq	0
qans12		dq	0
qans13		dq	0
qans14		dq	0
qans15		dq	0
dans16		dd	0
dans17		dd	0
dans18		dd	0
drem18		dd	0
dans19		dd	0
dans20		dd	0
dans21		dd	0
drem21		dd	0

; quadword data
qnum1		dq	13147826
qnum2		dq	24983
qnum3		dq	518747
qnum4		dq	161227
qnum5		dq	-17517
qnum6		dq	2258
qans1		dq	0
qans2		dq	0
qans3		dq	0
qans4		dq	0
qans5		dq	0
qans6		dq	0
qans7		dq	0
qans8		dq	0
qans9		dq	0
qans10		dq	0
dqans11		ddq	0
dqans12		ddq	0
dqans13		ddq	0
dqans14		ddq	0
dqans15		ddq	0
qans16		dq	0
qans17		dq	0
qans18		dq	0
qrem18		dq	0
qans19		dq	0
qans20		dq	0
qans21		dq	0
qrem21		dq	0

; *****************************************************************

section	.text
global _start
_start:

; ----------------------------------------------
; Byte Operations

; unsigned byte additions
;	bans1  = bnum2 + bnum3
;	bans2  = bnum1 + bnum4
;	bans3  = bnum2 + bnum4

	mov	al, byte [bnum2]		; provided example
	add	al, byte [bnum3]
	mov	byte [bans1], al


; -----
; signed byte additions
;	bans4  = bnum1 + bnum6
;	bans5  = bnum2 + bnum5



; -----
; unsigned byte subtractions
;	bans6  = bnum1 - bnum4
;	bans7  = bnum2 - bnum3
;	bans8  = bnum3 - bnum4



; -----
; signed byte subtraction
;	bans9  = bnum5 - bnum6
;	bans10 = bnum6 - bnum4



; -----
; unsigned byte multiplication
;	wans11  = bnum2 * bnum3
;	wans12  = bnum1 * bnum2
;	wans13  = bnum3 * bnum4



; -----
; signed byte multiplication
;	wans14  = bnum5 * bnum4
;	wans15  = bnum6 * bnum5



; -----
; unsigned byte division
;	bans16 = bnum1 / bnum4 
;	bans17 = bnum2 / bnum4 
;	bans18 = wnum3 / bnum2 
;	brem18 = modulus (wnum3 / bnum2) 



; -----
; signed byte division
;	bans19 = bnum6 / bnum4
;	bans20 = bnum6 / bnum5
;	bans21 = wnum1 / bnum1
;	brem21 = modulus (wnum1 / bnum1)

	mov	al, byte [bnum6]		; provided example
	cbw
	idiv	byte [bnum4]
	mov	byte [bans19], al


; *****************************************
; Word Operations

; -----
; unsigned word additions
;	wans1  = wnum3 + wnum4
;	wans2  = wnum1 + wnum2
;	wans3  = wnum1 + wnum3

	mov	ax, word [wnum3]		; provided example
	add	ax, word [wnum4]
	mov	word [wans1], ax


; -----
; signed word additions
;	wans4  = wnum2 + wnum5
;	wans5  = wnum6 + wnum5



; -----
; unsigned word subtractions
;	wans6  = wnum4 - wnum1
;	wans7  = wnum2 - wnum3
;	wans8  = wnum1 - wnum3



; -----
; signed word subtraction
;	wans9  = wnum1 - wnum6
;	wans10  = wnum6 - wnum5


; -----
; unsigned word multiplication
;	dwans11 = wnum1 * wnum3
;	dwans12  = wnum2 * wnum3
;	dwans13  = wnum3 * wnum4

	mov	ax, word [wnum1]		; provided example
	mul	word [wnum3]
	mov	word [dans11], ax
	mov	word [dans11+2], dx



; -----
; signed word multiplication
;	dans14  = wnum3 * wnum6
;	dans15  = wnum6 * wnum5



; -----
; unsigned word division
;	wans16 = wnum2 / wnum3
;	wans17 = wnum4 / wnum1
;	wans18 = dnum3 / wnum2
;	wrem18 = modulus (dnum3 / wnum2)



; -----
; signed word division
;	wans19 = wnum4 / wnum5
;	wans20 = wnum2 / wnum6
;	wans21 = dnum3 / wnum5
;	wrem21 = modulus (dnum3 / wnum5)

	mov	ax, word [wnum4]		; provided example
	cwd
	idiv	word [wnum5]
	mov	word [wans19], ax



; *****************************************
; Double-Word Operations

; -----
; unsigned double-word additions
;	dans1  = dnum1 + dnum3
;	dans2  = dnum3 + dnum4
;	dans3  = dnum1 + dnum2

	mov	eax, dword [dnum1]		; provided example
	add	eax, dword [dnum3]
	mov	dword [dans1], eax


; -----
; signed double-word additions
;	dans4  = dnum2 + dnum5 
;	dans5  = dnum5 + dnum6



; -----
; unsigned double-word subtractions
;	dans6  = dnum1 - dnum2
;	dans7  = dnum1 - dnum3
;	dans8  = dnum4 - dnum2



; -----
; signed double-word subtraction
;	dans9  = dnum3 - dnum2
;	dans10 = dnum5 – dnum6



; -----
; unsigned double-word multiplication
;	qans11  = dnum2 * dnum2
;	qans12  = dnum1 * dnum2
;	qans13  = dnum2 * dnum4

	mov	eax, dword [dnum2]		; provided example
	mul	eax
	mov	dword [qans11], eax
	mov	dword [qans11+4], edx



; -----
; signed double-word multiplication
;	qans14  = dnum6 * dnum5
;	qans15  = dnum2 * dnum6



; -----
; unsigned double-word division
;	dans16 = dnum1 / dnum4
;	dans17 = dnum3 / dnum2
;	dans18 = qans12 / dnum2
;	drem18 = modulus (qans12 / dnum2)

	mov	eax, dword [dnum1]		; provided example
	mov	edx, 0
	div	dword [dnum4]
	mov	dword [dans16], eax



; -----
; signed double-word division
;	dans19 = dnum4 / dnum5
;	dans20 = dnum5 / dnum6
;	dans21 = qans11 / dnum5
;	drem21 = modulus (qans11 / dnum5)

	mov	eax, [dnum4]			; provided example
	cdq
	idiv	dword [dnum5]
	mov	[dans19], eax


; *****************************************
; QuadWord Operations

; -----
; unsigned quadword additions
;	qans1  = qnum1 + qnum3
;	qans2  = qnum3 + qnum4
;	qans3  = qnum1 + qnum2

	mov	rax, qword [qnum1]		; provided example
	add	rax, qword [qnum3]
	mov	qword [qans1], rax



; -----
; signed quadword additions
;	qans4  = qnum2 + qnum5
;	qans5  = qnum5 + qnum6



; -----
; unsigned quadword subtractions
;	qans6  = qnum1 - qnum2
;	qans7  = qnum1 - qnum3
;	qans8  = qnum4 - qnum2



; -----
; signed quadword subtraction
;	qans9  = qnum3 - qnum2
;	qans10 = qnum5 - qnum6



; -----
; unsigned quadword multiplication
;	dqans11  = qnum2 * qnum2
;	dqans12  = qnum1 * qnum2
;	dqans13  = qnum2 * qnum4

	mov	rax, qword [qnum2]		; provided example
	mul	rax
	mov	qword [dqans11], rax
	mov	qword [dqans11+8], rdx



; -----
; signed quadword multiplication
;	dqans14  = qnum6 * qnum5
;	dqans15  = qnum2 * qnum6



; -----
; unsigned quadword division
;	qans16 = qnum1 / qnum4
;	qans17 = qnum3 / qnum2
;	qans18 = dqans12 / qnum2
;	qrem18 = modulus (dqans12 / qnum2)

	mov	rax, qword [qnum1]		; provided example
	mov	rdx, 0
	div	qword [qnum4]
	mov	qword [qans16], rax



; -----
; signed quadword division
;	qans19 = qnum4 / qnum5
;	qans20 = qnum5 / qnum6
;	qans21 = dqans11 / qnum5
;	qrem21 = modulus (dqans11 / qnum5)

	mov	rax, qword [qnum4]		; provided example
	cqo
	idiv	qword [qnum5]
	mov	qword [qans19], rax


; *****************************************************************
;	Done, terminate program.

last:
	mov	eax, SYS_exit		; call call for exit (SYS_exit)
	mov	ebx, EXIT_SUCCESS	; return code of 0 (no error)
	syscall


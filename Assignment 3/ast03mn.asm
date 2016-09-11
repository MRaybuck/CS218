; *****************************************************************
;	Matt Raybuck
;	Assignmnet #3
;	Section #1002

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

	mov	al, byte [bnum2]		; provided example.
	add	al, byte [bnum3]		; 19 + 13 = 32
	mov	byte [bans1], al

	mov	al, byte [bnum1]		; 29 + 12 = 41
	add	al, byte [bnum4]
	mov	byte [bans2], al

	mov	al, byte [bnum2]		; 19 + 12 = 31
	add	al, byte [bnum4]
	mov	byte [bans3], al

; -----
; signed byte additions
;	bans4  = bnum1 + bnum6
;	bans5  = bnum2 + bnum5

	mov	al, byte [bnum1]		; 29 + (-15) = 14
	add	al, byte [bnum6]
	mov	byte [bans4], al

	mov	al, byte [bnum2]		; 19 + (-7) = 12
	add	al, byte [bnum5]
	mov	byte [bans5], al

; -----
; unsigned byte subtractions
;	bans6  = bnum1 - bnum4
;	bans7  = bnum2 - bnum3
;	bans8  = bnum3 - bnum4

	mov	al, byte [bnum1]		; 29 - 12 = 17
	sub	al, byte [bnum4]
	mov	byte [bans6], al

	mov	al, byte [bnum2]
	sub	al, byte [bnum3]
	mov	byte [bans7], al

	mov	al, byte [bnum3]
	sub	al, byte [bnum4]
	mov	byte [bans8], al


; -----
; signed byte subtraction
;	bans9  = bnum5 - bnum6
;	bans10 = bnum6 - bnum4

	mov	al, byte [bnum5]		; (-7) - (-15) = 8
	sub	al, byte [bnum6]
	mov	byte [bans9], al

	mov	al, byte [bnum6]
	sub	al, byte [bnum4]
	mov	byte [bans10], al

; -----
; unsigned byte multiplication
;	wans11  = bnum2 * bnum3
;	wans12  = bnum1 * bnum2
;	wans13  = bnum3 * bnum4

	mov	al, byte [bnum2]		; 19 * 13 = 247
	mul		byte [bnum3]
	mov	word [wans11], ax

	mov	al, byte [bnum1]
	mul		byte [bnum2]
	mov	word [wans12], ax

	mov	al, byte [bnum3]
	mul		byte [bnum4]
	mov	word [wans13], ax

; -----
; signed byte multiplication
;	wans14  = bnum5 * bnum4
;	wans15  = bnum6 * bnum5

	mov	al, byte [bnum5]		; (-7) * 12 = (-84)
	imul	byte [bnum4]
	mov	word [wans14], ax

	mov	al, byte [bnum6]
	imul	byte [bnum5]
	mov	word [wans15], ax

; -----
; unsigned byte division
;	bans16 = bnum1 / bnum4 
;	bans17 = bnum2 / bnum4 
;	bans18 = wnum3 / bnum2 
;	brem18 = modulus (wnum3 / bnum2) 

	mov ax, 0					; 29 / 12 = 2
	mov	al, byte [bnum1]
	div 	byte [bnum4]
	mov	byte [bans16], al

	mov ax, 0
	mov	al, byte [bnum2]
	div 	byte [bnum4]
	mov	byte [bans17], al

	mov ax, 0
	mov	ax, word [wnum3]
	div 	byte [bnum2]
	mov	byte [bans18], al

	mov byte [brem18], ah		; 47 % 19 = 9

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

	mov	al, byte [bnum6]
	cbw
	idiv	byte [bnum5]
	mov	byte [bans20], al

	mov	ax, word [wnum1]
	cwd
	idiv	byte [bnum1]
	mov	byte [bans21], al		; 127 / 29 = 4

	mov byte [brem21], ah		; 127 % 29 = 11


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

	mov	ax, word [wnum1]
	add	ax, word [wnum2]
	mov	word [wans2], ax

	mov	ax, word [wnum1]
	add	ax, word [wnum3]
	mov	word [wans3], ax

; -----
; signed word additions
;	wans4  = wnum2 + wnum5
;	wans5  = wnum6 + wnum5

	mov	ax, word [wnum2]
	add	ax, word [wnum5]
	mov	word [wans4], ax

	mov	ax, word [wnum6]
	add	ax, word [wnum5]
	mov	word [wans5], ax

; -----
; unsigned word subtractions
;	wans6  = wnum4 - wnum1
;	wans7  = wnum2 - wnum3
;	wans8  = wnum1 - wnum3

	mov	ax, word [wnum4]
	sub	ax, word [wnum1]
	mov	word [wans6], ax

	mov	ax, word [wnum2]
	sub	ax, word [wnum3]
	mov	word [wans7], ax

	mov	ax, word [wnum1]
	sub	ax, word [wnum3]
	mov	word [wans8], ax

; -----
; signed word subtraction
;	wans9  = wnum1 - wnum6
;	wans10  = wnum6 - wnum5

	mov	ax, word [wnum1]
	sub	ax, word [wnum6]
	mov	word [wans9], ax

	mov	ax, word [wnum6]
	sub	ax, word [wnum5]
	mov	word [wans10], ax

; -----
; unsigned word multiplication
;	dwans11 = wnum1 * wnum3
;	dwans12  = wnum2 * wnum3
;	dwans13  = wnum3 * wnum4

	mov	ax, word [wnum1]		; provided example
	mul	word [wnum3]
	mov	word [dans11], ax
	mov	word [dans11+2], dx

	mov	ax, word [wnum2]
	mul	word [wnum3]
	mov	word [dans12], ax
	mov	word [dans12+2], dx

	mov	ax, word [wnum3]
	mul	word [wnum4]
	mov	word [dans13], ax
	mov	word [dans13+2], dx

; -----
; signed word multiplication
;	dans14  = wnum3 * wnum6
;	dans15  = wnum6 * wnum5

	mov ax, word [wnum3]
	imul word [wnum6]
	mov word[dans14], ax
	mov word[dans14], dx

	mov ax, word [wnum3]
	imul word [wnum6]
	mov word[dans15], ax
	mov word[dans15], dx

; -----
; unsigned word division
;	wans16 = wnum2 / wnum3
;	wans17 = wnum4 / wnum1
;	wans18 = dnum3 / wnum2
;	wrem18 = modulus (dnum3 / wnum2)

	mov dx, 0
	mov ax, word [wnum2]
	div 	word [wnum3]
	mov word [wans16], ax

	mov dx, 0
	mov ax, word [wnum4]
	div 	word [wnum1]
	mov word [wans17], ax

	mov edx, 0
	mov eax, dword [dnum3]
	div 	word [wnum2]
	mov word [wans18], ax

	mov word [wrem18], dx

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

	mov	ax, word [wnum2]
	cwd
	idiv	word [wnum6]
	mov	word [wans20], ax

	mov	eax, dword [dnum3]
	cwd
	idiv	word [wnum5]
	mov	word [wans21], ax

	mov word [wrem21], dx



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

	mov	eax, dword [dnum3]
	add	eax, dword [dnum4]
	mov	dword [dans2], eax

	mov	eax, dword [dnum1]
	add	eax, dword [dnum2]
	mov	dword [dans3], eax


; -----
; signed double-word additions
;	dans4  = dnum2 + dnum5 
;	dans5  = dnum5 + dnum6

	mov	eax, dword [dnum2]
	add	eax, dword [dnum5]
	mov	dword [dans4], eax

	mov	eax, dword [dnum5]
	add	eax, dword [dnum6]
	mov	dword [dans5], eax

; -----
; unsigned double-word subtractions
;	dans6  = dnum1 - dnum2
;	dans7  = dnum1 - dnum3
;	dans8  = dnum4 - dnum2

	mov	eax, dword [dnum1]
	sub	eax, dword [dnum2]
	mov	dword [dans6], eax

	mov	eax, dword [dnum1]
	sub	eax, dword [dnum3]
	mov	dword [dans7], eax

	mov	eax, dword [dnum4]
	sub	eax, dword [dnum2]
	mov	dword [dans8], eax

; -----
; signed double-word subtraction
;	dans9  = dnum3 - dnum2
;	dans10 = dnum5 – dnum6

	mov	eax, dword [dnum3]
	sub	eax, dword [dnum2]
	mov	dword [dans9], eax

	mov	eax, dword [dnum5]
	sub	eax, dword [dnum6]
	mov	dword [dans10], eax

; -----
; unsigned double-word multiplication
;	qans11  = dnum2 * dnum2
;	qans12  = dnum1 * dnum2
;	qans13  = dnum2 * dnum4

	mov	eax, dword [dnum2]		; provided example
	mul	eax
	mov	dword [qans11], eax
	mov	dword [qans11+4], edx

	mov	eax, dword [dnum1]
	mul		 dword [dnum2]
	mov	dword [qans12], eax
	mov	dword [qans12+4], edx

	mov	eax, dword [dnum2]
	mul		 dword [dnum4]
	mov	dword [qans13], eax
	mov	dword [qans13+4], edx

; -----
; signed double-word multiplication
;	qans14  = dnum6 * dnum5
;	qans15  = dnum2 * dnum6

	mov	eax, dword [dnum6]
	imul	 dword [dnum5]
	mov	dword [qans14], eax
	mov	dword [qans14+4], edx

	mov	eax, dword [dnum6]
	imul	 dword [dnum5]
	mov	dword [qans15], eax
	mov	dword [qans15+4], edx

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

	mov	eax, dword [dnum3]
	mov	edx, 0
	div	dword [dnum2]
	mov	dword [dans17], eax

	mov	eax, dword [qans12]
	mov	edx, dword [qans12+4]
	div	dword [dnum2]
	mov	dword [dans18], eax

	mov dword [drem18], edx


; -----
; signed double-word division
;	dans19 = dnum4 / dnum5
;	dans20 = dnum5 / dnum6
;	dans21 = qans11 / dnum5
;	drem21 = modulus (qans11 / dnum5)

	mov	eax, dword [dnum4]			; provided example
	cdq
	idiv	dword [dnum5]
	mov	dword [dans19], eax

	mov	eax, dword [dnum5]
	cdq
	idiv	dword [dnum6]
	mov	dword [dans20], eax

	mov	eax, dword [qans11]
	mov edx, dword [qans11+4]
	idiv	dword [dnum5]
	mov	dword [dans21], eax

	mov dword [drem21], edx

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

	mov	rax, qword [qnum3]
	add	rax, qword [qnum4]
	mov	qword [qans2], rax

	mov	rax, qword [qnum1]
	add	rax, qword [qnum2]
	mov	qword [qans3], rax

; -----
; signed quadword additions
;	qans4  = qnum2 + qnum5
;	qans5  = qnum5 + qnum6

	mov	rax, qword [qnum2]
	add	rax, qword [qnum5]
	mov	qword [qans4], rax

	mov	rax, qword [qnum5]
	add	rax, qword [qnum6]
	mov	qword [qans5], rax

; -----
; unsigned quadword subtractions
;	qans6  = qnum1 - qnum2
;	qans7  = qnum1 - qnum3
;	qans8  = qnum4 - qnum2

	mov	rax, qword [qnum1]
	sub	rax, qword [qnum2]
	mov	qword [qans6], rax

	mov	rax, qword [qnum1]
	sub	rax, qword [qnum3]
	mov	qword [qans7], rax

	mov	rax, qword [qnum4]
	sub	rax, qword [qnum2]
	mov	qword [qans8], rax

; -----
; signed quadword subtraction
;	qans9  = qnum3 - qnum2
;	qans10 = qnum5 - qnum6

	mov	rax, qword [qnum3]
	sub	rax, qword [qnum2]
	mov	qword [qans9], rax

	mov	rax, qword [qnum5]
	sub	rax, qword [qnum6]
	mov	qword [qans10], rax

; -----
; unsigned quadword multiplication
;	dqans11  = qnum2 * qnum2
;	dqans12  = qnum1 * qnum2
;	dqans13  = qnum2 * qnum4

	mov	rax, qword [qnum2]		; provided example
	mul	rax
	mov	qword [dqans11], rax
	mov	qword [dqans11+8], rdx

	mov	rax, qword [qnum1]
	mul		 qword [qnum2]
	mov	qword [dqans12], rax
	mov	qword [dqans12+8], rdx

	mov	rax, qword [qnum2]		; provided example
	mul		 qword [qnum4]
	mov	qword [dqans13], rax
	mov	qword [dqans13+8], rdx


; -----
; signed quadword multiplication
;	dqans14  = qnum6 * qnum5
;	dqans15  = qnum2 * qnum6

	mov	rax, qword [qnum6]
	imul	 qword [qnum5]
	mov	qword [dqans14], rax
	mov	qword [dqans14+8], rdx

	mov	rax, qword [qnum2]
	imul	 qword [qnum6]
	mov	qword [dqans15], rax
	mov	qword [dqans15+8], rdx

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

	mov	rax, qword [qnum3]
	mov	rdx, 0
	div	qword [qnum2]
	mov	qword [qans17], rax

	mov	rax, qword [dqans12]
	mov	rdx, qword [dqans12+8]
	div	qword [qnum2]
	mov	qword [qans18], rax

	mov qword [qrem18], rdx

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

	mov	rax, qword [qnum5]
	cqo
	idiv	qword [qnum6]
	mov	qword [qans20], rax

	mov	rax, qword [dqans11]		; provided example
	mov rdx, qword [dqans11+8]
	idiv	qword [qnum5]
	mov	qword [qans21], rax

	mov qword [qrem21], rdx

; *****************************************************************
;	Done, terminate program.

last:
	mov	eax, SYS_exit		; call call for exit (SYS_exit)
	mov	ebx, EXIT_SUCCESS	; return code of 0 (no error)
	syscall


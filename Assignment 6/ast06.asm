;  CS 218, Assignment #6
;  Matthew Raybuck
;  Section 1002
;  Provided Main

;  Write a simple assembly language program to calculate
;  the x-intercepts for each line in a series of lines.

;  The points data are provided as nonary (base 9) values
;  represented as ASCII characters and must be converted
;  into integers in order to perform the calculations.

; --------------------------------------------------------------
;  Macro to convert nonary (base 9) value in ASCII format
;  into an integer.
;  Assumes valid data, no error checking is performed.

;  Call:  nonary2int  <stringAddr>, <integer>
;	Arguments:
;		%1 -> <stringAddr>, string address
;		%2 -> <integerAddr>, address for integer result

;  Reads <stringAddr> and converts to integer and places
;  in <integer>

; -----
; Algorithm:
;	runningSum = 0
;   startLoop
;	get character from string
;	convert character to integer (integerDigit)
;	runningSum = runningSum * 9
;	runningSum = runningSum + integerDigit
;   next loop
;   return final result (from running sum)

; Note,	<stringAddr> is passed as address in RSI
;	<integerAddr> is passed as address on RDI

%macro	nonary2int	2


; -----
	; Algorithm:
	
	;	runningSum = 0

		mov qword [%2], 0

	;	initialize other variables

		; get address of string
		mov r14, %1
		
		; initialize DoNeg
		mov byte [DoNeg], 0
		
		; initialize idx
		mov r8, 0

	;   startLoop
	%%CvtLoop:
		
		;	get character from string
		
		inc r8

		cmp byte [r14 + r8], NULL
		je %%NullEncounter

			;	convert character to integer (integerDigit)

			mov r13b, byte [r14 + r8]
			sub r13b, "0"

			;	runningSum = runningSum * 9
			
			mov eax, dword [%2]
			imul eax, 9
			mov dword [%2], eax

			;	runningSum = runningSum + integerDigit
			
			add dword [%2], r13d

		%%NullEncounter:

	;   next loop
	cmp byte [r14 + r8], NULL
	jne %%CvtLoop

	;	if "-" then we have to negate the number in rSum
	
	cmp byte [r14], "-"
	jne	%%SkipNeg
		neg dword [%2]
	%%SkipNeg:



%endmacro

; --------------------------------------------------------------
;  Macro to convert integer to nonary value in ASCII format.

;  Call:  int2nonary    <integer>, <stringAddr>, <length>
;	Arguments:
;		%1 -> <integer>, value
;		%2 -> <stringAddr>, string address

;  Reads <integer> and places nonary characters,
;	including the sign and NULL into <stringAddr>

%macro	int2nonary	2

; For peace of mind push the values of used registers to stack
	;push eax
	push rcx
	;push ebx
	push rdx
	push rbx
	push rdi
	push rax

; Convert xInt back into nonary with successive division
	
	mov byte [DoNeg], FALSE

	; Check if the intercept is negative. If it is then negate and make DoNeg TRUE.
	cmp dword [%1], 0
	jge %%DontNeg
		mov byte [DoNeg], TRUE
		neg dword [%1]
	%%DontNeg:

	; move xInt into eax
	mov	eax, dword [%1]

	; set rcx as loop iterator that counts up until eax equals 0
	mov rcx, 0

	; ebx is the divisor that is used for successive division
	mov ebx, 9

	%%SuccessiveDivLoop:

		; perform signed division for dword
		cdq
		idiv ebx

		; push remainder onto the stack and increment rcx
		push rdx
		inc  rcx

	; exit the loop when eax can't be divided any more.
	cmp eax, 0
	jne %%SuccessiveDivLoop

	; get address of tmpString into rbx.
	mov rbx, %2

	; use rdi to incrementally move through tmpString to add characters to it.
	; set to 1 so that the sign isn't overridden in the loop.
	mov rdi, 1

	; Stick a postive sign in the first position of the string.
	mov byte [rbx], "+"

	; Check if the intercept is negative and overwrite the + with a -
	cmp byte [DoNeg], 0
	je %%SignPositive
		mov byte [rbx], "-"
	%%SignPositive:

	%%popStack:

		; pop base 9 integer off the stack and convert to character.
		pop rax
		add al, "0"

		; attach that character onto the string in the proper place.
		mov byte [rbx + rdi], al
		inc rdi

	loop %%popStack

	; finish the string with a NULL termination
	mov byte [rbx + rdi], NULL

; For peace of mind pop registers that were pushed to stack at beginning of macro
	pop rax
	pop rdi
	pop rbx
	pop rdx
	;pop ebx
	pop rcx
	;pop eax

%endmacro

; --------------------------------------------------------------
;  Simple macro to display a string to the console.
;	Call:	printString  <stringAddr>

;	Arguments:
;		%1 -> <stringAddr>, string address

;  Count characters (excluding NULL).
;  Display string starting at address <stringAddr>

%macro	printString	1
	push	rax			; save altered registers
	push	rdi
	push	rsi
	push	rdx
	push	rcx

	mov	rdx, 0
	mov	rdi, %1
%%countLoop:
	cmp	byte [rdi], NULL
	je	%%countLoopDone
	inc	rdi
	inc	rdx
	jmp	%%countLoop
%%countLoopDone:

	mov	rax, SYS_write		; system call for write (SYS_write)
	mov	rdi, STDOUT		; standard output
	mov	rsi, %1			; address of the string
	syscall				; call the kernel

	pop	rcx			; restore registers to original values
	pop	rdx
	pop	rsi
	pop	rdi
	pop	rax
%endmacro

; --------------------------------------------------------------

section	.data

; -----
;  Define constants.

TRUE		equ	1
FALSE		equ	0

SUCCESS		equ	0			; successful operation
NOSUCCESS	equ	1			; unsuccessful operation

STDIN		equ	0			; standard input
STDOUT		equ	1			; standard output
STDERR		equ	2			; standard error

SYS_read	equ	0			; system call code for read
SYS_write	equ	1			; system call code for write
SYS_open	equ	2			; system call code for file open
SYS_close	equ	3			; system call code for file close
SYS_fork	equ	57			; system call code for fork
SYS_exit	equ	60			; system call code for terminate
SYS_creat	equ	85			; system call code for file open/create
SYS_time	equ	201			; system call code for get time

LF		equ	10
SPACE		equ	" "
NULL		equ	0
ESC		equ	27

NUMS_PER_LINE	equ	3
MAX_STR_LENGTH	equ	20

; -----
;  Assignment #6 Provided Data:

Anum		db	"-125", NULL
Aval		dd	0
Cval		dd	-134120
xInt		dd	0

Alst		db	    "+117", NULL,     "-347", NULL,     "+647", NULL
		db	    "+275", NULL,     "+134", NULL,     "+206", NULL
		db	    "+618", NULL,    "+1231", NULL,    "-1018", NULL
		db	     "+28", NULL,     "+283", NULL,    "-1206", NULL
		db	    "-184", NULL,     "+481", NULL,    "-2034", NULL
		db	    "-164", NULL,      "+71", NULL,    "-1845", NULL

Clst		db	 "+128127", NULL,  "+162221", NULL, "+3412231", NULL
		db	"-1176825", NULL,  "+158027", NULL, "-1174821", NULL
		db	  "+28435", NULL,   "-15816", NULL, "-2876520", NULL
		db	 "+217458", NULL,  "-257410", NULL, "-6520287", NULL
		db	 "-120168", NULL,   "+12872", NULL, "+1451345", NULL
		db	"+1718221", NULL,  "+268760", NULL,  "-823575", NULL

length		dd	18
xIntSum		dd	0
xIntAve		dd	0

; -----
;  Misc. variables for main.

hdr		db	"------------------------------------"
		db	"-------------------------"
		db	LF, ESC, "[1m", "CS 218 - Assignment #6"
		db	ESC, "[0m", LF
		db	"X-Intercepts Program"
		db	LF, NULL

xHdr		db	LF, "X-intercept (test): ", NULL
xIntsHdr	db	LF, "X-intercepts: ", LF, NULL
smHdr		db	LF, "X-intercepts Sum: ", NULL
avHdr		db	LF, "X-intercepts Ave: ", NULL

numCount	dd	0
tempNum		dd	0

newLine		db	LF, NULL
dNine		dd	9
dTwo		dd	2
spaces		db	"    ", NULL

rSum 		dd  0
DoNeg		db	0

; --------------------------------------------------------------
;  Uninitialized (empty) variables

section	.bss

tmpString	resb	MAX_STR_LENGTH+1

Avalues		resd	18
Cvalues		resd	18
xInts		resd	18

; --------------------------------------------------------------


section	.text
global	_start
_start:

; -----
;  Display initial headers.

	printString	hdr

; ########################################################################
;  Part A - no macros.

; -----
;  Convert nonary x value (in ASCII format) to integer.
;	Do not use macro here...

	; -----
	; For Part A, I will convert Anum from nonary to integer to demonstrate that the conversion works.

	; -----
	; Algorithm:
	
	;	runningSum = 0

		mov qword [rSum], 0

	;	initialize other variables

		; get address of string
		mov r14, Anum
		
		; initialize DoNeg
		mov byte [DoNeg], 0
		
		; initialize idx
		mov r8, 0

	;   startLoop
	CvtLoop:
		
		;	get character from string
		
		inc r8

		cmp byte [r14 + r8], NULL
		je NullEncounter

			;	convert character to integer (integerDigit)

			mov r13b, byte [r14 + r8]
			sub r13b, "0"

			;	runningSum = runningSum * 9
			
			mov eax, dword [rSum]
			imul eax, 9
			mov dword [rSum], eax

			;	runningSum = runningSum + integerDigit
			
			add dword [rSum], r13d

		NullEncounter:

	;   next loop
	cmp byte [r14 + r8], NULL
	jne CvtLoop

	;	if "-" then we have to negate the number in rSum
	
	cmp byte [r14], "-"
	jne	SkipNeg
		neg dword [rSum]
	SkipNeg:


	; Store rSum into Aval

	mov r12, 0
	mov r12d, dword[rSum]
	mov dword [Aval], r12d



; -----
;  Compute X intercept based on point slope formula.
;	x = C/A

	; Use Aval and Cval to compute xInt

	mov	eax, dword [Cval]
	cdq
	idiv	dword [Aval]
	mov	dword [xInt], eax


; -----
;  Convert x-intercept into ASCII for printing.

	printString	xHdr

	; Convert xInt back into nonary with successive division
	
	mov byte [DoNeg], FALSE

	; Check if the intercept is negative. If it is then negate and make DoNeg TRUE.
	cmp dword [xInt], 0
	jge DontNeg
		mov byte [DoNeg], TRUE
		neg dword [xInt]
	DontNeg:

	; move xInt into eax
	mov	eax, dword [xInt]

	; set rcx as loop iterator that counts up until eax equals 0
	mov rcx, 0

	; ebx is the divisor that is used for successive division
	mov ebx, 9

	SuccessiveDivLoop:

		; perform signed division for dword
		cdq
		idiv ebx

		; push remainder onto the stack and increment rcx
		push rdx
		inc  rcx

	; exit the loop when eax can't be divided any more.
	cmp eax, 0
	jne SuccessiveDivLoop

	; get address of tmpString into rbx.
	mov rbx, tmpString

	; use rdi to incrementally move through tmpString to add characters to it.
	; set to 1 so that the sign isn't overridden in the loop.
	mov rdi, 1

	; Stick a postive sign in the first position of the string.
	mov byte [rbx], "+"

	; If (DoNeg == FALSE) then jump
	cmp byte [DoNeg], FALSE
	je SignPositive
		mov byte [rbx], "-"
	SignPositive:

	popStack:

		; pop base 9 integer off the stack and convert to character.
		pop rax
		add al, "0"

		; attach that character onto the string in the proper place.
		mov byte [rbx + rdi], al
		inc rdi

	loop popStack

	; finish the string with a NULL termination
	mov byte [rbx + rdi], NULL

	printString	tmpString
	printString	newLine
	printString	newLine


; ########################################################################
;  Part B - convert code from Part A into macro
;	call macro multiple times in a loop.

; -----
;  Convert Alst[] nonary data (in ASCII format) to integer.

	mov	ecx, dword [length]
	mov	rsi, Alst
	mov	rdi, Avalues

cvtAloop:
	push	rcx				; save register contents
	push	rsi
	push	rdi

	nonary2int	rsi, rdi

	pop	rdi				; restore register contents
	pop	rsi
	pop	rcx

nxtChrA:					; goto next string
	cmp	byte [rsi], NULL
	je	gotAEOS
	inc	rsi
	jmp	nxtChrA
gotAEOS:
	inc	rsi				; next Alst
	add	rdi, 4				; next Avalues

	dec	ecx
	cmp	ecx, 0
	jne	cvtAloop

; -----
;  Convert Clst[] nonary data (in ASCII format) to integer.

	mov	ecx, dword [length]
	mov	rsi, Clst
	mov	rdi, Cvalues

cvtCloop:
	push	rcx				; save register contents
	push	rsi
	push	rdi

	nonary2int	rsi, rdi

	pop	rdi				; restore register contents
	pop	rsi
	pop	rcx

nxtChrC:					; goto next string
	cmp	byte [rsi], NULL
	je	gotCEOS
	inc	rsi
	jmp	nxtChrC
gotCEOS:
	inc	rsi				; next Alst
	add	rdi, 4				; next Avalues

	dec	ecx
	cmp	ecx, 0
	jne	cvtCloop

; -----
;  Calculate the x-intercepts.
;  Also find x-intercepts sum and average.

	mov	ecx, dword [length]
	mov	rsi, 0
	mov	dword [xIntSum], 0			; sum = 0

xIntLoop:
	mov	eax, dword [Cvalues+rsi*4]
	cdq
	idiv	dword [Avalues+rsi*4]

	mov	dword [xInts+rsi*4], eax		; save Xint
	add	dword [xIntSum], eax			; sum

	inc	rsi
	loop	xIntLoop

; -----
;  Find x-intercepts average.

	mov	eax, dword [xIntSum]
	cdq
	idiv	dword [length]
	mov	dword [xIntAve], eax

; -----
;  Convert integer x-intercepts into nonary (in ASCII format) for printing.
;  For every 4th line, print a newLine (for formatting).

	printString	xIntsHdr

	mov	ecx, dword [length]
	mov	rdi, xInts
	mov	rsi, 0
	mov	dword [numCount], 0

cvtBAloop:
	mov	eax, dword [xInts+rsi*4]
	mov	dword [tempNum], eax

	int2nonary	tempNum, tmpString
	printString	tmpString
	printString	spaces

	inc	dword [numCount]
	cmp	dword [numCount], NUMS_PER_LINE
	jl	skipNewline1
	printString	newLine
	mov	dword [numCount], 0
skipNewline1:

	inc	rsi
	dec	rcx
	cmp	rcx, 0
	jne	cvtBAloop

; -----
;  Convert integer sum into nonary (in ASCII format) for printing.

	printString	smHdr
	int2nonary	xIntSum, tmpString
	printString	tmpString

; -----
;  Convert integer average into nonary (in ASCII format) for printing.

	printString	avHdr
	int2nonary	xIntAve, tmpString
	printString	tmpString

	printString	newLine
	printString	newLine

; -----
; Done, terminate program.

last:
	mov	rax, SYS_exit
	mov	rbx, SUCCESS
	syscall


;  Assignment #10

;  Wheels - Support Functions.
;  Provided Template

; -----
;  Function: getParams
;	Gets, checks, converts, and returns command line arguments.

;  Function drawWheels()
;	Plots provided functions

; ---------------------------------------------------------

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

; Note,	<stringAddr> is passed as address
;	<integerAddr> is passed as address

%macro	nonary2int	2


	; -----
	; Algorithm:
	

	; push r13 so marcro can use it
	push r13

	; rsum = 0
	mov qword [%2], 0

	; initialize nonary converter register
	mov r13d, 0

	;   startLoop
	%%CvtLoop:

			;	convert character to integer (integerDigit)

			mov r13b, byte [%1]
			sub r13b, '0'

			;	runningSum = runningSum * 9
			
			mov eax, dword [%2]
			imul eax, 9
			mov dword [%2], eax

			;	runningSum = runningSum + integerDigit
			
			add dword [%2], r13d

	;   next loop
	inc %1
	cmp byte [%1], NULL
	jne %%CvtLoop

	; pop r13 to maintain whatever was in there
	pop r13

%endmacro


; ---------------------------------------------------------

section  .data

; -----
;  Define standard constants.

TRUE		equ	1
FALSE		equ	0

SUCCESS		equ	0			; successful operation
NOSUCCESS	equ	1

STDIN		equ	0			; standard input
STDOUT		equ	1			; standard output
STDERR		equ	2			; standard error

SYS_read	equ	0			; code for read
SYS_write	equ	1			; code for write
SYS_open	equ	2			; code for file open
SYS_close	equ	3			; code for file close
SYS_fork	equ	57			; code for fork
SYS_exit	equ	60			; code for terminate
SYS_creat	equ	85			; code for file open/create
SYS_time	equ	201			; code for get time

LF		equ	10
SPACE		equ	" "
NULL		equ	0
ESC		equ	27

; -----
;  OpenGL constants

GL_COLOR_BUFFER_BIT	equ	16384
GL_POINTS		equ	0
GL_POLYGON		equ	9
GL_PROJECTION		equ	5889

GLUT_RGB		equ	0
GLUT_SINGLE		equ	0

; -----
;  Define constants.

SPD_MIN		equ	1
SPD_MAX		equ	50			; 55(9) = 50

CLR_MIN		equ	0
CLR_MAX		equ	0xFFFFFF

SIZ_MIN		equ	100			; 121(9) = 100
SIZ_MAX		equ	2000			; 2662(9) = 2000

; -----
;  Local variables for getRadii procedure.

STR_LENGTH	equ	12

ddNine		dd	9

errUsage	db	"Usage: ./wheels -sp <nonaryNumber> -cl <nonaryNumber> "
		db	"-sz <nonaryNumber>"
		db	LF, NULL
errBadCL	db	"Error, invalid or incomplete command line argument."
		db	LF, NULL

errSpdSpec	db	"Error, speed specifier incorrect."
		db	LF, NULL
errSpdValue	db	"Error, speed value must be between 1 and 55(9)."
		db	LF, NULL

errClrSpec	db	"Error, color specifier incorrect."
		db	LF, NULL
errClrValue	db	"Error, color value must be between 0 and 34511010(9)."
		db	LF, NULL

errSizSpec	db	"Error, size specifier incorrect."
		db	LF, NULL
errSizValue	db	"Error, size value must be between 121(9) and 2662(9)."
		db	LF, NULL

; -----
;  Local variables for spirograph routine.

t		dq	0.0			; loop variable
s		dq	0.0
tStep		dq	0.001			; t step
sStep		dq	0.0
x		dq	0			; current x
y		dq	0			; current y
scale		dq	1000.0			; speed scale

fltZero		dq	0.0
fltOne		dq	1.0
fltTwo		dq	2.0
fltThree	dq	3.0
fltFour		dq	4.0
fltSix		dq	6.0
fltTwoPiS	dq	0.0
fltTwoPi 	dq	6.24318530716

pi		dq	3.14159265358

fltTmp1		dq	0.0
fltTmp2		dq	0.0

red		dd	0			; 0-255
green		dd	0			; 0-255
blue		dd	0			; 0-255


; ------------------------------------------------------------

section  .text

; -----
; Open GL routines.

extern	glutInit, glutInitDisplayMode, glutInitWindowSize, glutInitWindowPosition
extern	glutCreateWindow, glutMainLoop
extern	glutDisplayFunc, glutIdleFunc, glutReshapeFunc, glutKeyboardFunc
extern	glutSwapBuffers, gluPerspective, glutPostRedisplay
extern	glClearColor, glClearDepth, glDepthFunc, glEnable, glShadeModel
extern	glClear, glLoadIdentity, glMatrixMode, glViewport
extern	glTranslatef, glRotatef, glBegin, glEnd, glVertex3f, glColor3f
extern	glVertex2f, glVertex2i, glColor3ub, glOrtho, glFlush, glVertex2d

extern	cos, sin


; ******************************************************************
;  Function getParams()
;	Gets draw speed, draw color, and screen size
;	from the command line arguments.

;	Performs error checking, converts ASCII/nonary to integer.
;	Command line format (fixed order):
;	  "-sp <nonaryNumber> -cl <nonaryNumber> -sz <nonaryNumber>"

; -----
;  Arguments:
;	ARGC, double-word, value 		in rdi
;	ARGV, double-word, address 		in rsi
;	speed, double-word, address		in rdx
;	color, double-word, address 	in rcx
;	size, double-word, address 		in r8



global getParams
getParams:

	;-----
	; push maintained registers (rbx, r12, r13, r14, r15)
	push	rbp
	mov	rbp, rsp
	push rbx
	push r12
	push r14

	;----------
	; Check that the correct amount of arguements have been entered

		; Usage Reminder (Err1)
		cmp rdi, 1
		je Err1

		; Correct Argument Number (Err2)
		cmp rdi, 7
		jne Err2

	; move ARGV into r12
	mov r12, rsi

	; move speed addr into r13
	mov r14, rdx

	;----------
	; Check for correct argument input

		;-----
		; Check first argument == '-sp' (Err3)

			; get address of ARGV[1]
			mov rbx, qword[r12 + 8] 	; +8 because ARGV is an array of addresses. addresses are always quad sized

			; if (ARGV[1] != '-sp') then Err3
			cmp dword[rbx], 0x0070732d 	; compare the first 4 bytes to the expected input (in HEX and backwards).
			jne Err3

		;-----
		; Check speed value specified is correct (Err4)

			; get address of ARGV[2] (speed value)
			mov rbx, qword[r12 + 16] ; +16 for ARGV[2] (2[position in array] * 8[quad size])

			; loop over each character to verify it's within range
			RangeCkLp:

				mov al, byte [rbx]

				; chr within range? '0' - '8' (Err4)
				cmp al, '0'
				jb Err4
				cmp al, '8'
				ja Err4

			; loop RangeCkLp
			inc rbx
			cmp byte[rbx], NULL
			jne RangeCkLp

			;-----
			; convert ASCII nonary to integer (base 10)

			; get addr of ARGV[2] again
			mov rbx, qword[r12 + 16] ; +16 for ARGV[2] (2[position in array] * 8[quad size])

			; call nonary2int macro
			nonary2int rbx, r14

			; check if value is within range
			cmp dword [r14], SPD_MIN
			jb Err4
			cmp dword [r14], SPD_MAX
			ja Err4

		;-----
		; Check second argument == '-cl' (Err5)

			; get address of ARGV[3]
			mov rbx, qword[r12 + 24]

			; if (ARGV[3] != '-cl') then Err5
			cmp dword [rbx], 0x006c632d 	; compare the first 4 bytes to the expected input (in HEX and backwards).
			jne Err5

		;-----
		; Check color value specified is correct (Err6)

			; get address of ARGV[4] (color value)
			mov rbx, qword[r12 + 32] ; +32 for ARGV[4] (4[position in array] * 8[quad size])

			; loop over each character to verify it's within range
			RangeCkLp2:

				mov al, byte [rbx]

				; chr within range? '0' - '8' (Err6)
				cmp al, '0'
				jb Err6
				cmp al, '8'
				ja Err6

			; loop RangeCkLp
			inc rbx
			cmp byte[rbx], NULL
			jne RangeCkLp2

			;-----
			; convert ASCII nonary to integer (base 10)

			; get addr of ARGV[4] again
			mov rbx, qword[r12 + 32] ; +32 for ARGV[4] (4[position in array] * 8[quad size])

			; call nonary2int macro
			push qword [r14]
			nonary2int rbx, rcx
			pop qword [r14]

			; check if value is within range
			cmp dword [rcx], CLR_MIN
			jb Err6
			cmp dword [rcx], CLR_MAX
			ja Err6

		;-----
		; Check third argument == '-sz' (Err7)

			; get address of ARGV[5]
			mov rbx, qword[r12 + 40]

			; if (ARGV[5] != '-sz') then Err7
			cmp dword[rbx], 0x007a732d 	; compare the first 4 bytes to the expected input (in HEX and backwards).
			jne Err7

		;-----
		; Check size value specified is correct (Err8)

			; get address of ARGV[6] (size value)
			mov rbx, qword[r12 + 48] ; +48 for ARGV[6] (6[position in array] * 8[quad size])

			; loop over each character to verify it's within range
			RangeCkLp3:

				mov al, byte [rbx]

				; chr within range? '0' - '8' (Err8)
				cmp al, '0'
				jb Err8
				cmp al, '8'
				ja Err8

			; loop RangeCkLp
			inc rbx
			cmp byte[rbx], NULL
			jne RangeCkLp3

			;-----
			; convert ASCII nonary to integer (base 10)

			; get addr of ARGV[6] again
			mov rbx, qword[r12 + 48] ; +48 for ARGV[6] (6[position in array] * 8[quad size])

			; call nonary2int macro
			push qword [r14]
			nonary2int rbx, r8
			pop qword [r14]

			; check if value is within range
			cmp dword [r8], SIZ_MIN
			jb Err8
			cmp dword [r8], SIZ_MAX
			ja Err8


	; No Errors Found.
	jmp NoErrs

	;-------------------------------------------
	; ----- Errors List

	; Error 1
	; errUsage		"Usage: ./wheels -sp <nonaryNumber> -cl <nonaryNumber> ..."
	Err1:

		; print error
		mov rdi, errUsage ; set argument for passing (error3)
		call printString
		
		; return FALSE to main
		mov rax, FALSE

		; maintain std call conv
		pop r14
		pop r12
		pop rbx
		pop rbp
		ret

	; Error 2
	; errBadCL		"Error, invalid or incomplete command line argument."
	Err2:

		; print error
		mov rdi, errBadCL ; set argument for passing
		call printString
		
		; return FALSE to main
		mov rax, FALSE

		; maintain std call conv
		pop r14
		pop r12
		pop rbx
		pop rbp

		ret

	; Error 3
	; errSpdSpec	"Error, speed specifier incorrect."
	Err3:

		; print error
		mov rdi, errSpdSpec ; set argument for passing
		call printString
		
		; return FALSE to main
		mov rax, FALSE

		; maintain std call conv
		pop r14
		pop r12
		pop rbx
		pop rbp

		ret

	; Error 4
	; errSpdValue	"Error, speed value must be between 1 and 55(9)."
	Err4:

		; print error
		mov rdi, errSpdValue ; set argument for passing
		call printString
		
		; return FALSE to main
		mov rax, FALSE

		; maintain std call conv
		pop r14
		pop r12
		pop rbx
		pop rbp

		ret

	; Error 5
	; errClrSpec	"Error, color specifier incorrect."
	Err5:

		; print error
		mov rdi, errClrSpec ; set argument for passing
		call printString
		
		; return FALSE to main
		mov rax, FALSE

		; maintain std call conv
		pop r14
		pop r12
		pop rbx
		pop rbp

		ret

	; Error 6
	; errClrValue	"Error, color value must be between 0 and 34511010(9)."
	Err6:

		; print error
		mov rdi, errClrValue ; set argument for passing
		call printString
		
		; return FALSE to main
		mov rax, FALSE

		; maintain std call conv
		pop r14
		pop r12
		pop rbx
		pop rbp

		ret

	; Error 7
	; errSizSpec	"Error, size specifier incorrect."
	Err7:

		; print error
		mov rdi, errSizSpec ; set argument for passing
		call printString
		
		; return FALSE to main
		mov rax, FALSE

		; maintain std call conv
		pop r14
		pop r12
		pop rbx
		pop rbp

		ret

	; Error 8
	; errSizValue	"Error, size value must be between 121(9) and 2662(9)."
	Err8:

		; print error
		mov rdi, errSizValue ; set argument for passing
		call printString
		
		; return FALSE to main
		mov rax, FALSE

		; maintain std call conv
		pop r14
		pop r12
		pop rbx
		pop rbp

		ret

;-----
; No Errors Detected, return TRUE to main
NoErrs:

; maintain std call conv
pop r14
pop r12
pop rbx
pop rbp

mov rax, TRUE

ret



; ******************************************************************
;  Draw wheels function.
;	Plot the provided functions:

; -----
;  Gloabl variables Accessed:

common	speed		1:4			; draw speed, dword, integer value
common	color		1:4			; draw color, dword, integer value
common	size		1:4			; screen size, dword, integer value

global drawWheels
drawWheels:

;-----
; push maintained registers (rbx, r12, r13, r14, r15)
push rbx
push r12
push r13
push r14
push r15

; -----
;  Set draw speed step
;	sStep = speed / scale

; speed int to float
mov r12, 0
mov r12d, dword[speed]
cvtsi2sd xmm5, r12

; sStep calculation
divsd xmm5, qword[scale]
movsd qword[sStep], xmm5

; -----
;  Prepare for drawing
	; glClear(GL_COLOR_BUFFER_BIT);
	mov	rdi, GL_COLOR_BUFFER_BIT
	call	glClear

	; glBegin();
	mov	rdi, GL_POINTS
	call	glBegin

; -----
;  Set draw color(r,g,b)
;	uses glColor3ub(r,g,b)

; initialize parameter registers
mov rdi, 0
mov rsi, 0
mov rdx, 0

; get blue color value
mov dl, byte [color]

;get green color value
mov ecx, dword [color]
ror ecx, 8
mov sil, cl

;get red color value
mov ecx, dword [color]
ror ecx, 16
mov dil, cl

call glColor3ub

; -----
;  main plot loop
;	iterate t from 0.0 to 2*pi by tStep
;	uses glVertex2d(x,y) for each formula

; 2pi
;movsd xmm2, qword [pi]
;mulsd xmm2, qword [fltTwo]
;movsd qword [fltTwoPiS], xmm2

; reset t = 0
mov qword [t], 0

;mov rcx, 1000

plotlp:

	; -----
	; formula 1

		; x = cos (t)
			movsd xmm0, qword [t]
			call cos
			movsd qword [x], xmm0

		; y = sin (t)
			movsd xmm0, qword [t]
			call sin
			movsd qword [y], xmm0

		; call OpenGL
		movsd xmm0, qword [x]
		movsd xmm1, qword [y]
		
		call glVertex2d

	; -----
	; formula 2

		; x = [cos(t) / 3] + [2cos(2pis) / 3]
		
			; cos(t)
			movsd xmm0, qword [t]
			call cos
			
			; cos(t) / 3
			divsd xmm0, qword[fltThree]

			; save in tmp1
			movsd qword[fltTmp1], xmm0

			; cos(2pis)
			movsd xmm4, qword [fltTwoPi]
			mulsd xmm4, qword [s]
			movsd qword [fltTwoPiS], xmm4
			movsd xmm0, qword [fltTwoPiS]
			call cos

			; 2 * cos(2pis)
			mulsd xmm0, qword [fltTwo]
			; 2 * cos(2pis) / 3
			divsd xmm0, qword [fltThree]

			addsd xmm0, qword [fltTmp1]
			movsd qword [x], xmm0

		; y = [sin(t) / 3] + [2sin(2pis) / 3]

			; sin(t)
			movsd xmm0, qword [t]
			call sin
			
			; sin(t) / 3
			divsd xmm0, qword[fltThree]

			; save in tmp1
			movsd qword[fltTmp1], xmm0

			; sin(2pis)
			movsd xmm0, qword [fltTwoPiS]
			call sin

			; 2 * sin(2pis)
			mulsd xmm0, qword [fltTwo]

			; 2 * sin(2pis) / 3
			divsd xmm0, qword [fltThree]

			addsd xmm0, qword [fltTmp1]
			movsd qword [y], xmm0

		; call OpenGL
		movsd xmm0, qword [x]
		movsd xmm1, qword [y]
		
		call glVertex2d

	; -----
	; formula 3

		; x = [2cos(2piS) / 3] + [t cos(4piS + [2pi / 3]) / 6pi]

			; cos(2pis)
			movsd xmm0, qword [fltTwoPiS]
			call cos

			; 2 * cos(2pis)
			mulsd xmm0, qword [fltTwo]
			; 2 * cos(2pis) / 3
			divsd xmm0, qword [fltThree]

			; save in tmp1
			movsd qword[fltTmp1], xmm0

			; ---
			; t cos(4piS + [2pi / 3]) \ 6pi

			; 4 *  pi * s
			movsd xmm0, qword [pi]
			mulsd xmm0, qword [fltFour]
			mulsd xmm0, qword [s]

			; 2pi / 3
			movsd xmm1, qword [fltTwoPi]
			divsd xmm1, qword [fltThree]

			; cos(4piS + [2pi / 3])
			addsd xmm0, xmm1
			call cos

			; t * cos
			mulsd xmm0, qword [t]

			; 6 * pi
			movsd xmm4, qword [pi]
			mulsd xmm4, qword [fltSix]

			; top / bottom
			divsd xmm0, xmm4

			; perfrom addition

			addsd xmm0, qword[fltTmp1]
			movsd qword [x], xmm0

		; y = [2sin(2piS) / 3] - [t sin(4piS + [2pi / 3]) / 6pi]

			; sin(2pis)
			movsd xmm0, qword [fltTwoPiS]
			call sin

			; 2 * sin(2pis)
			mulsd xmm0, qword [fltTwo]

			; 2 * sin(2pis) / 3
			divsd xmm0, qword [fltThree]

			; save in tmp1
			movsd qword[fltTmp1], xmm0


			; ---
			; t sin(4piS + [2pi / 3]) \ 6pi

			; 4 *  pi * s
			movsd xmm0, qword [pi]
			mulsd xmm0, qword [fltFour]
			mulsd xmm0, qword [s]

			; 2pi / 3
			movsd xmm1, qword [fltTwoPi]
			divsd xmm1, qword [fltThree]

			; sin(4piS + [2pi / 3])
			addsd xmm0, xmm1
			call sin

			; t * sin
			mulsd xmm0, qword [t]

			; 6 * pi
			movsd xmm4, qword [pi]
			mulsd xmm4, qword [fltSix]

			; top / bottom
			divsd xmm0, xmm4

			; perfrom subtraction
			movsd xmm1, qword[fltTmp1]
			subsd xmm1, xmm0
			movsd qword [y], xmm1

		; call OpenGL
		movsd xmm0, qword [x]
		movsd xmm1, qword [y]
		
		call glVertex2d

	; -----
	; formula 4

		; x

			; cos(2pis)
			movsd xmm0, qword [fltTwoPiS]
			call cos

			; 2 * cos(2pis)
			mulsd xmm0, qword [fltTwo]
			; 2 * cos(2pis) / 3
			divsd xmm0, qword [fltThree]

			; save in tmp1
			movsd qword[fltTmp1], xmm0

			; ---
			; t cos(4piS + [2pi / 3]) \ 6pi

			; 4 *  pi * s
			movsd xmm0, qword [pi]
			mulsd xmm0, qword [fltFour]
			mulsd xmm0, qword [s]

			call cos

			; t * cos
			mulsd xmm0, qword [t]

			; 6 * pi
			movsd xmm4, qword [pi]
			mulsd xmm4, qword [fltSix]

			; top / bottom
			divsd xmm0, xmm4

			; perfrom addition

			addsd xmm0, qword[fltTmp1]
			movsd qword [x], xmm0

		; y

			; sin(2pis)
			movsd xmm0, qword [fltTwoPiS]
			call sin

			; 2 * sin(2pis)
			mulsd xmm0, qword [fltTwo]

			; 2 * sin(2pis) / 3
			divsd xmm0, qword [fltThree]

			; save in tmp1
			movsd qword[fltTmp1], xmm0

			; ---
			; t sin(4piS) \ 6pi

			; 4 *  pi * s
			movsd xmm0, qword [pi]
			mulsd xmm0, qword [fltFour]
			mulsd xmm0, qword [s]

			call sin

			; t * sin
			mulsd xmm0, qword [t]

			; 6 * pi
			movsd xmm4, qword [pi]
			mulsd xmm4, qword [fltSix]

			; top / bottom
			divsd xmm0, xmm4

			; perfrom subtraction
			movsd xmm1, qword[fltTmp1]
			subsd xmm1, xmm0
			movsd qword [y], xmm1

		; call OpenGL
		movsd xmm0, qword [x]
		movsd xmm1, qword [y]
		
		call glVertex2d

	; -----
	; Formula 5

		; x = [2cos(2piS) / 3] + [t cos(4piS - [2pi / 3]) / 6pi]

			; cos(2pis)
			movsd xmm0, qword [fltTwoPiS]
			call cos

			; 2 * cos(2pis)
			mulsd xmm0, qword [fltTwo]
			; 2 * cos(2pis) / 3
			divsd xmm0, qword [fltThree]

			; save in tmp1
			movsd qword[fltTmp1], xmm0

			; ---
			; t cos(4piS - [2pi / 3]) \ 6pi

			; 4 *  pi * s
			movsd xmm0, qword [pi]
			mulsd xmm0, qword [fltFour]
			mulsd xmm0, qword [s]

			; 2pi / 3
			movsd xmm1, qword [fltTwoPi]
			divsd xmm1, qword [fltThree]

			; cos(4piS - [2pi / 3])
			subsd xmm0, xmm1
			call cos

			; t * cos
			mulsd xmm0, qword [t]

			; 6 * pi
			movsd xmm4, qword [pi]
			mulsd xmm4, qword [fltSix]

			; top / bottom
			divsd xmm0, xmm4

			; perfrom addition

			addsd xmm0, qword[fltTmp1]
			movsd qword [x], xmm0

		; y

			; sin(2pis)
			movsd xmm0, qword [fltTwoPiS]
			call sin

			; 2 * sin(2pis)
			mulsd xmm0, qword [fltTwo]

			; 2 * sin(2pis) / 3
			divsd xmm0, qword [fltThree]

			; save in tmp1
			movsd qword[fltTmp1], xmm0

			; ---
			; t sin(4piS - [2pi / 3]) \ 6pi

			; 4 *  pi * s
			movsd xmm0, qword [pi]
			mulsd xmm0, qword [fltFour]
			mulsd xmm0, qword [s]

			; 2pi / 3
			movsd xmm1, qword [fltTwoPi]
			divsd xmm1, qword [fltThree]

			; sin(4piS - [2pi / 3])
			subsd xmm0, xmm1
			call sin

			; t * sin
			mulsd xmm0, qword [t]

			; 6 * pi
			movsd xmm4, qword [pi]
			mulsd xmm4, qword [fltSix]

			; top / bottom
			divsd xmm0, xmm4

			; perfrom subtraction
			movsd xmm1, qword[fltTmp1]
			subsd xmm1, xmm0
			movsd qword [y], xmm1

		; call OpenGL
		movsd xmm0, qword [x]
		movsd xmm1, qword [y]
		
		call glVertex2d


	; t = t + tStep
	movsd xmm3, qword [t]
	addsd xmm3, qword [tStep]
	movsd qword [t], xmm3

; loop condition
; if (t <= 2pi) then loop
movsd xmm2, qword [pi]
mulsd xmm2, qword [fltTwo]
;movsd xmm2, qword [fltTwoPi]
ucomisd xmm2, qword [t]
jae plotlp


; -----
;  Display image

	call	glEnd
	call	glFlush

; -----
;  Update s, s += sStep;
;  if (s > 1.0)
;	s = 0.0;

	movsd	xmm0, qword [s]			; s+= sStep
	addsd	xmm0, qword [sStep]
	movsd	qword [s], xmm0

	movsd	xmm0, qword [s]
	movsd	xmm1, qword [fltOne]
	ucomisd	xmm0, xmm1			; if (s > 1.0)
	jbe	resetDone

	movsd	xmm0, qword [fltZero]
	movsd	qword [sStep], xmm0
resetDone:

	call	glutPostRedisplay

;-----
; pop maintained registers (rbx, r12, r13, r14, r15)
pop r15
pop r14
pop r13
pop r12
pop rbx

	ret

; ******************************************************************
;  Generic procedure to display a string to the screen.
;  String must be NULL terminated.
;  Algorithm:
;	Count characters in string (excluding NULL)
;	Use syscall to output characters

;  Arguments:
;	1) address, string
;  Returns:
;	nothing

global	printString
printString:
	push	rbp
	mov	rbp, rsp
	push	rbx
	push	rsi
	push	rdi
	push	rdx

; -----
;  Count characters in string.

	mov	rbx, rdi			; str addr
	mov	rdx, 0
strCountLoop:
	cmp	byte [rbx], NULL
	je	strCountDone
	inc	rbx
	inc	rdx
	jmp	strCountLoop
strCountDone:

	cmp	rdx, 0
	je	prtDone

; -----
;  Call OS to output string.

	mov	rax, SYS_write			; system code for write()
	mov	rsi, rdi			; address of characters to write
	mov	rdi, STDOUT			; file descriptor for standard in
						; EDX=count to write, set above
	syscall					; system call

; -----
;  String printed, return to calling routine.

prtDone:
	pop	rdx
	pop	rdi
	pop	rsi
	pop	rbx
	pop	rbp
	ret

; ******************************************************************


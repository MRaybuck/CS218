;  Matt Raybuck
;  CS 218 - Assignment #11
;  Functions Template

; ***********************************************************************
;  Data declarations
;	Note, the error message strings should NOT be changed.
;	All other variables may changed or ignored...

section	.data

; -----
;  Define standard constants.

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
SYS_lseek	equ	8			; system call code for file repositioning
SYS_fork	equ	57			; system call code for fork
SYS_exit	equ	60			; system call code for terminate
SYS_creat	equ	85			; system call code for file open/create
SYS_time	equ	201			; system call code for get time

LF		equ	10
SPACE		equ	" "
NULL		equ	0
ESC		equ	27

O_CREAT		equ	0x40
O_TRUNC		equ	0x200
O_APPEND	equ	0x400

O_RDONLY	equ	000000q			; file permission - read only
O_WRONLY	equ	000001q			; file permission - write only
O_RDWR		equ	000002q			; file permission - read and write

S_IRUSR		equ	00400q
S_IWUSR		equ	00200q
S_IXUSR		equ	00100q

; -----
;  Define program specific constants.

KEY_MAX		equ	56
KEY_MIN		equ	16

BUFF_SIZE	equ	800000			; buffer size

; -----
;  Variables for getOptions() function.

eof		db	FALSE

usageMsg	db	"Usage: blowfish <-en|-de> -if <inputFile> "
		db	"-of <outputFile>", LF, NULL
errIncomplete	db	"Error, command line arguments incomplete."
		db	LF, NULL
errExtra	db	"Error, too many command line arguments."
		db	LF, NULL
errFlag		db	"Error, encryption/decryption flag not "
		db	"valid.", LF, NULL
errReadSpec	db	"Error, invalid read file specifier.", LF, NULL
errWriteSpec	db	"Error, invalid write file specifier.", LF, NULL
errReadFile	db	"Error, opening input file.", LF, NULL
errWriteFile	db	"Error, opening output file.", LF, NULL

; -----
;  Variables for getX() function.

buffMax		dq	BUFF_SIZE - 1
curr		dq	BUFF_SIZE
wasEOF		db	FALSE

errRead		db	"Error, reading from file.", LF,
		db	"Program terminated.", LF, NULL

; -----
;  Variables for writeX() function.

errWrite	db	"Error, writting to file.", LF,
		db	"Program terminated.", LF, NULL

; -----
;  Variables for readKey() function.

chr		db	0

keyPrompt	db	"Enter Key (16-56 characters): ", NULL
keyError	db	"Error, invalid key size.  Key must be between 16 and "
		db	"56 characters long.", LF, NULL


; ------------------------------------------------------------------------
;  Unitialized data

section	.bss

buffer		resb	BUFF_SIZE


; ############################################################################

section	.text

; ***************************************************************
;  Routine to get arguments (encryption flag, input file
;	name, and output file name) from the command line.
;	Verify files by atemptting to open the files (to make
;	sure they are valid and available).

;  Command Line format:
;	./blowfish <-en|-de> -if <inputFileName> -of <outputFileName>

; -----
;  Arguments:
;	argc (value)									in rdi
;	address of argv table							in rsi
;	address of encryption/decryption flag (byte)	in rdx
;	address of read file descriptor (qword)			in rcx
;	address of write file descriptor (qword)		in r8
;  Returns:
;	TRUE or FALSE

global getOptions
getOptions:

	;-----
	; push maintained registers (rbx, r12, r13, r14, r15)
	push rbx
	push r12
	push r13
	push r14
	push r15

	;----------
	; Check that the correct amount of arguements have been entered

		; Usage Reminder (Err1)
		cmp rdi, 1
		je Err1

		; Not enough CL arguments (Err2)
		cmp rdi, 6
		jl Err2

		; Too many CL arguments (Err8)
		cmp rdi, 6
		jg Err8

	; move ARGV into r12
	mov r12, rsi

	; move address of encryption/decryption flag into r14
	mov r14, rdx

	; set enc/dec flag to true
	mov byte [r14], TRUE
	; move address of read file descriptor into r13
	mov r13, rcx

	; move address of write file descriptor into r15
	mov r15, r8

	;----------
	; Check for correct argument input

		;-----
		; Check first argument == '-en' or '-de' (Err3)

			; get address of ARGV[1]
			mov rbx, qword[r12 + 8] 	; +8 because ARGV is an array of addresses. addresses are always quad sized

			; if (ARGV[1] != '-en' or '-de') then Err3
			cmp dword[rbx], 0x006e652d 	; compare the first 4 bytes to the expected input (in HEX and backwards).
			je EnFound

				cmp dword[rbx], 0x0065642d 	; compare the first 4 bytes to the expected input (in HEX and backwards).
				jne Err3
					mov byte [r14], FALSE

			EnFound:

		;-----
		; Check second argument == '-if' (Err4)

			; get address of ARGV[2]
			mov rbx, qword[r12 + 16]

			; if (ARGV[2] != '-if') then Err4
			cmp dword [rbx], 0x0066692d	; compare the first 4 bytes to the expected input (in HEX and backwards).
			jne Err4

			;-----
			; Check if read file can be opened

			; open input file
			mov rax, SYS_open
			mov rdi, qword[r12 + 24]
			mov rsi, O_RDONLY
			syscall

			; check rax to see if the file opened successfully
			cmp rax, 0
			jl Err5

			mov qword[r13], rax

		;-----
		; Check fourth argument == '-of' (Err6)

			; get address of ARGV[4]
			mov rbx, qword[r12 + 32]

			; if (ARGV[4] != '-of') then Err6
			cmp dword[rbx], 0x00666f2d 	; compare the first 4 bytes to the expected input (in HEX and backwards).
			jne Err6

			;-----
			; Check if write file can be opened

			; don't actually read any characters into the buffer. Just see what rax returns
			mov rax, SYS_creat
			mov rdi, qword[r12 + 40]
			mov rsi, S_IRUSR | S_IWUSR
			syscall

			; check rax to see if the file opened successfully
			cmp rax, 0
			jl Err7

			mov qword[r15], rax 	; mov write file descriptor value into r15

	; No Errors Found.
	jmp NoErrs

	;-------------------------------------------
	; ----- Errors List

	; Error 1
	; usageMsg	"Usage: blowfish <-en|-de> -if <inputFile> -of <outputFile>"
	Err1:

		; print error
		mov rdi, usageMsg ; set argument for passing (error3)
		call printString
		
		; return FALSE to main
		mov rax, FALSE

		; maintain std call conv
		pop r15
		pop r14
		pop r13
		pop r12
		pop rbx
		
		ret

	; Error 2
	; errIncomplete	"Error, command line arguments incomplete."
	Err2:

		; print error
		mov rdi, errIncomplete ; set argument for passing
		call printString
		
		; return FALSE to main
		mov rax, FALSE

		; maintain std call conv
		pop r15
		pop r14
		pop r13
		pop r12
		pop rbx

		ret

	; Error 3
	; errFlag	"Error, encryption/decryption flag not valid"
	Err3:

		; print error
		mov rdi, errFlag ; set argument for passing
		call printString
		
		; return FALSE to main
		mov rax, FALSE

		; maintain std call conv
		pop r15
		pop r14
		pop r13
		pop r12
		pop rbx

		ret

	; Error 4
	; errReadSpec	"Error, invalid read file specifier."
	Err4:

		; print error
		mov rdi, errReadSpec ; set argument for passing
		call printString
		
		; return FALSE to main
		mov rax, FALSE

		; maintain std call conv
		pop r15
		pop r14
		pop r13
		pop r12
		pop rbx

		ret

	; Error 5
	; errReadFile "Error, opening input file."
	Err5:

		; print error
		mov rdi, errReadFile ; set argument for passing
		call printString
		
		; return FALSE to main
		mov rax, FALSE

		; maintain std call conv
		pop r15
		pop r14
		pop r13
		pop r12
		pop rbx

		ret

	; Error 6
	; errWriteSpec "Error, invalid write file specifier."
	Err6:

		; print error
		mov rdi, errWriteSpec ; set argument for passing
		call printString
		
		; return FALSE to main
		mov rax, FALSE

		; maintain std call conv
		pop r15
		pop r14
		pop r13
		pop r12
		pop rbx

		ret

	; Error 7
	; errWriteFile "Error, opening output file."
	Err7:

		; print error
		mov rdi, errWriteFile ; set argument for passing
		call printString
		
		; return FALSE to main
		mov rax, FALSE

		; maintain std call conv
		pop r15
		pop r14
		pop r13
		pop r12
		pop rbx

		ret

	; Error 8
	; errExtra "Error, too many command line arguments."
	Err8:

		; print error
		mov rdi, errExtra ; set argument for passing
		call printString
		
		; return FALSE to main
		mov rax, FALSE

		; maintain std call conv
		pop r15
		pop r14
		pop r13
		pop r12
		pop rbx

		ret

;-----
; No Errors Detected, return TRUE to main
NoErrs:

	; maintain std call conv
	pop r15
	pop r14
	pop r13
	pop r12
	pop rbx

mov rax, TRUE

ret

; ***************************************************************
;  Return the X array, 8 characters, from read buffer.
;	This routine performs all buffer management.

; -----
;   Arguments:
;	value of read file descriptor 	in rdi
;	address of X array 				in rsi
;  Returns:
;	TRUE or FALSE

;     NOTE's:
;	- returns TRUE when X array has been filled
;	- if < 8 characters in buffer, NULL fill
;	- returns FALSE only when asked for 8 characters
;		but there are NO more at all (which occurs
;		only when ALL previous characters have already
;		been returned).

;  The read buffer itself and some misc. variables are used
;  ONLY by this routine and as such are not passed.

; buffMax		dq	BUFF_SIZE - 1
; curr			dq	BUFF_SIZE
; wasEOF		db	FALSE

; errRead		db	"Error, reading from file.", LF,
;				db	"Program terminated.", LF, NULL

; buffer		resb	BUFF_SIZE

; actualRd = rax
; requestRd = buffer

global getX
getX:

; push all preserved registers
push rbx
push r12
push r13
push r14
push r15

; move arguments into preserved registers
mov r13, rdi 	; value of read file descriptor
mov r12, rsi 	; address of X array

; i = 0
mov rbx, 0

; xArr[] = NULL 
mov qword [r12], 0

; Get next character from buffer
getNxtChr:

; if (curr > bfmax)
mov rcx, qword [buffMax]
cmp qword [curr], rcx
jle DoneRd

	; if (wasEOF) then exit with FALSE
	cmp byte [wasEOF], TRUE
	jne NotEOF

		; maintain std call conv
		pop r15
		pop r14
		pop r13
		pop r12
		pop rbx

		; rax = TRUE
		mov rax, FALSE

		ret

	NotEOF:

	
	;  Call OS to read characters from input file.

	mov	rax, SYS_read		; system code for read()
	mov	rsi, buffer			; address of buffer to read into
	mov	rdi, r13			; file descriptor for read file
	mov rdx, BUFF_SIZE		; rdx = BUFF_SIZE to read into buffer
	syscall					; system call

	; set buffMax = BUFF_SIZE (will be changed to actualRd if necessary)
	mov qword [buffMax], BUFF_SIZE

	; if (rax < 0) then display error and exit with FALSE
	cmp rax, 0
	jge NoErr

		; print error
		mov rdi, errRead ; set argument for passing
		call printString
		
		; return FALSE to main
		mov rax, FALSE

		; maintain std call conv
		pop r15
		pop r14
		pop r13
		pop r12
		pop rbx

		ret		

	NoErr:

	; if (actualRd == 0) then exit with FALSE
	cmp rax, 0
	jg ChrsRemain

		; return FALSE to main
		mov rax, FALSE

		; maintain std call conv
		pop r15
		pop r14
		pop r13
		pop r12
		pop rbx

		ret	

	ChrsRemain:

	; if (actualRd < requestedRd) then wasEOF = TRUE and buffMax = ActualRd
	cmp rax, BUFF_SIZE
	jge RequestedWasRd

		mov byte [wasEOF], TRUE
		mov qword [buffMax], rax

	RequestedWasRd:

	; curr = 0
	mov qword [curr], 0

; end if
DoneRd:

; Chr = buffer[curr]
mov rcx, qword [curr]
mov dl,  byte [buffer + rcx]

; xArr[i] = Chr
mov byte [r12 + rbx], dl

; i++
inc rbx

; curr++
inc qword [curr]

; if (i < 8) then goto get next character from buffer
cmp rbx, 8
jl getNxtChr

; maintain std call conv
pop r15
pop r14
pop r13
pop r12
pop rbx

; rax = TRUE
mov rax, TRUE

ret




; ***************************************************************
;  Write X array (8 characters) to output file.
;	No requirement to buffer here.

;     NOTE:	for encryption write -> always write 8 characters
;		for decryption write -> exclude any trailing NULLS

;     NOTE:	this routine returns FALSE only if there is an
;		error on write (which would not normally occur).

; -----
;  Arguments are:
;	value of write file descriptor		in rdi
;	address of X array					in rsi
;	value of encryption flag 			in rdx
;  Returns:
;	TRUE or FALSE

global writeX
writeX:


	; preserve register contents

	push r12
	push r13
	push r14

	; put arguments in preserved registers

	mov r12, rdi 	; value of write file descriptor
	mov r13, rsi 	; address of X array
	mov r14, rdx 	; value of encryption flag

	; if (enc == true) then encrypt else decrypt
	cmp r14, TRUE
	jne DecryptFile

	; -----
	; Encrypt File

			; -----
			;  Call OS to write characters to output file.

			mov	rax, SYS_write		; system code for write()
			mov	rsi, r13			; address of char to write
			mov	rdi, r12			; file descriptor for write file
			mov rdx, 8				; rdx = 8 to write
			syscall					; system call

		; check for write error
		jmp WriteErrChk
	
	; end if

	; -----
	; Decrypt File

		DecryptFile:

		; -----
		;  Count characters to write.

			mov	rdx, 0

		chrCountLoop:

			cmp	byte [r13+rdx], NULL
			je	chrCountLoopDone

				inc	rdx
				jmp	chrCountLoop

		chrCountLoopDone:

			cmp	rdx, 0
			je	WriteErrChk

			; -----
			;  Call OS to write characters to output file.

			mov	rax, SYS_write		; system code for write()
			mov	rsi, r13			; address of char to write
			mov	rdi, r12			; file descriptor for write file
									; rdx=count to write, set above
			syscall					; system call

	; -----
	;  xArr written to file, check for write error.

	WriteErrChk:

	; check rax to see if the file opened successfully
	cmp rax, 0
	jl WriteErr

		; maintain std call conv
		pop r14
		pop r13
		pop r12

		; return TRUE to main
		mov rax, TRUE

		ret

	; -----
	; Write Error
 
	; errWrite	"Error, writting to file.", LF,
	;		"Program terminated.", LF, NULL
	WriteErr:

		; print error
		mov rdi, errWrite ; set argument for passing
		call printString
		
		; return FALSE to main
		mov rax, FALSE

		; maintain std call conv
		pop r14
		pop r13
		pop r12

		ret



; ***************************************************************
;  Get a encryption/decryption key from user.
;	Key must be between MIN and MAX characters long.

;     NOTE:	must ensure there are no buffer overflow
;		if the user enters >MAX characters

; -----
;  Arguments:
;	address of the key buffer	in rdi
;	value of key MIN length		in rsi
;	value of key MAX length		in rdx

global readKey
readKey:

;-----
; Set up Stack Dynamic Locals
	push rbp
	mov rbp, rsp
	sub rsp, 58

;-----
; push maintained registers (rbx, r12, r13, r14, r15)
	push rbx
	push r12
	push r13

;-----
; Preserve function arguements in maintained registers
	mov rbx, rdi 	;	address of the key buffer - rdi
	mov r12, rsi 	;	value of key MIN length - rsi
	mov r13, rdx 	;	value of key MAX length - rdx

;-----
; Prompt user for input
	mov rdi, keyPrompt
	call printString

;-----
; initialize SDLs

initializeSDLs:

	push rbx

	mov byte [rbp - 58], 0		; ChrCnt = 0
	lea rbx, byte [rbp - 57]	; stick addr of line into rbx


;--------------------------------------------------------------------------------
; ----- Read character from user

NxtChrLp:

	; inc ChrCnt
	inc byte [rbp - 58]

	; Sys call stuff
	mov rax, SYS_read
	mov rdi, STDIN
	mov rsi, chr
	mov rdx, 1
	syscall

	; check for LF in chr. If yes jmp to inputDone
	mov al, byte[chr]
	cmp al, LF
	je inputDone

	; If user exceeded input max, then don't store anymore characters.
	mov cl, byte [rbp - 58]
	cmp cl, KEY_MAX
	ja SkipStorage

		; chr storage code
		mov byte [rbx], al
		inc rbx

	; jump location to skip storage if input exceeds max
	SkipStorage:

jmp NxtChrLp

;-----
; End of user input

inputDone:

;-----
; Finish off string with a NULL character

; append NULL to end of line
mov byte [rbx], NULL

;-----
; pop address of the key buffer off the stack
pop rbx

;-----
; Was the input too long?

; if (ChrCnt > 56) then ERROR
mov al, byte [rbp - 58]
cmp al, KEY_MAX
ja ErrInvInput

; if (ChrCnt < 16) then ERROR
cmp al, KEY_MIN
jl ErrInvInput



jmp ExitErrChk
;--------------------------------------------------------------------------------
; ----- List of Errors

; ----------------------
; Error 1: Invalid Input
ErrInvInput:

	; print error
	mov rdi, keyError ; set argument for passing (error1)
	call printString
	
	; reprompt for input
	mov rdi, keyPrompt ; set argument for passing (promptStr)
	call printString

	; jump to top of function
	jmp initializeSDLs


;-----
; End of Error Checking
ExitErrChk:


;-----
; pop used registers to maintain std call conv
	pop r13
	pop r12
	pop rbx

; ret TRUE (place TRUE in rax)
mov rax, TRUE

mov rsp, rbp
pop rbp

ret



; ***************************************************************
;  Generic function to display a string to the screen.
;  String must be NULL terminated.

;  Algorithm:
;	Count characters in string (excluding NULL)
;	Use syscall to output characters

; -----
;  HLL Call:
;	printString(stringAddr);

;  Arguments:
;	1) address, string
;  Returns:
;	nothing

global	printString
printString:

; -----
;  Count characters to write.

	mov	rdx, 0
strCountLoop:
	cmp	byte [rdi+rdx], NULL
	je	strCountLoopDone
	inc	rdx
	jmp	strCountLoop
strCountLoopDone:
	cmp	rdx, 0
	je	printStringDone

; -----
;  Call OS to output string.

	mov	rax, SYS_write			; system code for write()
	mov	rsi, rdi			; address of char to write
	mov	rdi, STDOUT			; file descriptor for std in
						; rdx=count to write, set above
	syscall					; system call

; -----
;  String printed, return to calling routine.

printStringDone:
	ret

; ***************************************************************


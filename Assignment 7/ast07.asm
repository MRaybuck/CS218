; CS 218
; Assignment #7

;  Sort a list of number using the comb sort algorithm.
;  Also finds the minimum, median, maximum, sum, and average of the list.


; **********************************************************************************
;  Macro, "int2nonary", to convert a signed base-10 integer into
;  an ASCII string representing the nonary value.  The macro stores
;  the result into an ASCII string (byte-size, signed,
;  NULL terminated).  Each integer is a doubleword value.
;  Assumes valid/correct data.  As such, no error checking is performed.

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
	push rcx
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
	pop rcx

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

; **********************************************************************************

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

LIMIT		equ	10000
MAX_STR_LENGTH	equ	20

; -----
;  Provided data

array		dd	 1113, -1232,  2146,  1376,  5120,  2356,  3164,  4565, -3155,  3157
		dd	-2759,  6326,   171,  -547, -5628, -7527,  7569,  1177,  6785, -3514
		dd	 1001,   128, -1133,  9105,  3327,   101, -2115, -1108,     1,  2115
		dd	 1227, -1226,  5129,  -117,  -107,   105,  3109,  9999,  1150,  3414
		dd	-1107,  6103,  1245,  5440,  1465,  2311,   254,  4528, -1913,  6722
		dd	 4149,  2126, -5671,  7647, -4628,   327,  2390,  1177,  8275, -5614
		dd	 3121,  -415,   615,   122,  7217,   421,   410,  1129,  812,   2134
		dd	-1221,  2234, -7151,  -432,   114,  1629,  2114,  -522,  2413,   131
		dd	 5639,   126,  1162,   441,   127,   877,   199,  5679, -1101,  3414
		dd	 2101,  -133,  5133,  6450, -4532, -8619,   115,  1618,  9999,  -115
		dd	-1219,  3116,  -612,  -217,   127, -6787, -4569,  -679,  5675,  4314
		dd	 3104,  6825,  1184,  2143,  1176,   134,  5626,   100,  4566,  2346
		dd	 1214, -6786,  1617,   183, -3512,  7881,  8320,  3467, -3559,  -190
		dd	  103,  -112,    -1,  9186,  -191,  -186,   134,  1125,  5675,  3476
		dd	-1100,     1,  1146,  -100,   101,    51,  5616, -5662,  6328,  2342
		dd	 -137, -2113,  3647,   114,  -115,  6571,  7624,   128,  -113,  3112
		dd	 1724,  6316,  4217, -2183,  4352,   121,   320,  4540,  5679,  1190
		dd	-9130,   116,  5122,   117,   127,  5677,   101,  3727,     0,  3184
		dd	 1897, -6374,  1190,    -1,  1224,     0,   116,  8126,  6784,  2329
		dd	-2104,   124, -3112,   143,   176, -7534, -2126,  6112,   156,  1103
		dd	 1153,   172,  1146, -2176,  -170,   156,   164,  -165,   155,  5156
		dd	 -894, -4325,   900,   143,   276,  5634,  7526,  3413,  7686,  7563
		dd	  511,  1383, 11133,  4150,   825,  5721,  5615, -4568, -6813, -1231
		dd	 9999,   146,  8162,  -147,  -157,  -167,   169,   177,   175,  2144
		dd	-1527, -1344,  1130,  2172,  7224,  7525,   100,     1,  2100,  1134   
		dd	  181,   155,  2145,   132,   167,  -185,  2150,  3149,  -182,  1434
		dd	  177,    64, 11160,  4172,  3184,   175,   166,  6762,   158, -4572
		dd	-7561, -1283,  5133,  -150,  -135,  5631,  8185,   178,  1197,  1185
		dd	 5649,  6366,  3162,  5167,   167, -1177,  -169, -1177,  -175,  1169
		dd	 3684,  9999, 11217,  3183, -2190,  1100,  4611, -1123,  3122,  -131

length		dd	300

minimum		dd	0
median		dd	0
maximum		dd	0
sum		dd	0
average		dd	0

swapped		db  TRUE
OtrLpCon	db 	FALSE
DoNeg 		db  FALSE
mul10		dd 	10
div12 		dd  12
div2 		dd  2

; -----
;  Misc. data definitions (if any).



; -----
;  Provided string definitions.

newLine		db	LF, NULL

hdr		db	LF, "CS 218 - Assignment #7"
		db	LF, LF, NULL

hdrMin		db	"Minimum: ", NULL
hdrMax		db	"Maximum: ", NULL
hdrMed		db	"Median:  ", NULL
hdrSum		db	"Sum:     ", NULL
hdrAve		db	"Average: ", NULL
	

; **********************************************************************************

section .bss

tempString	resb	MAX_STR_LENGTH+1


; **********************************************************************************

section	.text
global	_start
_start:

; ******************************
;  Sort data using Comb sort.
;  Find sum and compute the average.
;  Get/save min and max.
;  Find median.


;  void function combSort(array, length)
;     gap = length
	mov rdi, 0
	mov edi, dword [length]

;
;     Outer loop until gap = 1 OR swapped = false
OuterLoop:

; Outer loop condition is checked here
	cmp edi, 1
	jbe Condition1False
		mov byte [OtrLpCon], TRUE
	Condition1False:
	cmp byte [swapped], TRUE
	jbe Condition2False
		mov byte [OtrLpCon], TRUE
	Condition2False:
	cmp byte [OtrLpCon], TRUE
	jne OuterLoopDone


;         gap = (gap * 10) / 12	     			// update gap for next sweep
	mov eax, edi
	mul dword [mul10]
	div dword [div12]
	mov edi, eax

;         if gap < 1
	cmp edi, 1
	jg GapSet
;           gap = 1
	mov edi, 1
;         end if
	GapSet:


;         i = 0
	mov rsi, 0
;         swapped = false
	mov byte [swapped], FALSE
;
;         inner loop until i + gap >= length	       // single comb sweep
	InnerLoop:

		mov r8, rsi
		add r8, rdi 	; r8 = i + gap

		; The inner loop condition is checked here
		cmp r8d, dword [length]
		jae InnerLoopDone

		mov ecx, dword [array + rsi * 4] ; array[i]
		mov ebx, dword [array + r8 * 4]  ; array[i+gap]
;             if  array[i] > array[i+gap]
		cmp ecx, ebx
		jle SwapDone

;                 swap(array[i], array[i+gap])
		mov dword [array + rsi * 4], ebx	; array[i] = array[i+gap]
		mov dword [array + r8 * 4], ecx		; array[i+gap] = array[i]
;                 swapped = true
		mov byte [swapped],	TRUE
;             end if
		SwapDone:
;             i = i + 1
		inc rsi 	; i++
		jmp InnerLoop
;         end inner loop
		InnerLoopDone:
			mov byte [OtrLpCon], FALSE ; Set outer loop condition false for checking above
			jmp OuterLoop
;      end Outer loop
		OuterLoopDone:
;  end function


; -----
;  Create array pointer in rbx.

	mov rbx, array

; -----
; Initialize rcx and store array length in ecx to be used as loop decrement.

	mov rcx, 0
	mov ecx, dword [length]

; -----
; Calculate the Sum.

CalcLoop:
		
		; -----
		; Move next value of array into eax
		
		mov eax, dword [rbx]

		; -----
		; Keep a running sum of all the values
		
		add dword [sum], eax

		; -----
		; Increment pointer so it points to the next element in the array array.
		
		add rbx, 4

loop CalcLoop
; dec rcx
; cmp rcx, 0
; jne CalcLoop

; -----
; Calculate the average

	mov eax, dword [sum]
	cdq
	idiv 	 dword [length]
	mov dword [average], eax

; -----
; Find min and max values

	mov r14d, dword [array]
	mov eax, dword [length]
	sub eax, 1
	mov r13d, dword [array + eax * 4]
	mov dword [minimum], r14d
	mov dword [maximum], r13d


; -----
; Find median

	mov r13d, dword [array + 149 * 4]
	mov r14d, dword [array + 150 * 4]

	add r13d, r14d
	mov eax, r13d
	cdq
	idiv dword [div2]

	mov dword [median], eax


; ******************************
;  Display results to screen in duodecimal.

	printString	hdr

	printString	hdrMin
	int2nonary	minimum, tempString
	printString	tempString
	printString	newLine

	printString	hdrMax
	int2nonary	maximum, tempString
	printString	tempString
	printString	newLine

	printString	hdrMed
	int2nonary	median, tempString
	printString	tempString
	printString	newLine

	printString	hdrSum
	int2nonary	sum, tempString
	printString	tempString
	printString	newLine

	printString	hdrAve
	int2nonary	average, tempString
	printString	tempString
	printString	newLine
	printString	newLine

; ******************************
;  Done, terminate program.

last:
	mov	rax, SYS_exit
	mov	rbx, SUCCESS
	syscall


; *****************************************************************
;	Matt Raybuck
;	Assignmnet #5
;	Section #1002

; -----
;  Write a simple assembly language program to calculate some geometric information based on a set of two points.
;  The program will calculate slope, distance between two points, and the midpoint of the two points.

;  Once the lateral slopes and distances are compute, the program will find the min, max, estimated median value,
;  sum, and average for the slopes and distances arrays.

; *****************************************************************
;  Data Declarations

; --------------------------------------------------------------

section	.data

; -----
;  Define constants.

NULL		equ	0			; end of string

TRUE		equ	1
FALSE		equ	0

EXIT_SUCCESS	equ	0			; successful operation
SYS_exit	equ	60			; call code for terminate

; -----
;  Data Set

; Points Set #1, (x1, y1)
x1		db	 -33, -14, -23, -11, -34
		db	 -12, -10, -85, -63, -05
		db	 -64, -13, -24, -13, -65 
		db	 -44, -12, -13, -12, -23
		db	 -65, -64, -73, -16, -34
		db	 -53, -13, -43, -13, -35
		db	 -44, -69, -34, -33, -32
		db	 -34, -23, -15, -14, -01
		db	 -22, -42, -33, -02, -11
		db	 -25, -14, -23, -46, -54

y1		db	  48,  94,  62,  63,  18
		db	  61,  45,  52,  29,  65
		db	  12,  10,  85,  63,  25
		db	  76,  47,  55,  19,  13
		db	  28,  45,  61,  64,  65
		db	  77,  20,  56,  47,  61
		db	  52,  19,  65,  61,  31
		db	  65,  14,  23,  15,  14
		db	  01,  71,  11,  21,  21
		db	  18,  25,  31,  34,  55

; Points Set #2, (x2, y2)
x2		dw	 245, 234, 123, 223, 123
		dw	 253, 153, 243, 153, 235
		dw	 134, 234, 156, 264, 142
		dw	 253, 153, 284, 142, 234
		dw	 245, 234, 123, 223, 123
		dw	 234, 134, 256, 164, 242
		dw	 253, 253, 184, 242, 134
		dw	 256, 164, 242, 134, 201
		dw	 101, 223, 172, 203, 177
		dw	 215, 114, 243, 153, 255
 
y2		dw	 4445, 4734, 3123, 3023, 1223
		dw	 2753, 1753, 4443, 2953, 3235
		dw	 1734, 3734, 2256, 4764, 4342
		dw	  753, 1753, 1284, 3442, 5434
		dw	 2145, 2734, 2123, 1223, 6523
		dw	 4734, 2734,  956, 7264, 1242
		dw	 1753, 1753, 6784, 4542, 7134
		dw	 2756, 2764, 2742, 5734, 1201
		dw	 4701, 1723, 1772, 4612, 3422
		dw	 1713, 6703, 5724, 1602, 5614

length		dq	50

slpMin		dd	0
slpEstMed	dd	0
slpMax		dd	0
slpSum		dd	0
slpAve		dd	0

dstMin		dd	0
dstEstMed	dd	0
dstMax		dd	0
dstSum		dd	0
dstAve		dd	0

dstx1x2		dd	0
dsty1y2		dd	0

; --------------------------------------------------------------
; Uninitialized data

section	.bss

slopes		resd	50
distances	resd	50
xMid		resw	50
yMid		resw	50


; *****************************************************************

section	.text
global _start
_start:


; -----
; Initialize data for slope calculations

	mov rsi, 0
	mov rcx, qword[length]


; -----
; Calculate slope
;
; Slope = y2[i] - y1[i]
;         -------------
;         x2[i] - x1[i]

SlpLoop:

	; -----
	; Slope Calculation: y2[i] - y1[i]

		movsx eax, word [y2 + rsi * 2]
		movsx ebx, byte [y1 + rsi]

		sub eax, ebx

	; -----
	; Slope Calculation: x2[i] - x1[i]

		movsx r8d, word [x2 + rsi * 2]
		movsx r9d, byte [x1 + rsi]

		sub r8d, r9d

	; -----
	; Slope Calculation: y2[i] - y1[i]
	;                    -------------
	;                    x2[i] - x1[i]

		; since y2[i] - y1[i] is in eax we can just cdq to prep for division.
		cdq
		idiv r8d
		mov dword [slopes + rsi * 4], eax
		
	; -----
	; increment rsi and loop

		inc rsi

loop SlpLoop

; -----
; Reinitialize data for distance calculations

	mov rsi, 0
	mov rcx, qword[length]

; -----
; Calculate Distance
;
; Distance = sqrt[(x2[i] + x1[i])^2 + (y2[i] + y1[i])^2]

DistLoop:

	; -----
	; Distance Calculation: (x2[i] + x1[i])^2

		mov   r8w, word [x2 + rsi * 2]
		movsx r9w, byte [x1 + rsi]

		add r8w, r9w

		mov ax, r8w
		imul 	 r8w
		mov word [dstx1x2], ax
		mov word [dstx1x2 + 2], dx

	; -----
	; Distance Calculation: (y2[i] + y1[i])^2

		mov   ax, word [y2 + rsi * 2]
		movsx bx, byte [y1 + rsi]

		add ax, bx

		imul 	 ax
		mov word [dsty1y2], ax
		mov word [dsty1y2 + 2], dx

	; -----
	; Distance Calculation: sqrt[(x2[i] + x1[i])^2 + (y2[i] + y1[i])^2]

		mov ebx, dword [dsty1y2]
		mov eax, dword [dstx1x2]
		add eax, ebx

		cvtsi2sd xmm0, eax
		sqrtsd xmm0, xmm0
		cvtsd2si eax, xmm0

		mov dword [distances + rsi * 4], eax

	; -----
	; increment rsi and loop

		inc rsi

loop DistLoop

; -----
; Reinitialize data for midpoint calculations

	mov rsi, 0
	mov rcx, qword[length]
; -----
; For midpoint division
	mov r14d, 2

; -----
; Calculate Midpoints

Midloop:

	; -----
	; Midpoint Calculation: (x2[i] + x1[i]) / 2

		mov   ax, word [x2 + rsi * 2]
		movsx bx, byte [x1 + rsi]

		add ax, bx

		cwd
		idiv 	 r14d

		mov word [xMid + rsi * 2], ax

	; -----
	; Midpoint Calculation: (y2[i] + y1[i]) / 2

		mov   ax, word [y2 + rsi * 2]
		movsx bx, byte [y1 + rsi]

		add ax, bx

		cwd
		idiv	 r14d

		mov word [yMid + rsi * 2], ax

	; -----
	; increment rsi and loop

		inc rsi

loop Midloop

; -----
; Initialize data for sum, min, and max loop

	mov rbx, slopes
	mov rcx, 0
	mov rcx, qword [length]

; -----
; Sum the first element for the est. median

	mov eax, dword [slopes]
	add dword [slpEstMed], eax

; -----
; Calculate the Sum, find the min, and find the max.

SlpCalcLoop:
			
		; -----
		; Move next value of slopes into eax
		
		mov eax, dword [rbx]

		; -----
		; Keep a running sum of all the values
		
		add dword [slpSum], eax

		; -----
		; If (eax >= dword [slpMin]) then jump to minDone
		
		cmp eax, dword [slpMin]
		jae minDone
			mov dword [slpMin], eax

	minDone:

		; -----
		; If (eax <= dword [slpMax]) then jump to maxDone
		
		cmp eax, dword [slpMax]
		jbe maxDone
			mov dword [slpMax], eax

	maxDone:

		; -----
		; Sum the last element, and the middle elements for the est. median

		cmp rcx, 26
		jne NotMid
			add dword [slpEstMed], eax

	NotMid:

		cmp rcx, 1
		jne NotLast
			add dword [slpEstMed], eax

	NotLast:

		; -----
		; Increment pointer so it points to the next element in the lst array.
		
		add rbx, 4

loop SlpCalcLoop

; -----
; Calculate the average

	
	mov eax, dword [slpSum]
	cdq
	idiv 	 qword [length]
	mov dword [slpAve], eax

; -----
; Finish calculations for the estmated median

	mov eax, dword [slpEstMed]
	cdq
	mov ecx, 3
	idiv 	ecx
	mov dword [slpEstMed], eax

; -----
; Initialize data for sum, min, and max loop

	mov rbx, distances
	mov rcx, 0
	mov rcx, qword [length]

; -----
; Sum the first element for the est. median

	mov eax, dword [distances]
	add dword [dstEstMed], eax

; -----
; Calculate the Sum, find the min, and find the max.

DistCalcLoop:
			
		; -----
		; Move next value of slopes into eax
		
		mov eax, dword [rbx]

		; -----
		; Keep a running sum of all the values
		
		add dword [dstSum], eax

		; -----
		; If (eax >= dword [dstMin]) then jump to minDone
		
		cmp eax, dword [dstMin]
		jae dstminDone
			mov dword [dstMin], eax

	dstminDone:

		; -----
		; If (eax <= dword [dstMax]) then jump to maxDone
		
		cmp eax, dword [dstMax]
		jbe dstmaxDone
			mov dword [dstMax], eax

	dstmaxDone:

		; -----
		; Sum the last element, and the middle elements for the est. median

		cmp rcx, 26
		jne dstNotMid
			add dword [dstEstMed], eax

	dstNotMid:

		cmp rcx, 1
		jne dstNotLast
			add dword [dstEstMed], eax

	dstNotLast:

		; -----
		; Increment pointer so it points to the next element in the lst array.
		
		add rbx, 4

loop DistCalcLoop

; -----
; Calculate the average
	
	mov eax, dword [dstSum]
	cdq
	idiv 	 qword [length]
	mov dword [dstAve], eax

; -----
; Finish calculations for the estmated median

	mov eax, dword [dstEstMed]
	cdq
	mov ecx, 3
	idiv 	ecx
	mov dword [dstEstMed], eax

; *****************************************************************
;	Done, terminate program.

last:
	mov	eax, SYS_exit		; call call for exit (SYS_exit)
	mov	ebx, EXIT_SUCCESS	; return code of 0 (no error)
	syscall


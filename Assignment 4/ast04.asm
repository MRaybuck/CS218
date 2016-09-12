; *****************************************************************
;	Matt Raybuck
;	Assignmnet #4
;	Section #1002

; -----
;  Write a simply assembly language program to the find the minimum, estimated median value,
;  maximum, sum, and integer average of a list of numbers.

;  Additionally, the program will also find the sum, count, and integer average for the even numbers.
;  The program will also find the sum, count, and integer average for the numbers that are evenly divisble by 8.

; NOTE: Since the length of the array is 100, the exact middle is 50. In order to estimate the median value,
; a choice has to be made which two "middle values" to use (e.g. either 50 and 51  or 49 and 50). This program
; will use the values found at 49 and 50.

; *****************************************************************
;  Data Declarations

section	.data
; -----
;  Define constants.

NULL		equ	0			; end of string

TRUE		equ	1
FALSE		equ	0

EXIT_SUCCESS	equ	0			; successful operation
SYS_exit	equ	60			; call code for terminate

; -----
;  Assignment #4 Data Declarations

lst		dd	3712, 1116, 1539, 1240, 1674
		dd	1629, 2412, 1818, 1242, 3333 
		dd	2313, 1215, 2726, 1140, 2565
		dd	2871, 1614, 2418, 2513, 1422 
		dd	1809, 1215, 1525, 2712, 1441
		dd	3622, 1888, 1729, 1615, 2724 
		dd	1217, 1224, 1580, 1147, 2324
		dd	1425, 1816, 1262, 2718, 1192 
		dd	1435, 1235, 2764, 1615, 1310
		dd	1765, 1954, 2967, 1515, 1556 
		dd	2342, 7321, 1556, 2727, 1227
		dd	1927, 1382, 1465, 3955, 1435 
		dd	1225, 2419, 2534, 1345, 2467
		dd	1615, 1959, 1335, 2856, 2553
		dd	1035, 1833, 1464, 1915, 1810
		dd	1465, 1554, 2267, 1615, 1656 
		dd	2192, 1825, 1925, 2312, 1725
		dd	2517, 1498, 1677, 1475, 2034
		dd	1223, 1883, 1173, 1350, 2415
		dd	1089, 1125, 1118, 1713, 3024
length		dd	100

lstMin		dd	0
estMed		dd	0
lstMax		dd	0
lstSum		dd	0
lstAve		dd	0

evenCnt		dd	0
evenSum		dd	0
evenAve		dd	0

eightCnt	dd	0
eightSum	dd	0
eightAve	dd	0

; -----
; Additional declarations to find estMed

lstFirst	dd  0
lstLast		dd  0
lstMid1		dd  0
lstMid2		dd  0

; *****************************************************************

section	.text
global _start
_start:

; -----
; Populate lstMin and lstMax with first element of lst.

	mov eax, dword [lst]
	mov dword [lstMin], eax
	mov dword [lstMax], eax

; -----
;  Create lst pointer in rdx.

	mov rdx, lst

; -----
; Initialize rcx and store lst length in ecx to be used as loop decrement.

	mov rcx, 0
	mov ecx, dword [length]

; -----
; Calculate the Sum, find the min, and find the max.

	CalcLoop:
			
			; -----
			; Move next value of lst into eax
			
			mov eax, dword[rbx]

			; -----
			; Keep a running sum of all the values
			
			add dword[lstSum], eax

			; -----
			; If (eax >= dword [lstMin]) then jump to minDone
			
			cmp eax, dword[lstMin]
			jae minDone
				mov dword[lstMin], eax

		minDone:

			; -----
			; If (eax <= dword [lstMax]) then jump to maxDone
			
			cmp eax, dword [lstMax]
			jbe maxDone
				mov dword [lstMax], eax

		maxDone:

			; -----
			; Increment pointer so it points to the next element in the lst array.
			
			add rbx, 4

	loop CalcLoop
	; dec rcx
	; cmp rcx, 0
	; jne CalcLoop

	; -----
	; Calculate the average

	mov edx, 0
	mov eax, dword [lstSum]
	div 	 dword [length]
	mov dword [lstAve], eax



; *****************************************************************
;	Done, terminate program.

last:
	mov	eax, SYS_exit		; call call for exit (SYS_exit)
	mov	ebx, EXIT_SUCCESS	; return code of 0 (no error)
	syscall


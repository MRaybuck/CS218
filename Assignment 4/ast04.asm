; *****************************************************************
;	Matt Raybuck
;	Assignmnet #4
;	Section #1002

; -----
;  Write a simply assembly language program to the find the minimum, estimated median value,
;  maximum, sum, and integer average of a list of numbers.

;  Additionally, the program will also find the sum, count, and integer average for the even numbers.
;  The program will also find the sum, count, and integer average for the numbers that are evenly divisble by 8.


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



; *****************************************************************

section	.text
global _start
_start:



; *****************************************************************
;	Done, terminate program.

last:
	mov	eax, SYS_exit		; call call for exit (SYS_exit)
	mov	ebx, EXIT_SUCCESS	; return code of 0 (no error)
	syscall


;  CS 218 - Assignment 8
;  Functions Template.

; --------------------------------------------------------------------
;  Write some assembly language functions.

;  The value returning function lstEstMedian() returns the
;  median for a list of unsorted numbers.

;  The void function, combSort(), sorts the numbers into
;  ascending order (large to small).  Uses the comb sort
;  algorithm from assignment #7 (with sort order modified).

;  The value returning function lstSum() returns the sum
;  for a list of numbers.

;  The value returning function lstAverage() returns the
;  average for a list of numbers.

;  The value returning function lstMedian() returns the
;  median for a list of sorted numbers.

;  The void function, lstStats(), finds the sum, average, minimum,
;  maximum, and median for a list of numbers.  Results returned
;  via reference.

;  The value returning function, lstKurtosis(), computes the
;  kurtosis statictic for the data set.  Summation for the
;  dividend must be performed as a quad.

; ********************************************************************************

section	.data

; -----
;  Define constants.

TRUE		equ	1
FALSE		equ	0

; -----
;  Local variables for combSort() function.
;swapped		db  TRUE
;OtrLpCon	db 	FALSE
;mul10		dd 	10
;div12 		dd  12


; -----
;  Local variables for lstStats() function (if any).



section	.bss

; -----
;  Unitialized variables (if any).



; ********************************************************************************

section	.text

; **********************************************************************************
;  Perform comb sort

; -----
;  HLL Call:
;	call combSort(list, len)

;  Arguments Passed:
;	1) list, addr - rdi
;	2) length, value - rsi

;  Returns:
;	sorted list (list passed by reference)


global	combSort
combSort:

; -----
; Maintain Standard Calling Conventions

	; -----
	; Retrieve stack arguements

	; -----
	; push maintained registers (rbx, r12, r13, r14, r15)

	;-----
	; Create stack dynamic locals
	
	push rbp
	mov rbp, rsp
	sub rsp, 10

	mov byte [rbp - 10], TRUE ; swapped = TRUE
	mov byte [rbp - 9], FALSE ; OtrLpCon = FALSE
	mov dword [rbp - 8], 12	  ; div12 = 12
	mov dword [rbp - 4], 10   ; mul10 = 10

; ----- 
; gap = length
mov rcx, 0
mov ecx, esi

; Outer loop until gap = 1 OR swapped = false
OuterLoop:
	
	; -----
	; Outer loop condition is checked here
	cmp ecx, 1
	jbe Condition1False
		mov byte [rbp - 9], TRUE

	Condition1False:
	cmp byte [rbp - 10], TRUE
	jbe Condition2False
		mov byte [rbp - 9], TRUE

	Condition2False:
	cmp byte [rbp - 9], TRUE
	jne OuterLoopDone

	; -----
	; Outer Loop Body

	; -----
	; gap = (gap * 10) / 12			// update gap for next sweep
	mov rax, 0 ; zeroing out rax as a precaution
	mov eax, ecx
	mul dword [rbp - 4]
	div dword [rbp - 8]
	mov ecx, eax

	; -----
	; if gap < 1
	cmp ecx, 1
	jg GapSet
		; gap = 1
		mov ecx, 1
	; end if
	
	GapSet:

	; -----
	; Data Preparation for Inner Loop

	; -----
	; i = 0
	mov rdx,  0

	; -----
	; swapped = false
	mov byte [rbp - 10], FALSE

	; -----
	; inner loop until i + gap >= length      // single comb sweep
	InnerLoop:

		mov r8, rdx
		add r8, rcx ; r8 = i + gap

		; -----
		; The inner loop condition is checked here
		cmp r8d, esi
		jae InnerLoopDone

		; -----
		; Inner Loop Body

		mov r9d, dword [rdi + rdx * 4] ; array[i]
		mov r10d, dword [rdi + r8 * 4] ; array[i+gap]

		; -----
		; if  array[i] > array[i+gap]
		cmp r9d, r10d
		jle SwapDone

			; -----
			; swap(array[i], array[i+gap])
			mov dword [rdi + rdx * 4], r10d ; array[i] = array[i+gap]
			mov dword [rdi + r8 * 4], r9d 	; array[i+gap] = array[i]

			; -----
			; swapped = true
			mov byte [rbp - 10], TRUE

		; -----
		; end if
		SwapDone:

		; -----
		; i = i + 1
		inc rdx

		jmp InnerLoop

	; -----
	; end inner loop
	InnerLoopDone:

	; -----
	; Set outer loop condition false for checking above
	mov byte[rbp - 9], FALSE

	jmp OuterLoop

; -----
; end Outer Loop
OuterLoopDone:


; -----
; Pop used registers to maintain standard call convention
mov rsp, rbp
pop rbp


ret


; --------------------------------------------------------
;  Find statistical information for a list of integers:
;	sum, average, minimum, maximum, and, median

;  Note, for an odd number of items, the median value is defined as
;  the middle value.  For an even number of values, it is the integer
;  average of the two middle values.

;  This function must call the lstAvergae() function
;  to get the average.

;  Note, assumes the list is already sorted.

; -----
;  Call:
;	call lstStats(list, len, sum, ave, min, max, med)

;  Arguments Passed:
;	list, addr - rdi
;	length, value - rsi
;	sum, addr - rdx
;	average, addr - rcx
;	minimum, addr - r8
;	maximum, addr - r9
;	median, addr - stack, rbp+16

;  Returns:
;	sum, average, minimum, maximum, and median
;		via pass-by-reference


global lstStats
lstStats:

; -----
; Maintain Standard Calling Conventions

	; -----
	; Retrieve stack arguements
	push rbp
	mov rbp, rsp

	; -----
	; push maintained registers (rbx, r12, r13, r14, r15)
	push rbx
	push r12
	push r13
	push r14

	; -----
	; Find Min
	mov eax, dword [rdi]
	mov dword [r8], eax

	; -----
	; Find Max
	mov r10, 0
	mov r10, rsi
	dec r10
	mov eax, dword [rdi + r10 * 4]
	mov dword [r9], eax

	; ----------
	; lstSum Function Call

	; -----
	; Move function arguements into maintained registers before calling other functions

	mov rbx, rdi ; lst
	mov r12d, esi ; len
	mov r13, rdx ; sum
	mov r14, rcx ; ave

	; -----
	; pass arguments for lstSum into correct registers

	mov rdi, rbx
	mov esi, r12d

	call lstSum
	mov dword [r13], eax

	; ----------
	; lstAverage Function Call

	mov rdi, rbx
	mov esi, r12d

	call lstAverage
	mov dword [r14], eax

	; ----------
	; lstMedian Function Call

	; -----
	; arguments
	mov rdi, rbx
	mov esi, r12d

	call lstMedian

	; -----
	; Take the seventh argument for lstStats off the stack and store the median

	mov r11, qword [rbp + 16]
	mov dword[r11], eax

	; -----
	; pop all pushes to the stack

	pop r14
	pop r13
	pop r12
	pop rbx
	pop rbp

ret


; --------------------------------------------------------
;  Function to calculate the median of a sorted list.

; -----
;  Call:
;	ans = lstMedian(lst, len)

;  Arguments Passed:
;	1) list, address - rdi
;	1) length, value - rsi

;  Returns:
;	median (in eax)


global	lstMedian
lstMedian:

	; -----
	; check if length is even or odd
	mov rcx, 2
	mov edx, 0
	mov rax, rsi
	div rcx

	; if even
	cmp edx, 0
	jne OddResult

		; store number at that position in r8d
		mov r8d, dword [rdi + rax * 4]

		; decrement division result so r9d has correct value
		dec eax

	OddResult:

	; store number at that position in r9d
	mov r9d, dword [rdi + rax * 4]

	mov eax, r9d

	; check if remainder from division == 0
	cmp edx, 0
	jne OddResult2
	
		add r8d, r9d
		mov eax, r8d
		cdq
		idiv rcx

	; if it doesn't == 0 then it's odd and no addition manipulations are needed 
	OddResult2:

ret


; --------------------------------------------------------
;  Function to calculate the median of a sorted list.

; -----
;  Call:
;	ans = lstEstMedian(lst, len)

;  Arguments Passed:
;	1) list, address - rdi
;	1) length, value - rsi

;  Returns:
;	estimated median (in eax)


global	lstEstMedian
lstEstMedian:

	; -----
	; push maintained registers (rbx, r12, r13, r14, r15)
	push rbx
	push r12
	push r13

	; -----
	; Find min
	mov r10, 0
	mov r10, rsi
	dec r10
	mov eax, dword [rdi + r10 * 4]
	mov ebx, eax

	; -----
	; Find Max
	mov eax, dword [rdi]
	mov r12d, eax

	; -----
	; check if length is even or odd
	mov rcx, 2
	mov edx, 0
	mov rax, rsi
	div rcx
	mov r13d, edx

	; in the case of even length the middle is one behind current eax. Odd will follow this.
	dec eax

	; store number at that position in r8d
	mov r8d, dword [rdi + rax * 4]

	; increment division result
	inc eax

	; store number at that position in r9d
	mov r9d, dword [rdi + rax * 4]

	; sum all numbers
	add ebx, r12d
	add ebx, r8d
	add ebx, r9d

	; check if remainder from division == 0
	cmp r13d, 0
	jne OddResult3
	
		mov rcx, 4
		mov eax, ebx
		cdq
		idiv rcx

	; if it doesn't == 0 then it's odd and no addition manipulations are needed 
	OddResult3:

	cmp r13d, 0
	je EvenResult

		mov rcx, 3
		mov eax, ebx
		cdq
		idiv rcx

	EvenResult:

	; -----
	; pop all pushes

	pop r13
	pop r12
	pop rbx

ret


; --------------------------------------------------------
;  Function to calculate the sum of a list.

; -----
;  Call:
;	ans = lstSum(lst, len)

;  Arguments Passed:
;	1) list, address - rdi
;	1) length, value - rsi

;  Returns:
;	sum (in eax)


global	lstSum
lstSum:

mov rdx, rdi
mov rcx, rsi
mov eax, 0

CalcLoop:
		
		; -----
		; Move next value of array into eax
		
		mov r8d, dword [rdx]

		; -----
		; Keep a running sum of all the values
		
		add eax, r8d

		; -----
		; Increment pointer so it points to the next element in the array array.
		
		add rdx, 4

loop CalcLoop
; dec rcx
; cmp rcx, 0
; jne CalcLoop

ret


; --------------------------------------------------------
;  Function to calculate the average of a list.

; -----
;  Call:
;	ans = lstAverage(lst, len)

;  Arguments Passed:
;	1) list, address - rdi
;	1) length, value - rsi

;  Returns:
;	average (in eax)


global	lstAverage
lstAverage:


mov rdx, rdi
mov rcx, rsi
mov eax, 0

GetAve:
		
		; -----
		; Move next value of array into eax
		
		mov r8d, dword [rdx]

		; -----
		; Keep a running sum of all the values
		
		add eax, r8d

		; -----
		; Increment pointer so it points to the next element in the array array.
		
		add rdx, 4

loop GetAve
; dec rcx
; cmp rcx, 0
; jne GetAve

cdq
idiv esi

ret


; --------------------------------------------------------
;  Function to calculate the kurtosis statisic.

; -----
;  Call:
;  kStat = lstKurtosis(list, len, ave)

;  Arguments Passed:
;	1) list, address - rdi
;	2) len, value - esi
;	3) ave, value - edx

;  Returns:
;	kurtosis statistic (in rax)


global lstKurtosis
lstKurtosis:

	;-----
	; Setup Stack Dynamic Locals
	push rbp
	mov rbp, rsp
	sub rsp, 32

	; -----
	; push maintained registers (rbx, r12, r13, r14, r15)
	push rbx

	; -----
	; Initialize SDLs

	mov qword [rbp - 16], 0 ; 4th power ans upper 64 bits = 0
	mov qword [rbp - 8], 0  ; 4th power ans lower 64 bits = 0

	mov qword [rbp - 32], 0 ; 2nd power ans upper 64 bits = 0
	mov qword [rbp - 24], 0 ; 2nd power ans lower 64 bits = 0

	; move ave out of rdx
	movsxd rbx, edx

	; set rcx to length
	mov rcx, 0

	; data prep
	;mov r9, 0
	;mov r10, 0

	; start sum loop
	SumLoop:

		; perform subtraction of ith element in x and average
		mov r8, 0
		movsxd r8, dword [rdi + rcx * 4]
		sub r8, rbx

		
		; raise to 4th power in a quad register
		mov rdx, 0
		mov rax, 0
		mov rax, r8
		imul r8

		; keep running sum of divisor in quad register
		add qword [rbp - 32], rdx	; upper 64
		add qword [rbp - 24], rax	; lower 64

		imul r8
		imul r8

		; keep running sum of dividend in a quad register
		add qword [rbp - 16], rdx 	; upper 64
		add qword [rbp - 8], rax 	; lower 64
		


	inc rcx
	cmp ecx, esi
	jl SumLoop

	; set rax = 0 in case the divisor is 0
	mov rax, 0

	; if divisor is == 0
	mov r10, qword [rbp - 24]
	cmp r10, 0
	je divisor0
		mov rax, qword [rbp - 8]
		mov rdx, qword [rbp - 16]
		idiv r10
	divisor0:

	; -----
	; pop used registers

	pop rbx
mov rsp, rbp
pop rbp
ret


; ********************************************************************************


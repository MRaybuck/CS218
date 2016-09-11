;	Matt Raybuck
;	Assignment 02
;	Section 002

; -----
;  A simply assembly language program to compute a few different formulas.


; *****************************************************************
;  Static Data Declarations (initialized)

section	.data

; -----
;  Define standard constants.

NULL		equ	0			; end of string

TRUE		equ	1
FALSE		equ	0

SUCCESS		equ	0			; Successful operation
SYS_exit	equ	60			; call code for terminate

; -----
;  Declare variables.

bVar1		db	59
bVar2		db	21
bAns1		db	0
bAns2		db	0
wVar1		dw	2681
wVar2		dw	1432
wAns1		dw	0
wAns2		dw	0
dVar1		dd	164641512
dVar2		dd	112356789
dVar3		dd	-46524
dAns1		dd	0
dAns2		dd	0
qVar1		dq	142455214619
flt1		dd	-19.125
flt2		dd	11.25
eVal		dd	2.71828
myClass	db	"CS 218", NULL
edName	db	"Ed Jorgensen", NULL
myName	db	"Matt Raybuck", NULL





; ----------------------------------------------
;  Uninitialized Static Data Declarations.

section	.bss

;	Place data declarations for uninitialized data here...
;	(i.e., large arrays that are not initialized)


; *****************************************************************

section	.text
global _start
_start:


; -----

mov al, byte [bVar1]
add al, byte [bVar2]
mov byte [bAns1], al

mov al, byte [bVar1]
sub al, byte [bVar2]
mov byte [bAns2], al

mov ax, word [wVar1]
add ax, word [wVar2]
mov word [wAns1], ax

mov ax, word [wVar1]
sub ax, word [wVar2]
mov word [wAns2], ax

mov eax, dword [dVar1]
add eax, dword [dVar2]
mov dword [dAns1], eax

mov eax, dword [dVar1]
sub eax, dword [dVar2]
mov dword [dAns2], eax


; *****************************************************************
;	Done, terminate program.

last:
	mov	eax, SYS_exit		; call call for exit (SYS_exit)
	mov	ebx, SUCCESS		; return code of 0 (no error)
	syscall


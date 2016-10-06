;  CS 218 - Assignment 8
;  Provided Main.

;  DO NOT EDIT THIS FILE

; --------------------------------------------------------------------
;  Write assembly language functions.

;  The function, combSort(), sorts the numbers into ascending
;  order (large to small).

;  The function, basicStats(), finds the minimum, median, maximum,
;  sum, and average for a list of numbers.

;  The function, intStdDeviation(), to computes the integer
;  standard deviation for a data sets.

;  The function, tStatistic(), to computes the
;  t-statistic for the two data sets.

; ----------

section	.data

; -----
;  Define standard constants.

TRUE		equ	1
FALSE		equ	0

SUCCESS		equ	0			; successful operation
NOSUCCESS	equ	0			; unsuccessful operation

STDIN		equ	0			; standard input
STDOUT		equ	1			; standard output
STDERR		equ	2			; standard error

SYS_read	equ	0			; call code for read
SYS_write	equ	1			; call code for write
SYS_open	equ	2			; call code for file open
SYS_close	equ	3			; call code for file close
SYS_fork	equ	57			; call code for fork
SYS_exit	equ	60			; call code for terminate
SYS_creat	equ	85			; call code for file open/create
SYS_time	equ	201			; call code for get time

LF		equ	10
NULL		equ	0
ESC		equ	27

; -----
;  Data Sets for Assignment #8.

list1		dd	 2746,  2785,  2641, -2417,  2660
		dd	-2853,  2897,  2259,  2375, -2220
		dd	 2968,  2454, -2120,  2123,  2233
		dd	 1851, -1231,  1542, -1146,  1460
		dd	 1195,  1351, -1197,  1195,  1120
		dd	-1196,  1105,  1200,  1730,  1871
		dd	 1187,  1121,  1872, -2287,  1567
		dd	 2411,  2562
len1		dd	37
estMed1		dd	0
med1		dd	0
sum1		dd	0
ave1		dd	0
min1		dd	0
max1		dd	0
kStat1		dd	0


list2		dd	 1123,  1122,  1549,  1236,  1163
		dd	 1110,  1123,  1191,  1312,  1307
		dd	 1111,  1124, -1384,  1159,  1548
		dd	-1117,  1132,  1175,  1138,  1139
		dd	 1121,  1232, -1261,  1126,  1104
		dd	 1114,  1141,  1155,  1654, -1167
		dd	-1113,  1141,  1144,  1236,  1126
		dd	 1113,  1431, -1435,  1286,  1675
		dd	 1113,  1342,  1422,  1146,  1154
		dd	 1142,  1114,  1124,  1167,  1566
		dd	 2612,  2651,  2131,  2211,  2132
		dd	 2611,  2634,  2725, -2416, -2321
		dd	 2611, -2621, -2733,  2747,  2821
		dd	 2613,  2131,  2957, -2521,  2122
		dd	 2621,  2623,  2311, -2155, -2311
		dd	 2611,  2621,  2641,  2859,  2721
		dd	-2113,  2141,  2144, -2236,  2126
		dd	 2645,  2661, -2123,  2947,  2621
		dd	 2631, -2621,  2547, -2431,  2251
		dd	 2664,  2671,  2819,  2145, -2321
		dd	 2661,  2621, -2219,  2467,  2221
		dd	 2113,  2431, -1435,  1286,  1085
len2		dd	110
estMed2		dd	0
med2		dd	0
sum2		dd	0
ave2		dd	0
min2		dd	0
max2		dd	0
kStat2		dd	0


list3		dd	 1452,  1564,  1562,  1236,  1254
		dd	 1634, -1236, -1562,  1269, -1412
		dd	 1253,  1445,  1566,  1247,  1883
		dd	-1253,  1224,  1562,  1214, -1298
		dd	 1275, -1342, -1562,  1489,  1362
		dd	 1386,  1222,  1583,  1256, -1229
		dd	 1386,  1432,  1562,  1223,  1315
		dd	 1686,  1143, -1116,  1112,  1112
		dd	-1386,  1143,  1152,  1145,  1184
		dd	 1977,  1154,  1136,  1187, -1129
		dd	 1177, -1154,  1153,  1123,  1115
		dd	 1135,  1115, -1107,  1112,  1114
		dd	 1235,  1165,  1651,  1145,  1103
		dd	 1553,  1176,  1165,  1891, -1156
		dd	-1435, -1176, -1154,  1168,  1162
		dd	 1665,  1176,  1134,  1123, -1144
		dd	 1864,  1138,  1132,  1147,  1134
		dd	 1786,  1187, -1121,  1169,  1172
		dd	-1668,  1981,  1123,  1179, -1185
		dd	 1466, -1156,  1135,  1177,  1164
		dd	 2186,  2862,  2175,  2156,  2026
		dd	 2286,  2297, -2764,  2533,  2437
		dd	-2789,  2349,  2578,  2344,  2349
		dd	 2259,  2376, -2180,  2223,  2459
		dd	 2414,  2448,  2586,  2523, -2669
		dd	-2324,  2488,  2134,  2338,  2121
		dd	 2346,  2344, -2544,  2689,  2746
		dd	 2146,  2466,  2223,  2716,  2519
		dd	 2253,  2475,  2436,  2161,  2679
		dd	 2325,  2275,  2412,  2532,  2361
		dd	 2536,  2456,  2113, -2412, -2112
		dd	-2353, -2164, -2134,  2123,  2184
		dd	 2138,  2641,  2145, -2109, -2115
		dd	-2125,  2114,  2451,  2189,  2114
		dd	 2154,  2145, -2147,  2117,  2103
		dd	 2534, -2146,  2163, -2187,  2156
		dd	 2445,  2164,  2174,  2176, -2162
		dd	 2656,  2145, -2134,  2156,  2144
		dd	-2855, -2146,  2178,  2145,  2134
		dd	 2763,  2641,  2154,  2341, -2172
		dd	 2686,  2143, -2116,  2112,  2112
		dd	-2386,  2143,  2152,  2145,  1766
len3		dd	210
estMed3		dd	0
med3		dd	0
sum3		dd	0
ave3		dd	0
min3		dd	0
max3		dd	0
kStat3		dd	0


; --------------------------------------------------------

extern	combSort, lstStats
extern	lstEstMedian, lstKurtosis

section	.text
global	main
main:

; **************************************************
;  Call functions for data set 1.

;  call combSort(list, len)
	mov	rdi, list1
	mov	esi, dword [len1]
	call	combSort

;  call lstEstMedian(list, len)
	mov	rdi, list1
	mov	esi, dword [len1]
	call	lstEstMedian
	mov	dword [estMed1], eax

;  call lstStats(list, len, sum, ave, min, max, med)
	mov	rdi, list1
	mov	esi, dword [len1]
	mov	rdx, sum1
	mov	rcx, ave1
	mov	r8, min1
	mov	r9, max1
	mov	rax, med1
	push	rax
	call	lstStats
	add	rsp, 8

;  kStat1 = intStdDeviation(list, len, ave)
	mov	rdi, list1
	mov	esi, dword [len1]
	mov	edx, dword [ave1]
	call	lstKurtosis
	mov	dword [kStat1], eax


; **************************************************
;  Call functions for data set 2.

;  call combSort(list, len)
	mov	rdi, list2
	mov	esi, dword [len2]
	call	combSort

;  call lstEstMedian(list, len)
	mov	rdi, list2
	mov	esi, dword [len2]
	call	lstEstMedian
	mov	dword [estMed2], eax

;  call lstStats(list, len, sum, ave, min, max, med)
	mov	rdi, list2
	mov	esi, dword [len2]
	mov	rdx, sum2
	mov	rcx, ave2
	mov	r8, min2
	mov	r9, max2
	mov	rax, med2
	push	rax
	call	lstStats
	add	rsp, 8

;  kStat1 = intStdDeviation(list, len, ave)
	mov	rdi, list2
	mov	esi, dword [len2]
	mov	edx, dword [ave2]
	call	lstKurtosis
	mov	dword [kStat2], eax

; **************************************************
;  Call functions for data set 3.

;  call combSort(list, len)
	mov	rdi, list3
	mov	esi, dword [len3]
	call	combSort

;  call lstEstMedian(list, len)
	mov	rdi, list3
	mov	esi, dword [len3]
	call	lstEstMedian
	mov	dword [estMed3], eax

;  call lstStats(list, len, sum, ave, min, max, med)
	mov	rdi, list3
	mov	esi, dword [len3]
	mov	rdx, sum3
	mov	rcx, ave3
	mov	r8, min3
	mov	r9, max3
	mov	rax, med3
	push	rax
	call	lstStats
	add	rsp, 8

;  kStat1 = intStdDeviation(list, len, ave)
	mov	rdi, list3
	mov	esi, dword [len3]
	mov	edx, dword [ave3]
	call	lstKurtosis
	mov	dword [kStat3], eax

; ******************************
;  Done, terminate program.

last:
	mov	rax, SYS_exit
	mov	rbx, SUCCESS
	syscall


* Scan a series of 32-bit signed numbers to find the largest

	AREA	MaxSHs, CODE
	ENTRY

Main
	LDR	R0, =Data2	;beginning of the table
	LDR	R2, Length2	;init loop count
	LDR	R1, =0x80000000	;init [R1] as the smallest (most negative) signed word
				;R1 saves the maximum
	CMP	R2, #0		;gone through the table?
	BEQ	Done		;table is gone through
Loop
	LDR	R3, [R0], #4	;load a word
				;also let [R0] point to the next number
	CMP	R3, R1
	BLE	NOTMAX		;[R3] <= [R1]
	MOV	R1, R3
NOTMAX
	SUBS	R2, R2, #1	;decrease loop count by 1
	BNE	Loop
Done
	STR	R1, Max		;store the maximum
	SWI	0x11


	AREA	Data1, DATA

Table	DCD	0xFFFFA152
	DCW	0x7F61
	ALIGN		;align each data in 4-byte boundary
	DCW	0xF123
	ALIGN
	DCD	0xFFFF8000
TEnd	DCD	0


	AREA	Data2, DATA

Table2	DCD	79, 100, -12, -312, 167, 23
TEnd2	DCD	0


	AREA	Data3, DATA

Length	DCD	(TEnd - Table)/4	;a loop counter
Length2	DCD	(TEnd2 - Table2)/4	;a loop counter
Max	DCD	0


	END
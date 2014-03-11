* Author: Weiying Zhu
* A NULL-terminated string is given at SrcStr
* Find the length of a NULL-terminated string and save it to StrLen
* Replace the leading zeros with blanks and save the new NULL-terminated 
* string to DstStr


NULL	EQU	0
Blank	EQU	' '
Zero	EQU	'0'


	AREA	StrLengthLeadingZeros,	CODE
	ENTRY

Main
	LDR	R0, =SrcStr	;R0 points to the first byte of SrcStr
	MOV	R1, #Zero	;[R1] = ASCII code of '0'
	MOV	R3, #Blank	;[R3] = ASCII code of ' '

	EOR	R4, R4, R4	;use R4 as a counter for string length
				;init [R2] as 0	
LoopLen				;a loop to find string length,
				;[R0] is NOT changed in this loop
	LDRB	R2, [R0, R4]	;load the current byte of SrcStr
	CMP	R2, #NULL	;is string terminated
	BEQ	DoneLen
	ADD	R4, R4, #1	;[R4]++
	B	LoopLen
DoneLen
	LDR	R5, =StrLen
	STR	R4, [R5]	;Store sting length to StrLen


	LDR	R6, =DstStr	;[R6] points to first byte in DstStr
LoopRpl				;a loop to replace leading '0' with ' '
				;[R0] & [R6] will be changed in this loop
	LDRB	R2, [R0], #1	;load [R2] the current byte of SrcStr
	CMP	R2, #NULL	;is string terminated?
	BEQ	DoneCpy
	CMP	R2, R1		;[R2] == '0'?
	BNE	DoneRpl		;not a leading '0' anymore
	STRB	R3, [R6], #1	;store ' ' to [[R6]]
	B	LoopRpl

DoneRpl				;done with replacing leading zeros
LoopCpy				;copy the rest of SrcStr to DstStr
	CMP	R2, #NULL	;is string terminated?
	BEQ	DoneCpy		;yes, src string is gone through
	STRB	R2, [R6], #1	;Store [R2] to [[R6]]
	LDRB	R2, [R0], #1	;load [R2] the current byte of SrcStr
	B	LoopCpy

DoneCpy				;done with copying the rest of SrcStr

	STRB	R2, [R6], #1	;[R2] = #NULL at this moment
		
	SWI	0x11

	AREA	Data1, DATA

SrcStr
	DCB	"0000000812500"
ssEnd	DCB	NULL
	ALIGN
DstStr
	% (ssEnd - SrcStr) + 1	;reserve zeroed memory for DstStr
	ALIGN
StrLen
	DCD	0
	ALIGN

	END

	
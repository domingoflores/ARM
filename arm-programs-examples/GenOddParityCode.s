* Add an odd parity bit to the end of a bit stream (source word)
*   Input: a NULL terminated ASCII string (source word) with 
*          first bit at SRC_MSB
*   Output: a NULL terminated ASCII string (parity code) with 
*          first bit at PCODE_MSB
*   Add an odd parity bit to the end of the source word as the LSB 
*       and place the resulting parity code at PCODE_MSB as a NULL 
*       terminated ASCII string
*   If the length of the source word is greater than MAX_LEN or 
*       the source word contains any character that is neither '0' 
*       nor '1', place "ERROR" at PCODE_MSB


MAX_LEN	EQU	80	;maximum length of source code
NULL	EQU	0

	AREA	GenOddParityCode,	CODE
	ENTRY

Main
		;registers used in main routine
		;  [R0] addr of current BIT char in source word
		;  [R1] addr of next available spot for a BIT char 
		;	in parity code
		;  [R2] counts the length of source word
		;  [R4] counts the number of 1's in source word
		;  [R3] load/store an ASCII byte from/to memory

	LDR	R0, =SRC_MSB	;[R0] <- addr of MSB in source word
	LDR	R1, =PCODE_MSB	;[R1] <- addr of MSB in parity code
	
	EOR	R2, R2, R2	;[R2] <- 0
	EOR	R4, R4, R4	;[R4] <- 0
	EOR	R3, R3, R3	;[R3] <- 0

Loop		;a loop to go through source word,
	LDRB	R3, [R0], #1	;load ASCII of current bit in src word
	CMP	R3, #NULL	;is string terminated
	BEQ	DoneCpy

	CMP	R3, #'1'	;is this bit '1'?
	BEQ	IsOne
	CMP	R3, #'0'	;is this bit '0'?
	BEQ	IsZero
	B	DoneError	;neither '1' nor '0'

IsOne	ADD	R4, R4, #1	;[R4]++
IsZero	ADD	R2, R2, #1	;[R2]++
	STRB	R3, [R1], #1	;store ASCII of current BIT to p code

	CMP	R2, #MAX_LEN	;is source word too long?
	BGT	DoneError	;too long!

	B	Loop

DoneError	;error! put "ERROR" as parity code
	LDR	R1, =PCODE_MSB	;[R1] <- addr of MSB in parity code
	MOV	R3, #'E'
	STRB	R3, [R1], #1
	MOV	R3, #'R'
	STRB	R3, [R1], #1
	MOV	R3, #'R'
	STRB	R3, [R1], #1
	MOV	R3, #'O'
	STRB	R3, [R1], #1
	MOV	R3, #'R'
	STRB	R3, [R1], #1
	MOV	R3, #NULL
	STRB	R3, [R1], #1
	B	Done

DoneCpy		;done with copying source word to parity code
		;attach the ASCII of parity bit to parity code
	TST	R4, #1	;even parity?
	BEQ	EvenP
	MOV	R3, #'0' ;odd parity already
	B	StrPBit
EvenP	MOV	R3, #'1' ;make it an odd parity
StrPBit	STRB	R3, [R1], #1

		;attach NULL to terminate parity code
	MOV	R3, #0 ;make it an odd parity
	STRB	R3, [R1], #1

Done
	SWI	0x11


	AREA	Data1, DATA

SRC_MSB	
	DCB	"1001000110111011"	;source word
	DCB	NULL
	ALIGN

PCODE_MSB
	% (MAX_LEN + 1)	;reserve zeroed memory for Parity Code
	ALIGN

	END

* Read a signed decimal number within the valid range of 
* 32-bit 2's complement, convert it into a 32-bit 2's complement, 
* and store it to memory
* the ascii of the sign or each digit is read one by one

	AREA	ReadDecString, CODE
	ENTRY

NULL	EQU	0
Mask	EQU	0x0000000F
CR	EQU	0x0D	;Ascii of Carriage Return
LF	EQU	0x0A	;Ascii of Line Feeder

Main
	
	MOV R1, #0	;clear result register
	SWI 4	;read the first ascii from keyboard to [R0]

	CMP R0, #'-'	;is it '-'?
	BNE NotMinusSign
	STRB R0, MinusSign	;store '-'
	SWI 4		;read the next ascii to [R0]

NotMinusSign
	CMP R0, #'0'	;is it lower then '0'
	BLO DoneReading	;not a valid digit
	CMP R0, #'9'	;is it higher then '9'
	BHI DoneReading	;not a valid digit

	SUB R2, R0, #'0' ;a valid digit saved to R2

			;Next, [R1]<--[R1]*10+digit
	ADD R1, R1, R1	;[R1]<--original [R1]*2
	MOV R3, R1, LSL #2 ;[R3]<--original [R1]*8
	ADD R1, R1, R3  ;[R1]<--original [R1]*10
	ADD R1, R1, R2	;[R1]<--original [R1]*10 + digit

	SWI 4		;read the next ascii to [R0]
	B NotMinusSign
	
DoneReading		;done with reading
	LDRB R4, MinusSign
	CMP R4, #'-'	;is it a negative number
	BNE Store2Memory	;not negative

	MVN R1, R1	;1's complement
	ADD R1, R1, #1	;2's complement

Store2Memory
	STR R1, SignedNumber	;store signed number

	SWI 0x11		;terminate program


	AREA	Data, DATA
SignedNumber
	DCD	0	;32-bit signed number
MinusSign
	DCB	0	;ascii code of '-' if negative
	ALIGN

	END

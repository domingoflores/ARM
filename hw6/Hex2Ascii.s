* Autor: Weiying Zhu
* Convert a 32-bit hexadecimal number to an ASCII string, 
* output to the terminal, and store the NULL-terminated 
* ASCII string to memory

	AREA	Hex2Ascii, CODE
	ENTRY

NULL	EQU	0
Mask	EQU	0x0000000F
CR	EQU	0x0D	;Ascii of Carriage Return
LF	EQU	0x0A	;Ascii of Line Feeder

Start
	LDR R1, Hex		;load hex number
	LDR R6, =HexStr		;load address
	MOV R4, #8		;init counter
	MOV R5, #28		;# of bits for LSR
Loop
	MOV R3, R1		;copy hex number
	MOV R3, R3, LSR R5	;LSR 
	SUB R5, R5, #4		;prepare for next LSR
	AND R3, R3, #Mask	;get one hex symbol
	CMP R3, #0xA		;is this symbol < 10
	BLT Add_0		;yes, <10
				;symbol 'A' ~ 'F'
	SUB R3, R3, #10		;symbol - 10
	ADD R3, R3, #'A'	;add ascii 'A'
	B Store
Add_0	ADD R3, R3, #'0'	;add ascii '0'
Store	
	STRB R3, [R6], #1	;store symbol's ascii
	MOV R0, R3		;
	SWI 0x0			;output [R0] as char
	SUBS R4, R4, #1		;counter--
	BNE Loop

	MOV R3, #NULL		
	STRB R3, [R6], #1	;store NULL

	MOV R0, #LF
	SWI 0x0			;output LF

	LDR R0, =HexStr
	SWI 0x2		;output null-terminated string

	SWI 0x11		;terminate program


	AREA	Data, DATA
Hex	DCD	0xAF2E3D4C	;hex number
HexStr	% 9			;ascii string of hex number
	ALIGN

	END



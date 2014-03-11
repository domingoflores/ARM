* Generate the even-parity Hamming code of a bit stream (source word)
*   Input: a NULL terminated ASCII string (source word) with 
*          first bit at SRC_MSB
*   Output: a NULL terminated ASCII string (hammin code) with 
*          first bit at HCODE_MSB
*   Generate the Hamming code of the given source word and 
*       place the resulting Hamming code at HCODE_MSB as a 
*       NULL terminated ASCII string
*         Parity Counts of Check Bits: A list of BYTEs in 
*         memory starting at PARITY_COUNTS, each of which 
*         counts the parity (total number of 1’s) of each 
*         check bit. E.g., [PARITY_COUNTS + i] counts the 
*         parity (total # of 1's) of check bit #(2^i) in the 
*         Hamming code, where i = 0, 1, 2, 3, ...
*   If the length of the source word is greater than MAX_LEN 
*       or the source word contains any character that is 
*       neither '0' nor '1', place "ERROR" at HCODE_MSB


MAX_LEN	EQU	80    ;max length of source word (>=3, <=0x1FFFFFFF)
NULL	EQU	0

	AREA	GenHammingCode,	CODE
	ENTRY

Main	;registers used in main routine
	;[R0]<-(SRC_MSB-1), (addr of MSB in source word - 1)
	;[R1]<-(HCODE_MSB-1), (addr of MSB in Hamming code - 1)
	;[R9]<-PARITY_COUNTS, addr of Parity Count for Check Bit#1 in H code
	;[R2] sequence # of a bit in source word
	;[R3] sequence # of a bit in Hamming code
	;[R4] sequence # of a check bit in Hamming code

	;[R5] load/store an ASCII byte from/to memory

	LDR	R0, =SRC_MSB	;[R0] <- addr of MSB in source word
	LDR	R1, =HCODE_MSB	;[R1] <- addr of MSB in Hamming code
	LDR	R9, =PARITY_COUNTS ;[R9]<-addr of Parity Count for check bit#1
	MOV	R2, #1	;bit #1 in source word
	MOV	R3, #1	;bit #1 in Hamming code
	MOV	R4, #1	;bit #1 in Hamming code (check bit # only)
	SUB	R0, R0, #1	;now [R0]+[R2] is addr of current bit
	SUB	R1, R1, #1	;now [R1]+[R3] is addr of current bit

	EOR	R5, R5, R5	;[R5] <- 0

Loop	CMP	R3, R4		;is bit #[R3] a check bit?
	BEQ	CheckBitSpot	;spot for a check bit in H code
	BGT	DoneError	;[R3] cannot be > [R4]

		;bit #[R3] in H code is a data bit
		;data bit #[R3] in H code <- bit #[R2] in source word
	LDRB	R5, [R0, R2]	;[R5]<-data bit from source word
	ADD	R2, R2, #1
	CMP	R5, #NULL	;is it a NULL
	BEQ	DoneDataBits	;has gone through the source word

	CMP	R2, #(MAX_LEN+1)	;is source word too long?
	BGT	DoneError	;source word is too long

	CMP	R5, #'1'	;is it a '1'
	BEQ	BitOne

	CMP	R5, #'0'	;is it a '0'
	BEQ	BitZero

	B	DoneError	;none of '1', '0', or NULL, error!

BitOne		;bit '1' to be stored as data bit #[R3] in H code
		;find all the 1's in [R3], update parities of relevant check bits
		;e.g., if [R3] is now 9 (i.e., 1001), bit #9 belongs to the 
		;parities of check bit #1 (i.e., 2^0) and check bit #8 (i.e., 2^3)
		;then, [PARITY_COUNTS + 1]++, [PARITY_COUNTS + 3]++
	MOV	R6, R3	;[R6]<-[R3]
	EOR	R7, R7, R7
	EOR	R8, R8, R8
LoopParity
	CMP	R7, #32
	BGE	BitZero
	MOVS	R6, R6, LSR #1	;[C-bit]<-[R3]'s bit #[R7]
	BCC	NoParityIncr
	LDRB	R8, [R9, R7]	;Incr Parity Counter for check bit #(2^[R7])
	ADD	R8, R8, #1	;by 1
	STRB	R8, [R9, R7]
NoParityIncr
	ADD	R7, R7, #1
	B	LoopParity

BitZero
	STRB	R5, [R1, R3]	;store data bit to H code
	ADD	R3, R3, #1
	B	Loop

CheckBitSpot	;a spot reserved for check bit
	ADD	R3, R3, #1	;skip this spot
	ADD	R4, R4, R4	;[R4]<-2*[R4] next check bit seq#
	B	Loop


DoneError	;error! put "ERROR" as Hamming code
	LDR	R1, =HCODE_MSB	;[R1] <- addr of MSB in Hamming code
	MOV	R5, #'E'
	STRB	R5, [R1], #1
	MOV	R5, #'R'
	STRB	R5, [R1], #1
	MOV	R5, #'R'
	STRB	R5, [R1], #1
	MOV	R5, #'O'
	STRB	R5, [R1], #1
	MOV	R5, #'R'
	STRB	R5, [R1], #1
	MOV	R5, #NULL
	STRB	R5, [R1], #1
	B	Done

DoneDataBits	;done with copying source word to Hamming code
		;insert check bits to Hamming code

		;attach NULL to terminate Hamming code
	MOV	R5, #NULL
	STRB	R5, [R1, R3]	;store NULL to bit #[R3] in H code
	SUB	R3, R3, #1	;H code has bits #1, #2, ... #[R3]

		;if [R3] == [R4], the last bit in H code is a check-bit
		;remove this redundant check-bit by 
		;placing a NULL at the spot for this bit and 
		;decreasing [R3] by 1
	CMP	R3, R4
	BNE	StoreCheckBits
	MOV	R5, #NULL
	STRB	R5, [R1, R3]	;store NULL to bit #[R3] in H code
	SUB	R3, R3, #1	;now, H code has bits #1, #2, ... #[R3]

StoreCheckBits
		;store check bits #1, #2, #4, ... to H code
		;check bit # is found using [R4] or [R7]: [R4]=2^[R7]
	EOR	R8, R8, R8	;used to load a byte from PARITY_COUNTS table
	EOR	R7, R7, R7	;start with check bit #(2^0), i.e.,
	MOV	R4, #1		;check bit #1
LoopCheckBit
	CMP	R4, R3
	BGE	Done		;done with loading all check bits!
	LDRB	R8, [R9, R7]	;load parity of check bit #2^[R7]
	TST	R8, #1		;is the parity even w/o check bit?
	BEQ	EvenParity
	MOV	R5, #'1'	;an odd parity w/o check bit
	B	LoadCheckBit
EvenParity
	MOV	R5, #'0'	;an even parity w/o check bit
LoadCheckBit
	STRB	R5, [R1, R4]	;store check bit #[R4] into H code
	ADD	R7, R7, #1	;[R7]++, next check bit #(2^[R7])
	ADD	R4, R4, R4	;[R4]<-[R4]*2, next check bit #[R4]
	B	LoopCheckBit
		
Done
	SWI	0x11



	AREA	Data1, DATA

SRC_MSB	
	DCB	"101111001"	;source word
	DCB	NULL
	ALIGN

HCODE_MSB
	% (2 * MAX_LEN + 1)	;reserve zeroed memory for Hamming Code
	ALIGN

PARITY_COUNTS
	% MAX_LEN	;reserve zeroed memory for parity counts for check bits

	END

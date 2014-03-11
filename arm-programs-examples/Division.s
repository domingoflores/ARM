* Divide a positive Dividend by a positive Divisor
*     all numbers are in 32-bit 2’s complement
* Save the Quotient and the Remainder to memory 
* Save 0xFFFFFFFF as the Quotient if
*     the Divisor is zero
*     or the Dividend or Divisor is negative
* Registers
*     [R1] <- initially Dividend, then Remainder
*     [R2] <- Divisor
*     [R3] <- Quotient


	AREA	Division, CODE
	ENTRY

Start
	LDR R0, =Dividend
	LDR R1, [R0]
	LDR R2, Divisor
	
	EOR R3, R3, R3		;[R3]<-0
	EOR R4, R4, R4		;[R3]<-0

	TST R1, #2, 2		;is divident negative?
	BNE DoneError		;yes

	TST R2, #2, 2		;is divisor negative?
	BNE DoneError		;yes

	CMP R2, #0		;is divisor Zero?
	BEQ DoneError		;yes

Loop	CMP R1, R2		;[R1]<-[R1]-[R2]
	BLT DoneDiv		;until [R1]<[R2]

	SUB R1, R1, R2
	ADD R3, R3, #1
	B Loop

DoneError
	LDR R3, =0xFFFFFFFF	;error!
	LDR R0, =Quotient
	STR R3, [R0]
	B Done

DoneDiv			;done with division
	LDR R0, =Quotient
	STR R3, [R0]
	LDR R0, =Remainder
	STR R1, [R0]

Done
	SWI 0x11		;terminate program


	AREA	Data, DATA
Dividend
	DCD	189		;input
Divisor
	DCD	21		;input
Quotient
	DCD	0		;output
Remainder
	DCD	0		;output

	ALIGN

	END



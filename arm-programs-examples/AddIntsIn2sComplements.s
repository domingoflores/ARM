*Inputs: a positive integer, a, and a negative integer, b
*    a list of bytes between A_MSD and A_LSD: the digits of a
*    a list of bytes between B_MSD and B_LSD: the digits of b
* Convert a and -b into their 2's complements and add them together
* Store the 2’s complements of (a - b) to RESULT

	AREA	AddIntsIn2sComplements, CODE
	ENTRY

Main
	LDR R0, =A_MSD	;[R0] the address A_MSD
	LDR R1, =A_LSD	;[R1] the address A_LSD
	BL Dec2Bin
	TST R2, #2, 2	;is [R2]'s MSB 0?
	BNE DONE		;[R2]'s MSB is 1!
	MOV R5, R2	;[R5]<--a's BIN

	LDR R0, =B_MSD	;[R0] the address B_MSD
	LDR R1, =B_LSD	;[R1] the address B_LSD
	BL Dec2Bin
	TST R2, #2, 2	;is [R2]'s MSB 0?
	BNE DONE		;[R2]'s MSB is 1!
	MVN R6, R2	;[R6]<--b's 1's complement
	ADD R6, R6, #1	;[R6]<--b's 2's complement

	ADD R7, R5, R6	;[R7]<--(a-b)'s 2's comp	
	LDR R8, =RESULT
	STR R7, [R8]	;store result's 2's comp

DONE	SWI 0x11		;terminate program


* subroutine converting positive dec to bin
*    range of dec: 0 ~ $7FFFFFFF
*  inputs: R0/R1 - address of MSD/LSD
*  [R0] will be increased into [R1]+1
*  outputs: R2 - binary pattern of dec
*    [R2] <-- 0xFFFFFFFF if an invalid dec
*  tmp registers used: R3, R4
Dec2Bin		
	MOV R2, #0	;clear result register

LOOP_Dec2Bin
	MOV R3, #0	;clear register taking a digit
	LDRB R3, [R0], #1;get MSD of dec
	CMP R3, #0	;is it lower then 0
	BLO InvalidDec	;not a valid digit
	CMP R3, #9	;is it higher then 9
	BHI InvalidDec	;not a valid digit

			;Next, [R2]<--[R2]*10+[R3]

	MOV R4, R2, LSL #1 ;[R4]<--original [R2]*2
	TST R4, #2, 2	;is [R4]'s MSB zero?
	BNE InvalidDec	;[R4]'s MSB is 1

	MOV R4, R4, LSL #1 ;[R4]<--original [R2]*4
	TST R4, #2, 2	;is [R4]'s MSB zero?
	BNE InvalidDec	;[R4]'s MSB is 1

	MOV R4, R4, LSL #1 ;[R4]<--original [R2]*8
	TST R4, #2, 2	;is [R4]'s MSB zero?
	BNE InvalidDec	;[R4]'s MSB is 1

	ADD R2, R2, R2	;[R2]<--original [R2]*2
	TST R2, #2, 2	;is [R2]'s MSB zero?
	BNE InvalidDec	;[R2]'s MSB is 1

	ADD R2, R2, R4  ;[R2]<--original [R2]*10
	TST R2, #2, 2	;is [R2]'s MSB zero?
	BNE InvalidDec	;[R2]'s MSB is 1

	ADD R2, R2, R3	;[R2]<--original [R2]*10 + [R3]
	TST R2, #2, 2	;is [R2]'s MSB zero?
	BNE InvalidDec	;[R2]'s MSB is 1

	CMP R0, R1
	BHI DONE_Dec2Bin ;LSD has been added
	B LOOP_Dec2Bin
	
InvalidDec	;a digit beyond 0-9 or out-of-range
	LDR R2, =0xFFFFFFFF

DONE_Dec2Bin
	MOV PC, LR	;return of Dec2Bin


	AREA	Data, DATA
A_MSD	DCB	4	;a's Most Significant Digit
	DCB	0
	DCB	5
	DCB	9
	DCB	2
A_LSD	DCB	5	;a's Least Significant Digit
	ALIGN
 
B_MSD	DCB	2	;a's Most Significant Digit
	DCB	9
	DCB	3
	DCB	0
	DCB	1
	DCB	7
	DCB	2
	DCB	4
	DCB	8
	DCB	5
	DCB	1
B_LSD	DCB	6	;a's Least Significant Digit
	ALIGN

RESULT
	DCD	0	;ascii code of '-' if negative
	

	END

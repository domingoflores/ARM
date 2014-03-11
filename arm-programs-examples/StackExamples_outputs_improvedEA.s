* Examples for Push/Pop data Onto/Outof the Stack
* Little Endian Format
* R13: SP
* R14: LR

	AREA	StackExamples, CODE
	ENTRY

Main
	
	LDR R1, Value1
	LDR R4, Value2
	LDR R5, Value3
	LDR R8, Value4

	LDR SP, =StackEA	;use an empty-ascending stack
	STMEA SP!, {R4-R5, R1, R8}	;PUSH parameters onto stack
		;input: R1, R4, R5, R8; output: R9, R10
		;higher numbered registers are used for output
	ADD SP, SP, #8
	BL SubrEA	;call subroutine using an empty-ascending stack
	LDMEA SP!, {R9, R10}	;POP output parameters out of stack
	SUB SP, SP, #16	;clear input parameters out of the stack, 4*4 = 16

	MOV R9, #0xFF	;modify [R9] and [R10] for testing the next block
	MOV R10, #0xFF	;not necessary in your application

	LDR SP, =StackFA	;use a full-ascending stack
	STMFA SP!, {R4-R5, R1, R8-R10}	;PUSH parameters onto stack
		;input: R1, R4, R5, R8; output: R9, R10
		;higher numbered registers are used for output
	BL SubrFA	;call subroutine using a full-ascending stack
	LDMFA SP!, {R9, R10}	;POP output parameters out of stack
	SUB SP, SP, #16	;clear input parameters out of the stack, 4*4 = 16

	MOV R9, #0xFF	;modify [R9] and [R10] for testing the next block
	MOV R10, #0xFF	;not necessary in your application

	LDR SP, =StackED	;use an empty-descending stack
	STMED SP!, {R4-R5, R1, R8-R10}	;PUSH parameters onto stack
		;input: R1, R4, R5, R8; output: R9, R10
		;higher numbered registers are used for output
	BL SubrED	;call subroutine using an empty-descending stack
	ADD SP, SP, #16	;clear input parameters out of the stack, 4*4 = 16
	LDMED SP!, {R9, R10}	;POP output parameters out of stack

	MOV R9, #0xFF	;modify [R9] and [R10] for testing the next block
	MOV R10, #0xFF	;not necessary in your application

	LDR SP, =StackFD	;use a full-descending stack
	STMFD SP!, {R4-R5, R1, R8-R10}	;PUSH parameters onto stack
		;input: R1, R4, R5, R8; output: R9, R10
		;higher numbered registers are used for output
	BL SubrFD	;call subroutine using a full-descending stack
	ADD SP, SP, #16	;clear input parameters out of the stack, 4*4 = 16
	LDMFD SP!, {R9, R10}	;POP output parameters out of stack

	SWI 0x11		;terminate program


SubrEA		;subroutine using an Empty-Ascending stack
		;4 inputs, 2 outputs, higher numbered registers used for outputs
		;this subroutine is register-independent
		;i.e., all the registers used in the subroutine except for R13
		;will be backed up at the beginning of the subroutine and 
		;restored at the end of the subroutine
		;input: R1, R2, R3, R4, output: R6, R7
		;internal stack pointer for input/output parameters: R5
	STMEA SP!, {R1-R7, LR}	;backup the contents of registers including LR
		;to be used in the subroutine
	SUB R5, SP, #40	;find the original [SP] before backup:4*8=32
	LDMEA R5!, {R1-R4}    ;POP input and output parameters outof stack
*	...		;using the parameters in the subroutine
*	...		;[R5] should NOT be changed/used for other purpose
	MOV R6, #0x11	;output 1
	MOV R7, #0x22	;output 2
	ADD R5, R5, #16
	STMEA R5!, {R6-R7}	;PUSH output parameters onto stack
			;[R1]~[R4] may have been changed, but it does not matter
	LDMEA SP!, {R1-R7, LR}	;POP the backed-up contents of registers 
		;used in the subroutine and LR
	MOV PC, LR
*	LDMEA SP!, {R1-R7, PC}	;merging the above two instructions 
		;into one for higher efficiency


SubrFA		;subroutine using a Full-Ascending stack
		;4 inputs, 2 outputs, higher numbered registers used for outputs
		;this subroutine is register-independent
		;i.e., all the registers used in the subroutine except for R13/SP
		;will be backed up at the beginning of the subroutine and 
		;restored at the end of the subroutine
		;input: R1, R2, R3, R4, output: R6, R7
		;internal stack pointer for input/output parameters: R5
	STMFA SP!, {R1-R7, LR}	;backup the contents of registers including LR
		;to be used in the subroutine
	SUB R5, SP, #32	;find the original [SP] before backup:4*8=32
	LDMFA R5!, {R1-R4, R6-R7}	;POP input/output parameters outof stack
*	...		;using the parameters in the subroutine
*	...		;[R5] should NOT be changed/used for other purpose
	MOV R6, #0x11	;output 1
	MOV R7, #0x22	;output 2
	STMFA R5!, {R1-R4, R6-R7}	;PUSH input/output parameters onto stack
			;[R1]~[R4] may have been changed, but it does not matter
	LDMFA SP!, {R1-R7, LR}	;POP the backed-up contents of registers 
		;used in the subroutine and LR
	MOV PC, LR
*	LDMFA SP!, {R1-R7, PC}	;merging the above two instructions 
		;into one for higher efficiency


SubrED		;subroutine using an Empty-Descending stack
		;4 inputs, 2 outputs, higher numbered registers used for outputs
		;this subroutine is register-independent
		;i.e., all the registers used in the subroutine except for R13
		;will be backed up at the beginning of the subroutine and 
		;restored at the end of the subroutine
		;input: R1, R2, R3, R4, output: R6, R7
		;internal stack pointer for input/output parameters: R5
	STMED SP!, {R1-R7, LR}	;backup the contents of registers including LR
		;to be used in the subroutine
	ADD R5, SP, #32	;find the original [SP] before backup:4*8=32
	LDMED R5!, {R1-R4, R6-R7}	;POP input/output parameters outof stack
*	...		;using the parameters in the subroutine
*	...		;[R5] should NOT be changed/used for other purpose
	MOV R6, #0x11	;output 1
	MOV R7, #0x22	;output 2
	STMED R5!, {R1-R4, R6-R7}	;PUSH input/output parameters onto stack
			;[R1]~[R4] may have been changed, but it does not matter
	LDMED SP!, {R1-R7, LR}	;POP the backed-up contents of registers 
		;used in the subroutine and LR
	MOV PC, LR
*	LDMED SP!, {R1-R7, PC}	;merging the above two instructions 
		;into one for higher efficiency		


SubrFD		;subroutine using a Full-Descending stack
		;4 inputs, 2 outputs, higher numbered registers used for outputs
		;this subroutine is register-independent
		;i.e., all the registers used in the subroutine except for R13
		;will be backed up at the beginning of the subroutine and 
		;restored at the end of the subroutine
		;input: R1, R2, R3, R4, output: R6, R7
		;internal stack pointer for input/output parameters: R5
	STMFD SP!, {R1-R7, LR}	;backup the contents of registers including LR
		;to be used in the subroutine
	ADD R5, SP, #32	;find the original [SP] before backup:4*8=32
	LDMFD R5!, {R1-R4, R6-R7}	;POP input/output parameters outof stack
*	...		;using the parameters in the subroutine
*	...		;[R5] should NOT be changed/used for other purpose
	MOV R6, #0x11	;output 1
	MOV R7, #0x22	;output 2
	STMFD R5!, {R1-R4, R6-R7}	;PUSH input/output parameters onto stack
			;[R1]~[R4] may have been changed, but it does not matter
	LDMFD SP!, {R1-R7, LR}	;POP the backed-up contents of registers 
		;used in the subroutine and LR
	MOV PC, LR
*	LDMFD SP!, {R1-R7, PC}	;merging the above two instructions 
		;into one for higher efficiency


	AREA	Data1, DATA
Value1	DCD	0xAAAA
Value2	DCD	0xBBBB
Value3	DCD	0xCCCC
Value4	DCD	0xDDDD
	ALIGN

	AREA	Data2, DATA
StackEA
	%	80	;a 80-byte empty-ascending stack
	ALIGN

	AREA	Data3, DATA
StackFA DCD	0	;the word before (NOT part of) the stack
	%	80	;a 80-byte full-ascending stack

	AREA	Data4, DATA
	%	76	;a 80-byte empty-decending stack
StackED	DCD	0	;the bottom byte on (part of) the stack
	ALIGN

	AREA	Data5, DATA
	%	80	;a 80-byte full-ascending stack
StackFD	DCD	0	;the word after (NOT part of) the stack


	ALIGN
	END

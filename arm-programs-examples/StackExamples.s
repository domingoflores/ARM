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
	LDR R10, Value4

	LDR SP, =StackEA	;use an empty-ascending stack
	STMEA SP!, {R4-R5, R1, R10}	;PUSH parameters onto stack
	BL SubrEA	;call subroutine using an empty-ascending stack
	SUB SP, SP, #16	;clear parameters out of the stack, 4*4 = 16

	LDR SP, =StackFA	;use a full-ascending stack
	STMFA SP!, {R4-R5, R1, R10}	;PUSH parameters onto stack
	BL SubrFA	;call subroutine using a full-ascending stack
	SUB SP, SP, #16	;clear parameters out of the stack, 4*4 = 16

	LDR SP, =StackED	;use an empty-decending stack
	STMED SP!, {R4-R5, R1, R10}	;PUSH parameters onto stack
	BL SubrED	;call subroutine using an empty-decending stack
	ADD SP, SP, #16	;clear parameters out of the stack, 4*4 = 16

	LDR SP, =StackFD	;use a full-decending stack
	STMFD SP!, {R4-R5, R1, R10}	;PUSH parameters onto stack
	BL SubrFD	;call subroutine using a full-decending stack
	ADD SP, SP, #16	;clear parameters out of the stack, 4*4 = 16

	SWI 0x11		;terminate program

SubrEA		;subroutine using an Empty-Ascending stack
		;this subroutine is register-independent
		;i.e., all the registers used in the subroutine except for R13
		;will be backed up at the beginning of the subroutine and 
		;restored at the end of the subroutine
	STMEA SP!, {R1-R5, LR}	;backup the contents of registers 
		;to be used in the subroutine and LR
	SUB R5, SP, #24	;find the original [SP] before backup:4*6=24
	LDMEA R5!, {R1-R4}	;POP four parameters outof stack
*	LDMEA R5, {R1-R4}	;POP w/o changing [R5]
*	...		;using the parameters in the subroutine
	LDMEA SP!, {R1-R5, LR}	;POP the backed-up contents of registers 
		;used in the subroutine and LR
	MOV PC, LR
*	LDMEA SP!, {R1-R5, PC}	;merging the above two instructions 
		;into one for higher efficiency


SubrFA		;subroutine using an Full-Ascending stack
		;this subroutine is register-independent
		;i.e., all the registers used in the subroutine except for R13
		;will be backed up at the beginning of the subroutine and 
		;restored at the end of the subroutine
	STMFA SP!, {R1-R5, LR}	;backup the contents of registers 
		;to be used in the subroutine and LR
	SUB R5, SP, #24	;find the original [SP] before backup:4*6=24
	LDMFA R5!, {R1-R4}	;POP four parameters outof stack
*	LDMFA R5, {R1-R4}	;POP w/o changing [R5]
*	...		;using the parameters in the subroutine
	LDMFA SP!, {R1-R5, LR}	;POP the backed-up contents of registers 
		;used in the subroutine and LR
	MOV PC, LR
*	LDMFA SP!, {R1-R5, PC}	;merging the above two instructions 
		;into one for higher efficiency


SubrED		;subroutine using an Empty-decending stack
		;this subroutine is register-independent
		;i.e., all the registers used in the subroutine except for R13
		;will be backed up at the beginning of the subroutine and 
		;restored at the end of the subroutine
	STMED SP!, {R1-R5, LR}	;backup the contents of registers 
		;to be used in the subroutine and LR
	ADD R5, SP, #24	;find the original [SP] before backup:4*6=24
	LDMED R5!, {R1-R4}	;POP four parameters outof stack
*	LDMED R5, {R1-R4}	;POP w/o changing [R5]
*	...		;using the parameters in the subroutine
	LDMED SP!, {R1-R5, LR}	;POP the backed-up contents of registers 
		;used in the subroutine and LR
	MOV PC, LR
*	LDMED SP!, {R1-R5, PC}	;merging the above two instructions 
		;into one for higher efficiency		


SubrFD		;subroutine using a full-decending stack
		;this subroutine is register-independent
		;i.e., all the registers used in the subroutine except for R13
		;will be backed up at the beginning of the subroutine and 
		;restored at the end of the subroutine
	STMFD SP!, {R1-R5, LR}	;backup the contents of registers 
		;to be used in the subroutine and LR
	ADD R5, SP, #24	;find the original [SP] before backup:4*6=24
	LDMFD R5!, {R1-R4}	;POP four parameters outof stack
*	LDMFD R5, {R1-R4}	;POP w/o changing [R5]
*	...		;using the parameters in the subroutine
	LDMFD SP!, {R1-R5, LR}	;POP the backed-up contents of registers 
		;used in the subroutine and LR
	MOV PC, LR
*	LDMFD SP!, {R1-R5, PC}	;merging the above two instructions 
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

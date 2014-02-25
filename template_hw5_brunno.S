	;Homework5, CS2400	

	AREA hw5, CODE 				
	
	AREA 	Example, CODE, READONLY	; name this block of code
	ENTRY							; mark first instruction
									; to execute
start
x	LDR		r0,=0x13579BDF;				; Set X	
y	LDR		r1,=0x12000000;				; Set Y
	BL		calculate				; Call subroutine
	SWI		0x11					; terminate
	LTORG
calculate							; calculate				
sum	MOV		r2,r1					; Puts r1 into r5 sum	
i	MOV		r4,#0					; Stores 0 to r5 i
Loop	CMP		r4,#3
	BGE		CalcEnd
	ADD		r2,r2,r1
	ADD		r4,r4,#1
	BAL		Loop
CalcEnd	MOV		pc,lr
									
city	DCB		"Greenwood Village", 0
	ALIGN
sales	DCD		28,39,34,26,50	
	ALIGN	
fifoQueue % 		5000
	END							; mark end of file

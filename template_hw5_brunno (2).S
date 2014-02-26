	;Homework5, CS2400, BRUNNO	

	AREA hw5, CODE 					; name of code block
	ENTRY						; first instructions
							; execute
start
x	LDR		R0, =0x13579BDF;			; variable x	
y	LDR		R1, =0x12000000;			; variable y
	BL		CALCULATE			; subroutine
	SWI		0x11				; terminate
	LTORG						
CALCULATE						; compute				
SUM	MOV		R2,r1				; R1 into R5 sum	
	MOV		R4,#0				; R4 = 0
WHILE	CMP		R4,#3
	BGE		FINISH
	ADD		R2,R2,R1
	ADD		R4,R4,#1
	BAL		WHILE
FINISH	MOV		PC,LR				; mark end of file

CITY	DCB		"Greenwood Village", 0		; null end of string
	ALIGN
SALES	DCD		28,39,34,26,50	
	ALIGN	
fifoQueue % 		5000
	END
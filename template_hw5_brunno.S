	;Homework5, CS2400, BRUNNO	

	AREA hw5, CODE 						; name of code block
	ENTRY							; first instructions
								; execute
start
x	LDR		R0,=0x13579BDF;				; variable x	
y	LDR		R1,=0x12000000;				; variable y
	BL		CALCULATE				; subroutine
	SWI		0x11					; terminate
	LTORG
CALCULATE							; compute				
SUM	MOV		R2,r1					; R1 into R5 sum	
i	MOV		R4,#0					; R4 = 0
LOOP	CMP		R4,#3
	BGE		FINISH
	ADD		R2,R2,R1
	ADD		R4,R4,#1
	BAL		LOOP
FINISH	MOV		PC,LR
									
CITY	DCB		"Greenwood Village", 0			; null end of string
	ALIGN
SALES	DCD		28,39,34,26,50	
	ALIGN	
fifoQueue % 		5000
	END							; mark end of file

	;Homework5, CS2400	

	AREA hw5, CODE 				
	
city	DCD 	"Greenwood Village"
sales	DCB	28, 39, 34, 46, 50
SWI_13	
;allocate 5000 bytes for fifoQueue
x	DCD	&13579BDF
y	DCD	&12000000

	ENTRY
start
	ADR		r0, city				; set up parameters
	ADR		r1, sales
	ADR 		r3, 
	BL		firstfunc				; call subroutine
	SWI		0x11					; terminate

; @arg r0 is the first number
; @arg r1 is the second number.
firstfunc
	MOV		r6, r0					; sum is r6, r6=r0
	MOV		r7, #0					; r7 is the "i". r7 = 0
BEGIN_WHILE
	CMP 		r7, #3					; how does r7 compare to #3?
	BGE 		END_WHILE				; end while when r7 is greater/equal r3
	ADD 		r6, r6, r1				; sum = sum + n2
	ADD 		r7, r7, #1				; i++
	B BEGIN_WHILE
END_WHILE
	MOV		pc, lr					; return

	ALIGN
	END							; mark end of file

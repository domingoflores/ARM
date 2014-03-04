AREA, AddHEXIn2Complements, CODE

A_MSD	DCB 0x1, 0x2, 0x3
B_MSD
A_LSD	DCB	0x5, 0x7, 0xB	
B_LSD
RESULT %		100
; Outline:
; Read each symbol from A and B, respectively
; Convert a into -a in 2's complement 
		ENTRY
        
        ADR     R0, A_MSD       ; Load the Address of A_MSD.        
        ADR     R1, B_MSD       ; Load the address of B_MSD.
        LDRB    R2, [R0], #1        ; Load into R0 the current byte.
                                    ; #1 increments R0 after loading
        LDRB    R3, [R1], #1        ; Load into R1 the current byte. 
        BL HEXBIN
        TST R3, #2,2                ; test the most significant bit in that register
        LSL R3, #4
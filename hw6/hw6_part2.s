        ; Author: Josh Gillham
        ; Name: h26_part2.s
        ; Description: This program attempts to solve hw6 part2.
        ;


        
        AREA	HW6_PART2, CODE
SWI_Exit	EQU	    &11	            ; Software interrupt will exit the program
StrOne      DCB     "This is a string.", &0
StrTwo      DCB     "Could this be a string too?", &0
MAX_LEN     EQU     169
MixStr      %       170
        ALIGN
; Main:
        ENTRY
        
        ADR     R0, StrOne               ; Load the address of A_MSD.
        ADR     R1, StrTwo               ; Load the address of B_MSD.
        ADR     R8, MixStr               ; Load the address of the end of A_MSD.
        LDRB    R2, [R0], #1
        LDRB    R3, [R1], #1
BEGIN_LOOP
        ADD     R4, R2, R3
        CMP     R4, #0
        BEQ     END_LOOP

        CMP     R2, #0
        BEQ     NEXT
        STRB    R2, [R8], #1            ; Stores the result into RESULT
        LDRB    R2, [R0], #1
NEXT
        CMP     R3, #0
        BEQ     NEXT2
        STRB    R3, [R8], #1            ; Stores the result into RESULT
        LDRB    R3, [R1], #1
NEXT2
        B   BEGIN_LOOP                  ; Go back to the beginning of the loop.
        
END_LOOP
        
        SWI	SWI_Exit				    ; Exit the program
        END



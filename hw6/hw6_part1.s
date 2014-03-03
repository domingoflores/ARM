        ; Author: Josh Gillham
        ; Name: h26_part1.s
        ; Description: This program attempts to solve hw6 part1.
        ;

        AREA	HW6_PART1, CODE
SWI_Exit	EQU	    &11	            ; Software interupt will exit the program
A_MSD       DCB     0x1, 0x2, 0x3
B_MSD
A_LSD       DCB     0x5, 0x7, 0xB
B_LSD
RESULT      %       100
        ALIGN
; Main:
;   Performs operations according the requirements set forth in hw6 part 1.
;
; Outline:
; . Read each symbol from A and B, respectively.
; . Test if A is a negative number.
; . If A is a negative number then
;   a. Subtract 1 from A.
;   b. Flip every bit.
; . If A is a positive number then
;   a. Flip every bit.
;   b. Add 1 to A.
; . Add A and B.
; . Store the result into RESULT.
;
        ENTRY
        
        ADR     R0, A_MSD               ; Load the address of A_MSD.
        ADR     R1, A_LSD               ; Load the address of B_MSD.
        ADR     R8, B_MSD               ; Load the address of the end of A_MSD.
        ADR     R9, RESULT              ; Load the address to store the result.
BEGIN_LOOP
        CMP     R0, R8                  ; Test for the end of the data.
        BGE     END_LOOP                ; Exit the loop on the end of the data.
        
        LDRB    R2, [R0], #1            ; Load into r2 the current 'a' byte.
                                        ; The #1 increments r0 after loading.
        LDRB    R3, [R1], #1            ; Load into r3 the current 'b' byte.
                                        ; The #1 increments r0 after loading.
        
        TST     R2, #2, 2               ; Test if r2 is negative.
; Which flag should be used?
        BGE     POSITIVE_SWITCH_SIGN    ; Skip conversion for positive numbers.
; Proceeds to NEGATIVE_SWITCH_SIGN.

; For negative numbers, switches the sign in 2's compliment.
NEGATIVE_SWITCH_SIGN                
        SUB     R2, R2, #1              ; Subtract 1 from R3.
        MOV     R7, #&FFFFFFFF
        EOR     R2, R2, R7              ; Flip every bit.
        B       RESULT_SUM              ; Skip the other sign flip.

; For positive numbers, switches the sign in 2's compliment.
POSITIVE_SWITCH_SIGN
        MOV     R7, #&FFFFFFFF
        EOR     R2, R2, R7              ; Flip every bit.
        ADD     R2, R2, #1              ; Add 1 to R3.

; Add A + B and store the result.
RESULT_SUM
        ADD     R4, R2, R3              ; Add the (-a) + b.

        STRB    R4, [R9], #1            ; Stores the result into RESULT
        
        B   BEGIN_LOOP                  ; Go back to the beginning of the loop.
        
END_LOOP
        
        SWI	SWI_Exit				    ; Exit the program
        END



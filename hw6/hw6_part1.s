        ; Author: Josh Gillham
        ; Name: h26_part1.s
        ; Description: This program attempts to solve hw6 part1.
        ;

; Qs
; Will there be any bytes in the array A_MSD that are treated as negative?
;  For example, let a byte from A_MSD be a number that is greater than 8.
;   In 2's compliment then for example , 8_2 = -1_Dec, 9_2 = -2_Dec.
;
; Should each member of A_MSD be treated individually?
;  That is, should I carry to the next member if there is an overflow.
;
; Why do directions say convert b into 32-bit 2's compliment?
;  B/c positive numbers are all the same.
; Does "If any symbol of a or b is outside the range of 0 to 15, set 0x00000000
;  as the value of  the word labeled as RESULT in memory." mean set ENTIRE
;  result to 0.


        
        AREA	HW6_PART1, CODE
SWI_Exit	EQU	    &11	            ; Software interrupt will exit the program
A_MSD       DCB     0x1, 0x2, 0x3,0xC   ; Arbitrary numbers
B_MSD
A_LSD       DCB     0x5, 0x7, 0xB, 0x7   ; Arbitrary numbers
B_LSD
RESULT      %       100             ; Arbitrary 
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
                                        ; Advance the address of R0 by 1 byte.
        LDRB    R3, [R1], #1            ; Load into r3 the current 'b' byte.
                                        ; Advance the address of R1 by 1 byte.
        
        TST     R2, #&80          ; Test if r2 is negative.
        BEQ     POSITIVE_SWITCH_SIGN    ; Skip conversion for positive numbers.

; For negative numbers, switches the sign in 2's compliment.
NEGATIVE_SWITCH_SIGN                
        SUB     R2, R2, #1              ; Subtract 1 from R3.
        MOV     R7, #&000000FF
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



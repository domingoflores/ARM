AREA	AddIntsIn2sComplements, CODE
A_MSD   DCB     0x1, 0x2, 0x3
B_MSD
A_LSD   DCB     0x5, 0x7, 0xB
B_LSD
RESULT  %       100
; Outline:
; . Read each symbol from A and B, respectively.
; . Convert a into -a in 2's compliment.
        ENTRY
        
        ADR     R0, A_MSD           ; Load the address of A_MSD.
        ADR     R1, B_MSD           ; Load the address fo B_MSD.
BEGIN   LDRB    R2, [R0], #1        ; Load into r0 the current a byte.
                                    ; The #1 increments r0 after loading.
        LDRB    R3, [R1], #1        ; Load into r1 the current b byte.
                                    ; The #1 increments r0 after loading.
        
        



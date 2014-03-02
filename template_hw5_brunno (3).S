    ; Author:       BRUNNO    
    ; Assignment:   Homework5
    ; Class:        CS2400 
    ; Professor:    Weiying Zhu
    ;

    AREA hw5, CODE                      ; name of code block
    ENTRY                               ; first instructions
                                        ; execute
start
x   LDR         R0, =0x13579BDF         ; variable x    
y   LDR         R1, =0x12000000         ; variable y
    BL          CALCULATE               ; subroutine
    SWI         0x11                    ; terminate
    LTORG

CALCULATE                               ; compute                
SUM
    MOV         R3,R0                   ; R1 into R5 sum    
COUNTER
    MOV         R4,#0                   ; R4 = 0
WHILE
    CMP         R4,#3
    BGE         FINISH
    ADD         R3,R3,R1
    ADD         R4,R4,#1
    B           WHILE
FINISH
    MOV         PC,LR                   ; mark end of file

    
CITY    DCB        "Greenwood Village", 0
                                        ; null terminated string
SALES    DCD        28,39,34,26,50    
fifoQueue %         5000
    END
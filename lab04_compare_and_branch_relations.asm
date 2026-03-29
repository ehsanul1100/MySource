.MODEL SMALL
.STACK 100H

.DATA
    MSG1 DB 'LAB 4: ENTER A: $'
    MSG2 DB 0DH,0AH,'ENTER B: $'
    GTM  DB 0DH,0AH,'RESULT: A > B $'
    LTM  DB 0DH,0AH,'RESULT: A < B $'
    EQM  DB 0DH,0AH,'RESULT: A = B $'

.CODE

PRINT MACRO P                ;macro: print $-string
    MOV AH,9                 ;DOS: print string
    LEA DX,P                 ;DX = address
    INT 21H                  ;call DOS
ENDM

MAIN PROC                    ;program start
    MOV AX,@DATA             ;load data seg
    MOV DS,AX                ;init DS

    PRINT MSG1               ;prompt A
    MOV AH,1                 ;read char
    INT 21H                  ;AL = A
    MOV BL,AL                ;BL = A

    PRINT MSG2               ;prompt B
    MOV AH,1                 ;read char
    INT 21H                  ;AL = B
    MOV CL,AL                ;CL = B

    CMP BL,CL                ;compare A with B
    JA  A_GREATER            ;if A > B
    JB  A_LESS               ;if A < B

    PRINT EQM                ;equal case
    JMP DONE                 ;go end

A_GREATER:                   ;A bigger
    PRINT GTM                ;print A > B
    JMP DONE                 ;go end

A_LESS:                      ;A smaller
    PRINT LTM                ;print A < B

DONE:                        ;finish
    MOV AH,4CH               ;DOS: exit
    INT 21H                  ;terminate
MAIN ENDP                    ;end main

END MAIN                     ;end program

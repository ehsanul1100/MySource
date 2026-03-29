.MODEL SMALL
.STACK 100H

.DATA
    MSG1 DB 'LAB 2: ENTER A DIGIT (0-9): $'
    MSGE DB 0DH,0AH,'YOU ENTERED 5 $'
    MSGN DB 0DH,0AH,'YOU DID NOT ENTER 5 $'

.CODE

PRINT MACRO P                ;macro: print $-string
    MOV AH,9                 ;DOS: print string
    LEA DX,P                 ;DX = address
    INT 21H                  ;call DOS
ENDM

MAIN PROC                    ;program start
    MOV AX,@DATA             ;load data seg
    MOV DS,AX                ;init DS

    PRINT MSG1               ;prompt user

    MOV AH,1                 ;DOS: read char
    INT 21H                  ;AL = key

    JMP CHECK                ;unconditional jump

SKIPPED_BLOCK:               ;this block is skipped
    MOV BL,AL                ;(never runs)

CHECK:                       ;compare input
    CMP AL,'5'               ;is it '5'?
    JE IS_FIVE               ;if yes jump

    PRINT MSGN               ;not 5 message
    JMP DONE                 ;jump to end

IS_FIVE:                     ;equal case
    PRINT MSGE               ;is 5 message

DONE:                        ;finish
    MOV AH,4CH               ;DOS: exit
    INT 21H                  ;terminate
MAIN ENDP                    ;end main

END MAIN                     ;end program

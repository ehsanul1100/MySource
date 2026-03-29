.MODEL SMALL
.STACK 100H

.DATA
    MSG1 DB 'LAB 5: ENTER A DIGIT (0-9): $'
    INM  DB 0DH,0AH,'IN RANGE (3..7) $'
    OUTM DB 0DH,0AH,'OUT OF RANGE $'

.CODE

PRINT MACRO P                ;macro: print $-string
    MOV AH,9                 ;DOS: print string
    LEA DX,P                 ;DX = address
    INT 21H                  ;call DOS
ENDM

MAIN PROC                    ;program start
    MOV AX,@DATA             ;load data seg
    MOV DS,AX                ;init DS

    PRINT MSG1               ;prompt digit
    MOV AH,1                 ;read char
    INT 21H                  ;AL = digit

    CMP AL,'3'               ;AL < '3' ?
    JB  OUT_RANGE            ;if below, out

    CMP AL,'7'               ;AL > '7' ?
    JA  OUT_RANGE            ;if above, out

    PRINT INM                ;inside range
    JMP DONE                 ;finish

OUT_RANGE:                   ;outside range
    PRINT OUTM               ;print out msg

DONE:                        ;exit
    MOV AH,4CH               ;DOS: exit
    INT 21H                  ;terminate
MAIN ENDP                    ;end main

END MAIN                     ;end program

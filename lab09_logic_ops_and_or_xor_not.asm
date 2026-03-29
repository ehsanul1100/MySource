.MODEL SMALL
.STACK 100H

.DATA
    MSG1 DB 'LAB 9: ENTER A DIGIT (0-9): $'
    MSG2 DB 0DH,0AH,'ODD/EVEN CHECK: $'
    ODDM DB 'ODD $'
    EVM  DB 'EVEN $'
    MSG3 DB 0DH,0AH,'CHECK REGISTERS: BL=AND, CL=OR, DL=XOR, AL=NOT $'

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
    INT 21H                  ;AL = ASCII digit

    SUB AL,'0'               ;AL = number 0..9

    ;----- AND (check odd/even) -----
    MOV BL,AL                ;BL = value
    AND BL,1                 ;BL = value AND 1

    PRINT MSG2               ;print label
    CMP BL,0                 ;bit0 is 0?
    JE  IS_EVEN              ;if yes, even

    PRINT ODDM               ;odd message
    JMP DO_MORE              ;continue

IS_EVEN:                     ;even case
    PRINT EVM                ;even message

DO_MORE:                     ;do OR/XOR/NOT
    MOV CL,AL                ;CL = value
    OR  CL,8                 ;CL = value OR 8

    MOV DL,AL                ;DL = value
    XOR DL,0FH               ;DL = value XOR 0Fh

    NOT AL                   ;AL = NOT value (8-bit)

    PRINT MSG3               ;tell what to inspect

    MOV AH,4CH               ;DOS: exit
    INT 21H                  ;terminate
MAIN ENDP                    ;end main

END MAIN                     ;end program

.MODEL SMALL
.STACK 100H

.DATA
    MSG1 DB 'LAB 10: ENTER A DIGIT (0-9): $'
    MSG2 DB 0DH,0AH,'TEST BIT0 (ODD/EVEN): $'
    ODDM DB 'ODD $'
    EVM  DB 'EVEN $'
    MSG3 DB 0DH,0AH,'CHECK: BL=SHL, CL=SHR, DL=ROL, BH=ROR $'

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

    ;----- TEST bit0 (odd/even) -----
    PRINT MSG2               ;print label
    TEST AL,1                ;test bit0
    JZ IS_EVEN               ;if zero, even

    PRINT ODDM               ;odd
    JMP DO_SHIFT             ;continue

IS_EVEN:                     ;even case
    PRINT EVM                ;even

DO_SHIFT:                    ;shift/rotate demo
    MOV BL,AL                ;BL = value
    SHL BL,1                 ;BL = value << 1

    MOV CL,AL                ;CL = value
    SHR CL,1                 ;CL = value >> 1

    MOV DL,AL                ;DL = value
    ROL DL,1                 ;DL rotate left 1

    MOV BH,AL                ;BH = value
    ROR BH,1                 ;BH rotate right 1

    PRINT MSG3               ;tell what to inspect

    MOV AH,4CH               ;DOS: exit
    INT 21H                  ;terminate
MAIN ENDP                    ;end main

END MAIN                     ;end program

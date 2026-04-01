.MODEL SMALL
.STACK 100H

.DATA
    AMSG DB 'LAB 7: ENTER A (0-9): $'
    BMSG DB 0DH,0AH,'ENTER B (1-9): $'
    MM   DB 0DH,0AH,'MUL (A*B) RESULT: $'
    DM   DB 0DH,0AH,'DIV (A/B) Q,R: $'
    BIG  DB ' (CHECK AX/AH IN REG) $'

.CODE

PRINT MACRO P                ;macro: print $-string
    MOV AH,9                 ;DOS: print string
    LEA DX,P                 ;DX = address
    INT 21H                  ;call DOS
ENDM

MAIN PROC                    ;program start
    MOV AX,@DATA             ;load data seg
    MOV DS,AX                ;init DS

    PRINT AMSG               ;prompt A
    MOV AH,1                 ;read char
    INT 21H                  ;AL = '0'..'9'
    SUB AL,'0'               ;AL = A number
    MOV BL,AL                ;BL = A

    PRINT BMSG               ;prompt B
    MOV AH,1                 ;read char
    INT 21H                  ;AL = '1'..'9'
    SUB AL,'0'               ;AL = B number
    MOV CL,AL                ;CL = B

    ;----- MUL: AL*CL -> AX -----
    PRINT MM                 ;show MUL label

    MOV AL,BL                ;AL = A
    MUL CL                   ;AX = AL*CL (unsigned)

    CMP AX,9                 ;single digit result?
    JA  MUL_TOO_BIG          ;if >9, don't print

    ADD AL,'0'               ;AL = ASCII digit
    MOV DL,AL                ;DL = digit
    MOV AH,2                 ;DOS: print char
    INT 21H                  ;print digit
    JMP DO_DIV               ;go next

MUL_TOO_BIG:                 ;result is 2 digits
    PRINT BIG                ;tell to check regs

DO_DIV:                      ;division part
    PRINT DM                 ;show DIV label

    MOV AL,BL                ;AL = A
    MOV AH,0                 ;AX = A
    MOV BL,CL                ;BL = B

    DIV BL                   ;AL=quotient AH=remainder
    MOV BL,AH                ;BL = remainder (save before AH is clobbered)

    ADD AL,'0'               ;quotient to ASCII
    MOV DL,AL                ;DL = quotient
    MOV AH,2                 ;DOS: print char
    INT 21H                  ;print quotient

    MOV DL,','               ;print comma
    MOV AH,2                 ;DOS: print char
    INT 21H                  ;print comma

    MOV AL,BL                ;AL = remainder (from saved register)
    ADD AL,'0'               ;remainder to ASCII
    MOV DL,AL                ;DL = remainder
    MOV AH,2                 ;DOS: print char
    INT 21H                  ;print remainder

    MOV AH,4CH               ;DOS: exit
    INT 21H                  ;terminate
MAIN ENDP                    ;end main

END MAIN                     ;end program

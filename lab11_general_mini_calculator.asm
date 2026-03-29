.MODEL SMALL
.STACK 100H

.DATA
    MSG1 DB 'LAB 11: ENTER A (0-9): $'
    MSGO DB 0DH,0AH,'ENTER OP (+,-,*,/): $'
    MSG2 DB 0DH,0AH,'ENTER B (0-9): $'
    MSGR DB 0DH,0AH,'RESULT: $'
    MSGE DB 0DH,0AH,'ERROR $'
    MSGX DB ' (CHECK AX) $'

.CODE

PRINT MACRO P                ;macro: print $-string
    MOV AH,9                 ;DOS: print string
    LEA DX,P                 ;DX = address
    INT 21H                  ;call DOS
ENDM

MAIN PROC                    ;program start
    MOV AX,@DATA             ;load data seg
    MOV DS,AX                ;init DS

    ;----- read A -----
    PRINT MSG1               ;prompt A
    MOV AH,1                 ;read char
    INT 21H                  ;AL = ASCII digit
    SUB AL,'0'               ;AL = number
    MOV BL,AL                ;BL = A

    ;----- read operator -----
    PRINT MSGO               ;prompt op
    MOV AH,1                 ;read char
    INT 21H                  ;AL = operator
    MOV BH,AL                ;BH = op

    ;----- read B -----
    PRINT MSG2               ;prompt B
    MOV AH,1                 ;read char
    INT 21H                  ;AL = ASCII digit
    SUB AL,'0'               ;AL = number
    MOV CL,AL                ;CL = B

    PRINT MSGR               ;print RESULT:

    ;----- choose operation -----
    CMP BH,'+'               ;op == '+' ?
    JE  DO_ADD               ;if yes

    CMP BH,'-'               ;op == '-' ?
    JE  DO_SUB               ;if yes

    CMP BH,'*'               ;op == '*' ?
    JE  DO_MUL               ;if yes

    CMP BH,'/'               ;op == '/' ?
    JE  DO_DIV               ;if yes

    PRINT MSGE               ;invalid op
    JMP DONE                 ;exit

DO_ADD:                      ;A + B
    MOV AL,BL                ;AL = A
    ADD AL,CL                ;AL = A+B
    CMP AL,9                 ;single digit?
    JA  TOO_BIG              ;if >9
    JMP PRINT_DIGIT          ;print digit

DO_SUB:                      ;A - B
    MOV AL,BL                ;AL = A
    CMP AL,CL                ;A < B ?
    JAE SUB_OK               ;if A>=B

    MOV DL,'-'               ;print minus
    MOV AH,2                 ;DOS: print char
    INT 21H                  ;print '-'

    MOV AL,CL                ;AL = B
    SUB AL,BL                ;AL = B-A
    JMP PRINT_DIGIT          ;print digit

SUB_OK:                      ;A>=B
    SUB AL,CL                ;AL = A-B
    JMP PRINT_DIGIT          ;print digit

DO_MUL:                      ;A * B
    MOV AL,BL                ;AL = A
    MUL CL                   ;AX = A*B
    CMP AX,9                 ;single digit?
    JA  TOO_BIG              ;if >9
    JMP PRINT_DIGIT          ;print digit

DO_DIV:                      ;A / B
    CMP CL,0                 ;B == 0 ?
    JE  DIV_ERR              ;divide by zero

    MOV AL,BL                ;AL = A
    MOV AH,0                 ;AX = A
    DIV CL                   ;AL=Q AH=R

    CMP AL,9                 ;single digit Q?
    JA  TOO_BIG              ;if >9
    JMP PRINT_DIGIT          ;print Q only

DIV_ERR:                     ;division error
    PRINT MSGE               ;print error
    JMP DONE                 ;exit

TOO_BIG:                     ;result too big
    PRINT MSGX               ;tell to check AX
    JMP DONE                 ;exit

PRINT_DIGIT:                 ;print AL as digit
    ADD AL,'0'               ;AL to ASCII
    MOV DL,AL                ;DL = char
    MOV AH,2                 ;DOS: print char
    INT 21H                  ;print digit

DONE:                        ;finish
    MOV AH,4CH               ;DOS: exit
    INT 21H                  ;terminate
MAIN ENDP                    ;end main

END MAIN                     ;end program

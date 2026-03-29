.MODEL SMALL
.STACK 100H

.DATA
    MSG1 DB 'LAB 8: ENTER 5 CHARS: $'
    MSG2 DB 0DH,0AH,'REVERSED: $'
    ARR  DB 5 DUP(?)         ;array of 5 chars

.CODE

PRINT MACRO P                ;macro: print $-string
    MOV AH,9                 ;DOS: print string
    LEA DX,P                 ;DX = address
    INT 21H                  ;call DOS
ENDM

MAIN PROC                    ;program start
    MOV AX,@DATA             ;load data seg
    MOV DS,AX                ;init DS

    PRINT MSG1               ;prompt

    LEA SI,ARR               ;SI = &ARR[0]
    MOV CX,5                 ;loop 5 times

READ_LOOP:                   ;read chars
    MOV AH,1                 ;DOS: read char
    INT 21H                  ;AL = char

    MOV [SI],AL              ;store in array
    INC SI                   ;next element

    MOV AH,0                 ;clear AH
    PUSH AX                  ;push char on stack

    LOOP READ_LOOP           ;repeat

    PRINT MSG2               ;print label

    MOV CX,5                 ;pop 5 times

POP_LOOP:                    ;reverse output
    POP AX                   ;get last char

    MOV DL,AL                ;DL = char
    MOV AH,2                 ;DOS: print char
    INT 21H                  ;print char

    LOOP POP_LOOP            ;repeat

    MOV AH,4CH               ;DOS: exit
    INT 21H                  ;terminate
MAIN ENDP                    ;end main

END MAIN                     ;end program

.MODEL SMALL
.STACK 100H

.DATA
    MSG1 DB 'LAB 3: ENTER FIRST DIGIT: $'
    MSG2 DB 0DH,0AH,'ENTER SECOND DIGIT: $'
    MSG3 DB 0DH,0AH,'LARGER DIGIT IS: $'

.CODE

PRINT MACRO P                ;macro: print $-string
    MOV AH,9                 ;DOS: print string
    LEA DX,P                 ;DX = address
    INT 21H                  ;call DOS
ENDM

New_Line PROC                ;proc: newline
    MOV AH,2                 ;DOS: print char
    MOV DL,13                ;CR
    INT 21H                  ;print CR
    MOV DL,10                ;LF
    INT 21H                  ;print LF
    RET                      ;return
New_Line ENDP                ;end proc

MAIN PROC                    ;program start
    MOV AX,@DATA             ;load data seg
    MOV DS,AX                ;init DS

    PRINT MSG1               ;prompt 1st
    MOV AH,1                 ;read char
    INT 21H                  ;AL = digit
    MOV BL,AL                ;save first

    PRINT MSG2               ;prompt 2nd
    MOV AH,1                 ;read char
    INT 21H                  ;AL = digit
    MOV CL,AL                ;save second

    PRINT MSG3               ;show label

    CMP BL,CL                ;compare ASCII digits
    JAE FIRST_IS_LARGER      ;if BL>=CL

    MOV DL,CL                ;DL = second
    JMP PRINT_IT             ;jump to print

FIRST_IS_LARGER:             ;first is larger/equal
    MOV DL,BL                ;DL = first

PRINT_IT:                    ;print chosen digit
    MOV AH,2                 ;DOS: print char
    INT 21H                  ;print DL

    MOV AH,4CH               ;DOS: exit
    INT 21H                  ;terminate
MAIN ENDP                    ;end main

END MAIN                     ;end program

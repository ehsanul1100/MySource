.MODEL SMALL
.STACK 100H

.DATA
    MSG1 DB 'LAB 6: ENTER N (0-9): $'
    MSG2 DB 0DH,0AH,'OUTPUT: $'

.CODE

PRINT MACRO P                ;macro: print $-string
    MOV AH,9                 ;DOS: print string
    LEA DX,P                 ;DX = address
    INT 21H                  ;call DOS
ENDM

MAIN PROC                    ;program start
    MOV AX,@DATA             ;load data seg
    MOV DS,AX                ;init DS

    PRINT MSG1               ;prompt N
    MOV AH,1                 ;read char
    INT 21H                  ;AL = ASCII digit

    SUB AL,'0'               ;AL = number 0..9
    MOV CL,AL                ;CL = count
    MOV CH,0                 ;CX = count

    PRINT MSG2               ;print label

    MOV DL,'1'               ;DL = first char

    JCXZ DONE                ;if CX == 0, jump to DONE

PRINT_LOOP:                  ;loop start
    MOV AH,2                 ;DOS: print char
    INT 21H                  ;print DL

    INC DL                   ;next digit char
    LOOP PRINT_LOOP          ;CX-- and loop

DONE:                        ;exit
    MOV AH,4CH               ;DOS: exit
    INT 21H                  ;terminate
MAIN ENDP                    ;end main

END MAIN                     ;end program

.MODEL SMALL
.STACK 100H

.DATA
    MSG DB 'LAB 1: STEP AND OBSERVE REGISTERS/FLAGS $'

.CODE

PRINT MACRO P                ;macro: print $-string
    MOV AH,9                 ;DOS: print string
    LEA DX,P                 ;DX = address of string
    INT 21H                  ;call DOS
ENDM

New_Line PROC                ;proc: print new line
    MOV AH,2                 ;DOS: print char
    MOV DL,13                ;CR
    INT 21H                  ;print CR
    MOV DL,10                ;LF
    INT 21H                  ;print LF
    RET                      ;return
New_Line ENDP                ;end proc

MAIN PROC                    ;program start
    MOV AX,@DATA             ;AX = data segment
    MOV DS,AX                ;DS = AX

    PRINT MSG                ;show instruction
    CALL New_Line            ;go next line

    MOV AX,0005H             ;AX = 0005
    MOV BX,0003H             ;BX = 0003
    ADD AX,BX                ;AX = AX+BX (watch CF/ZF)
    SUB AX,0008H             ;AX = AX-8 (watch ZF)
    INC BX                   ;BX = BX+1 (watch ZF)
    DEC BX                   ;BX = BX-1
    CMP AX,BX                ;compare AX with BX

    MOV AH,4CH               ;DOS: exit
    INT 21H                  ;terminate
MAIN ENDP                    ;end main

END MAIN                     ;end program

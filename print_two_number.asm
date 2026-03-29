PRINT MACRO P
          MOV AH,9
          LEA DX,P    ;PRINT str
          INT 21H
ENDM
.MODEL SMALL
.STACK 100H

.DATA
    str1 DB "PLEASE ENTER FIRST NUMBER:$"
    str2 DB "PLEASE ENTER SECOND NUMBER:$"
    str3 DB "YOUR GIVEN FIRST NUMBER IS:$"
    str4 DB "YOUR GIVEN SECOND NUMBER:$"


.CODE
MAIN PROC
             MOV   AX,@DATA
             MOV   DS,AX

             PRINT str1
             MOV   AH,1
             INT   21H
             MOV   BL,AL

             CALL  New_line

             PRINT str2
             MOV   AH,1
             INT   21H
             MOV   CL,AL

             CALL  New_line

             PRINT str3
             MOV   AH,2
             MOV   DL,BL
             INT   21H

             CALL  New_Line

             PRINT str4
             MOV   AH,2
             MOV   DL,CL
             INT   21H

             MOV   AH,4CH
             INT   21H
MAIN ENDP


New_Line PROC
             MOV   AH,2        ;DOS: print character
             MOV   DL,13       ;DL = CR
             INT   21H         ;print CR
             MOV   DL,10       ;DL = LF
             INT   21H         ;print LF
             RET
New_Line ENDP
END MAIN
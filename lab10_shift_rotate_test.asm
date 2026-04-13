.MODEL SMALL            ;8086 small model (64KB code, 64KB data)
.STACK 100H             ;256 bytes stack
.DATA
    MSG1 DB 'DIGIT (0-9): $'              ;prompt message
    MSG2 DB 0DH,0AH,'ODD/EVEN: $'         ;odd/even label
    ODD  DB 'O $'                         ;odd indicator
    EVEN DB 'E $'                         ;even indicator
    SHL_ DB 0DH,0AH,'SHL: $'              ;shift left label
    SHR_ DB 0DH,0AH,'SHR: $'              ;shift right label
    ROL_ DB 0DH,0AH,'ROL: $'              ;rotate left label
    ROR_ DB 0DH,0AH,'ROR: $'              ;rotate right label
.CODE
PRINT MACRO P           ;macro to print $-string at address P
    MOV AH,9            ;DOS function: print string
    LEA DX,P            ;DX = address of string
    INT 21H             ;call DOS interrupt
ENDM
PRINT_D MACRO           ;macro to print single digit from AL
    ADD AL,'0'          ;convert number (0-9) to ASCII ('0'-'9')
    MOV AH,2            ;DOS function: print character
    MOV DL,AL           ;DL = character to print
    INT 21H             ;call DOS interrupt
ENDM
MAIN PROC               ;program entry point
    MOV AX,@DATA        ;AX = data segment address
    MOV DS,AX           ;DS = data segment (initialize DS)

    PRINT MSG1          ;print prompt "DIGIT (0-9): "
    MOV AH,1            ;DOS function: read character
    INT 21H             ;AL = ASCII digit from user
    SUB AL,'0'          ;convert ASCII to number (AL = 0-9)
    MOV BL,AL           ;save original value in BL

    ;----- ODD/EVEN CHECK (TEST bit0) -----
    PRINT MSG2          ;print "ODD/EVEN: "
    MOV AL,BL           ;restore value to AL for testing
    TEST AL,1           ;test bit0 (1 if odd, 0 if even)
    JZ EVEN_CHK         ;if zero flag set (even), jump to EVEN_CHK
    PRINT ODD           ;print "O" for odd
    JMP SAVE_VAL        ;jump to shift/rotate section
EVEN_CHK:               ;even case
    PRINT EVEN          ;print "E" for even
SAVE_VAL:               ;shift/rotate operations
    ;----- SHL: shift left -----
    PRINT SHL_          ;print "SHL: "
    MOV AL,BL           ;restore value to AL
    SHL AL,1            ;AL = AL << 1 (multiply by 2)
    PRINT_D             ;print result as digit
    ;----- SHR: shift right -----
    PRINT SHR_          ;print "SHR: "
    MOV AL,BL           ;restore value to AL
    SHR AL,1            ;AL = AL >> 1 (divide by 2)
    PRINT_D             ;print result as digit
    ;----- ROL: rotate left -----
    PRINT ROL_          ;print "ROL: "
    MOV AL,BL           ;restore value to AL
    ROL AL,1            ;AL rotate left by 1 (bit7→bit0)
    PRINT_D             ;print result as digit
    ;----- ROR: rotate right -----
    PRINT ROR_          ;print "ROR: "
    MOV AL,BL           ;restore value to AL
    ROR AL,1            ;AL rotate right by 1 (bit0→bit7)
    PRINT_D             ;print result as digit
    MOV AH,4CH          ;DOS function: exit program
    INT 21H             ;call DOS interrupt (terminate)
MAIN ENDP               ;end main procedure
END MAIN                ;end program (entry point = MAIN)

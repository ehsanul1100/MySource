.MODEL SMALL
.STACK 100H

;==============================
; 8086 SORTING PROJECT (MENU)
; Algorithms: Insertion, Quick, Merge
; Input: 10 single-digit numbers (0-9)
;==============================

N EQU 10                      ;fixed array size

.DATA
    ;----- menu text -----
    TITLE1      DB 0DH,0AH,'--- SORTING PROJECT (8086) ---$'
    MENU1       DB 0DH,0AH,'1) ENTER NUMBERS (10 DIGITS)$'
    MENU2       DB 0DH,0AH,'2) INSERTION SORT$'
    MENU3       DB 0DH,0AH,'3) QUICK SORT$'
    MENU4       DB 0DH,0AH,'4) MERGE SORT$'
    MENU0       DB 0DH,0AH,'0) EXIT$'
    ASK         DB 0DH,0AH,'CHOICE: $'

    PROMPT      DB 0DH,0AH,'ENTER 10 DIGITS (0-9). SPACES/ENTER OK:$'
    ORGMSG      DB 0DH,0AH,'ORIGINAL: $'
    WRKMSG      DB 0DH,0AH,'SORTED:   $'
    NODATA      DB 0DH,0AH,'PLEASE ENTER NUMBERS FIRST (PRESS 1).$'

    ;----- arrays (numeric bytes 0..9) -----
    arrOriginal DB N DUP(?)                                              ;stores input
    arrWork     DB N DUP(?)                                              ;copy for sorting
    tempBuf     DB N DUP(?)                                              ;merge temp

    hasData     DB 0                                                     ;0=no input, 1=has input

    ;----- merge sort variables (word indices) -----
    width       DW 0                                                     ;current run width
    leftI       DW 0                                                     ;left index
    midI        DW 0                                                     ;middle index
    rightI      DW 0                                                     ;right index
    iIdx        DW 0                                                     ;merge i
    jIdx        DW 0                                                     ;merge j
    kIdx        DW 0                                                     ;merge k

.CODE

;----- print $-terminated string -----
PRINT MACRO P                              ;macro: print string
                             MOV   AH,9    ;DOS: print string
                             LEA   DX,P    ;DX = address
                             INT   21H     ;call DOS
ENDM

;----- print new line -----
New_Line PROC                                      ;proc: CR/LF
                       MOV   AH,2                  ;DOS: print char
                       MOV   DL,13                 ;CR
                       INT   21H                   ;print CR
                       MOV   DL,10                 ;LF
                       INT   21H                   ;print LF
                       RET                         ;return
New_Line ENDP                                      ;end proc

;----- print one character in DL -----
PutCh PROC                                         ;proc: output DL
                       MOV   AH,2                  ;DOS: print char
                       INT   21H                   ;print DL
                       RET                         ;return
PutCh ENDP                                         ;end proc

;==============================
; ReadArray: fill arrOriginal
; Accepts only '0'..'9'
; Ignores spaces and Enter
;==============================
ReadArray PROC
                       PUSH  AX                    ;save regs
                       PUSH  CX                    ;save regs
                       PUSH  DI                    ;save regs

                       PRINT PROMPT                ;show input rule

                       MOV   DI,0                  ;DI = index
                       MOV   CX,N                  ;CX = count

    READ_NEXT:
                       MOV   AH,1                  ;DOS: read key
                       INT   21H                   ;AL = char

                       CMP   AL,13                 ;Enter pressed?
                       JE    READ_NEXT             ;ignore

                       CMP   AL,' '                ;space?
                       JE    READ_NEXT             ;ignore

                       CMP   AL,'0'                ;below '0'?
                       JB    READ_NEXT             ;ignore

                       CMP   AL,'9'                ;above '9'?
                       JA    READ_NEXT             ;ignore

                       SUB   AL,'0'                ;AL = 0..9
                       MOV   arrOriginal[DI],AL    ;store number
                       INC   DI                    ;next slot
                       LOOP  READ_NEXT             ;repeat until N

                       MOV   hasData,1             ;mark as ready

                       POP   DI                    ;restore
                       POP   CX                    ;restore
                       POP   AX                    ;restore
                       RET                         ;return
ReadArray ENDP

;==============================
; CopyOriginalToWork: arrWork = arrOriginal
;==============================
CopyOriginalToWork PROC
                       PUSH  AX                    ;save regs
                       PUSH  CX                    ;save regs
                       PUSH  SI                    ;save regs
                       PUSH  DI                    ;save regs

                       LEA   SI,arrOriginal        ;SI = source
                       LEA   DI,arrWork            ;DI = dest
                       MOV   CX,N                  ;CX = count

    COPY_LOOP:
                       MOV   AL,[SI]               ;AL = source byte
                       MOV   [DI],AL               ;write to dest
                       INC   SI                    ;next source
                       INC   DI                    ;next dest
                       LOOP  COPY_LOOP             ;repeat

                       POP   DI                    ;restore
                       POP   SI                    ;restore
                       POP   CX                    ;restore
                       POP   AX                    ;restore
                       RET                         ;return
CopyOriginalToWork ENDP

;==============================
; PrintArray: prints arrWork digits
;==============================
PrintWorkArray PROC
                       PUSH  AX                    ;save regs
                       PUSH  CX                    ;save regs
                       PUSH  SI                    ;save regs

                       LEA   SI,arrWork            ;SI = base
                       MOV   CX,N                  ;CX = count

    PR_LOOP:
                       MOV   AL,[SI]               ;AL = value 0..9
                       ADD   AL,'0'                ;AL = ASCII digit

                       MOV   DL,AL                 ;DL = digit
                       CALL  PutCh                 ;print digit

                       MOV   DL,' '                ;space
                       CALL  PutCh                 ;print space

                       INC   SI                    ;next element
                       LOOP  PR_LOOP               ;repeat

                       POP   SI                    ;restore
                       POP   CX                    ;restore
                       POP   AX                    ;restore
                       RET                         ;return
PrintWorkArray ENDP

;==============================
; InsertionSort: arrWork ascending
;==============================
InsertionSort PROC
                       PUSH  AX                    ;save regs
                       PUSH  BX                    ;save regs
                       PUSH  DX                    ;save regs
                       PUSH  SI                    ;save regs
                       PUSH  DI                    ;save regs

                       PUSH  BP                    ;save regs
                       LEA   BP,arrWork            ;BP = base (use DS:)

                       MOV   DI,1                  ;i = 1

    INS_FOR:
                       CMP   DI,N                  ;i == N ?
                       JAE   INS_DONE              ;if yes, done

                       MOV   DL,DS:[BP+DI]          ;DL = key
                       MOV   SI,DI                 ;SI = i
                       DEC   SI                    ;j = i-1

    INS_WHILE:
                       CMP   SI,0FFFFH             ;j < 0 ?
                       JE    INS_PLACE             ;if yes, place key

                       MOV   AL,DS:[BP+SI]          ;AL = arr[j]
                       CMP   AL,DL                 ;arr[j] <= key ?
                       JBE   INS_PLACE             ;if yes, stop shift

                       MOV   DS:[BP+SI+1],AL        ;arr[j+1] = arr[j]
                       DEC   SI                    ;j--
                       JMP   INS_WHILE             ;repeat

    INS_PLACE:
                       MOV   DS:[BP+SI+1],DL        ;arr[j+1] = key
                       INC   DI                    ;i++
                       JMP   INS_FOR               ;next i

    INS_DONE:
                       POP   BP                    ;restore
                       POP   DI                    ;restore
                       POP   SI                    ;restore
                       POP   DX                    ;restore
                       POP   BX                    ;restore
                       POP   AX                    ;restore
                       RET                         ;return
InsertionSort ENDP

;==============================
; Swap: swap arrWork[i] and arrWork[j]
; input: DI = i, BX = j
; uses: SI = OFFSET arrWork
;==============================
Swap PROC
                       PUSH  AX                    ;save regs
                       PUSH  DX                    ;save regs

                       PUSH  SI                    ;save regs
                       PUSH  BX                    ;save regs (j)

                       MOV   SI,BX                 ;SI = j index
                       LEA   BX,arrWork            ;BX = base

                       MOV   AL,[BX+DI]            ;AL = arr[i]
                       MOV   DL,[BX+SI]            ;DL = arr[j]

                       MOV   [BX+DI],DL            ;arr[i] = arr[j]
                       MOV   [BX+SI],AL            ;arr[j] = arr[i]

                       POP   BX                    ;restore j
                       POP   SI                    ;restore

                       POP   DX                    ;restore
                       POP   AX                    ;restore
                       RET                         ;return
Swap ENDP

;==============================
; Partition (Quick Sort)
; input: AX = lo, BX = hi
; output: DX = pivot index
;==============================
Partition PROC
                       PUSH  AX                    ;save regs
                       PUSH  BX                    ;save regs
                       PUSH  CX                    ;save regs
                       PUSH  SI                    ;save regs
                       PUSH  DI                    ;save regs

                       PUSH  BP                    ;save regs
                       LEA   BP,arrWork            ;BP = base (use DS:)

                       MOV   DI,BX                 ;DI = hi
                       MOV   CH,DS:[BP+DI]          ;CH = pivot value

                       MOV   DX,AX                 ;DX = i
                       DEC   DX                    ;i = lo-1

                       MOV   SI,AX                 ;SI = j

    PART_LOOP:
                       CMP   SI,DI                 ;j == hi ?
                       JAE   PART_END              ;if yes, end

                       MOV   AL,DS:[BP+SI]          ;AL = arr[j]
                       CMP   AL,CH                 ;arr[j] <= pivot?
                       JA    PART_NEXT             ;if >, skip

                       INC   DX                    ;i++

                       PUSH  DI                    ;save hi
                       MOV   DI,DX                 ;DI = i
                       MOV   BX,SI                 ;BX = j
                       CALL  Swap                  ;swap arr[i],arr[j]
                       POP   DI                    ;restore hi

    PART_NEXT:
                       INC   SI                    ;j++
                       JMP   PART_LOOP             ;repeat

    PART_END:
                       INC   DX                    ;pivotIndex = i+1

                       MOV   BX,DI                 ;BX = hi
                       MOV   DI,DX                 ;DI = pivotIndex
                       CALL  Swap                  ;swap pivot into place

                       ;DX already has pivotIndex

                       POP   BP                    ;restore
                       POP   DI                    ;restore
                       POP   SI                    ;restore
                       POP   CX                    ;restore
                       POP   BX                    ;restore
                       POP   AX                    ;restore
                       RET                         ;return
Partition ENDP

;==============================
; QuickSort: recursive quick sort
; input: AX = lo, BX = hi
;==============================
QuickSort PROC
                       PUSH  CX                    ;save regs
                       PUSH  DX                    ;save regs
                       PUSH  SI                    ;save regs

                       CMP   AX,BX                 ;lo >= hi ?
                       JGE   QS_DONE               ;if yes, return (SIGNED: handles hi = -1)

                       PUSH  AX                    ;save lo
                       PUSH  BX                    ;save hi

                       CALL  Partition             ;DX = pivot

                       MOV   SI,DX                 ;SI = pivot (save)

                       POP   BX                    ;restore hi
                       POP   AX                    ;restore lo

                       ;----- left part: lo .. pivot-1 -----
                       MOV   CX,SI                 ;CX = pivot
                       DEC   CX                    ;CX = pivot-1

                       PUSH  AX                    ;save lo for right
                       PUSH  BX                    ;save hi for right

                       MOV   BX,CX                 ;hi = pivot-1
                       CMP   AX,BX                 ;lo < hi ?
                       JGE   QS_SKIP_LEFT          ;if not, skip (SIGNED)

                       PUSH  SI                    ;save pivot
                       CALL  QuickSort             ;sort left
                       POP   SI                    ;restore pivot

    QS_SKIP_LEFT:
                       POP   BX                    ;restore hi
                       POP   AX                    ;restore lo

                       ;----- right part: pivot+1 .. hi -----
                       MOV   AX,SI                 ;AX = pivot
                       INC   AX                    ;AX = pivot+1

                       CMP   AX,BX                 ;lo < hi ?
                       JGE   QS_DONE               ;if not, done (SIGNED)
                       CALL  QuickSort             ;sort right

    QS_DONE:
                       POP   SI                    ;restore
                       POP   DX                    ;restore
                       POP   CX                    ;restore
                       RET                         ;return
QuickSort ENDP

;==============================
; MergeSection: merge two runs
; uses leftI, midI, rightI
; writes into tempBuf[left..right-1]
;==============================
MergeSection PROC
                       PUSH  AX                    ;save regs
                       PUSH  BX                    ;save regs
                       PUSH  CX                    ;save regs
                       PUSH  DX                    ;save regs
                       PUSH  SI                    ;save regs
                       PUSH  DI                    ;save regs
                       PUSH  BP                    ;save regs

                       ;----- build pointers (8086-safe addressing) -----
                       LEA   SI,arrWork            ;SI = arrWork base
                       MOV   AX,leftI              ;AX = left index
                       ADD   SI,AX                 ;SI = leftPtr

                       LEA   DI,arrWork            ;DI = arrWork base
                       MOV   AX,midI               ;AX = mid index
                       ADD   DI,AX                 ;DI = rightPtr

                       LEA   BP,arrWork            ;BP = arrWork base
                       MOV   AX,midI               ;AX = mid index
                       ADD   BP,AX                 ;BP = leftEndPtr

                       LEA   DX,arrWork            ;DX = arrWork base
                       MOV   AX,rightI             ;AX = right index
                       ADD   DX,AX                 ;DX = rightEndPtr

                       LEA   BX,tempBuf            ;BX = tempBuf base
                       MOV   AX,leftI              ;AX = left index
                       ADD   BX,AX                 ;BX = tempPtr

    MERGE_MAIN:
                       CMP   SI,BP                 ;leftPtr < leftEnd?
                       JAE   COPY_RIGHT            ;if no, copy right

                       CMP   DI,DX                 ;rightPtr < rightEnd?
                       JAE   COPY_LEFT             ;if no, copy left

                       MOV   AL,[SI]               ;AL = left value
                       MOV   CL,[DI]               ;CL = right value

                       CMP   AL,CL                 ;left <= right ?
                       JBE   TAKE_L                ;if yes, take left

                       MOV   [BX],CL               ;temp = right
                       INC   DI                    ;rightPtr++
                       INC   BX                    ;tempPtr++
                       JMP   MERGE_MAIN            ;repeat

    TAKE_L:
                       MOV   [BX],AL               ;temp = left
                       INC   SI                    ;leftPtr++
                       INC   BX                    ;tempPtr++
                       JMP   MERGE_MAIN            ;repeat

    COPY_LEFT:
                       CMP   SI,BP                 ;leftPtr < leftEnd?
                       JAE   MERGE_DONE            ;if no, done
                       MOV   AL,[SI]               ;AL = left value
                       MOV   [BX],AL               ;temp = left
                       INC   SI                    ;leftPtr++
                       INC   BX                    ;tempPtr++
                       JMP   COPY_LEFT             ;repeat

    COPY_RIGHT:
                       CMP   DI,DX                 ;rightPtr < rightEnd?
                       JAE   MERGE_DONE            ;if no, done
                       MOV   AL,[DI]               ;AL = right value
                       MOV   [BX],AL               ;temp = right
                       INC   DI                    ;rightPtr++
                       INC   BX                    ;tempPtr++
                       JMP   COPY_RIGHT            ;repeat

    MERGE_DONE:
                       POP   BP                    ;restore
                       POP   DI                    ;restore
                       POP   SI                    ;restore
                       POP   DX                    ;restore
                       POP   CX                    ;restore
                       POP   BX                    ;restore
                       POP   AX                    ;restore
                       RET                         ;return
MergeSection ENDP

;==============================
; CopyTempToWork: arrWork = tempBuf
;==============================
CopyTempToWork PROC
                       PUSH  AX                    ;save regs
                       PUSH  CX                    ;save regs
                       PUSH  SI                    ;save regs
                       PUSH  DI                    ;save regs

                       LEA   SI,tempBuf            ;SI = source
                       LEA   DI,arrWork            ;DI = dest
                       MOV   CX,N                  ;count

    CTW_LOOP:
                       MOV   AL,[SI]               ;read
                       MOV   [DI],AL               ;write
                       INC   SI                    ;next
                       INC   DI                    ;next
                       LOOP  CTW_LOOP              ;repeat

                       POP   DI                    ;restore
                       POP   SI                    ;restore
                       POP   CX                    ;restore
                       POP   AX                    ;restore
                       RET                         ;return
CopyTempToWork ENDP

;==============================
; MergeSort: bottom-up iterative
; sorts arrWork ascending
;==============================
MergeSort PROC
                       PUSH  AX                    ;save regs
                       PUSH  BX                    ;save regs
                       PUSH  CX                    ;save regs
                       PUSH  DX                    ;save regs

                       MOV   width,1               ;width = 1

    MS_OUTER:
                       MOV   AX,width              ;AX = width
                       CMP   AX,N                  ;width >= N ?
                       JAE   MS_DONE               ;if yes, done

                       MOV   leftI,0               ;left = 0

    MS_INNER:
                       MOV   AX,leftI              ;AX = left
                       CMP   AX,N                  ;left >= N ?
                       JAE   MS_COPY               ;if yes, copy back

                       ;mid = min(left + width, N)
                       MOV   BX,width              ;BX = width
                       ADD   BX,AX                 ;BX = left+width
                       CMP   BX,N                  ;> N ?
                       JBE   MS_MID_OK             ;if not, ok
                       MOV   BX,N                  ;mid = N
    MS_MID_OK:
                       MOV   midI,BX               ;store mid

                       ;right = min(mid + width, N)
                       MOV   CX,width              ;CX = width
                       ADD   CX,BX                 ;CX = mid+width
                       CMP   CX,N                  ;> N ?
                       JBE   MS_RIGHT_OK           ;if not, ok
                       MOV   CX,N                  ;right = N
    MS_RIGHT_OK:
                       MOV   rightI,CX             ;store right

                       ;merge [left..mid) and [mid..right)
                       CALL  MergeSection          ;write into tempBuf

                       ;left = left + 2*width
                       MOV   AX,width              ;AX = width
                       SHL   AX,1                  ;AX = 2*width
                       ADD   leftI,AX              ;left += 2*width
                       JMP   MS_INNER              ;repeat

    MS_COPY:
                       CALL  CopyTempToWork        ;arrWork = tempBuf

                       MOV   AX,width              ;AX = width
                       SHL   AX,1                  ;width *= 2
                       MOV   width,AX              ;store width
                       JMP   MS_OUTER              ;next pass

    MS_DONE:
                       POP   DX                    ;restore
                       POP   CX                    ;restore
                       POP   BX                    ;restore
                       POP   AX                    ;restore
                       RET                         ;return
MergeSort ENDP

;==============================
; MAIN: menu-based controller
;==============================
MAIN PROC
                       MOV   AX,@DATA              ;load data seg
                       MOV   DS,AX                 ;init DS

    MAIN_MENU:
                       PRINT TITLE1                ;title
                       PRINT MENU1                 ;option 1
                       PRINT MENU2                 ;option 2
                       PRINT MENU3                 ;option 3
                       PRINT MENU4                 ;option 4
                       PRINT MENU0                 ;option 0
                       PRINT ASK                   ;ask choice

                       MOV   AH,1                  ;read key
                       INT   21H                   ;AL = choice

                       CMP   AL,'0'                ;exit?
                       JE    EXIT_NOW              ;if yes

                       CMP   AL,'1'                ;enter numbers?
                       JE    DO_INPUT              ;if yes

                       CMP   hasData,1             ;have input?
                       JE    CAN_SORT              ;if yes

                       PRINT NODATA                ;no data message
                       JMP   MAIN_MENU             ;back to menu

    CAN_SORT:
                       CMP   AL,'2'                ;insertion?
                       JE    DO_INS                ;if yes

                       CMP   AL,'3'                ;quick?
                       JE    DO_QUICK              ;if yes

                       CMP   AL,'4'                ;merge?
                       JE    DO_MERGE              ;if yes

                       JMP   MAIN_MENU             ;invalid choice

    DO_INPUT:
                       CALL  ReadArray             ;read arrOriginal

                       PRINT ORGMSG                ;label
                       CALL  CopyOriginalToWork    ;copy to work
                       CALL  PrintWorkArray        ;print original
                       CALL  New_Line              ;newline

                       JMP   MAIN_MENU             ;back to menu

    DO_INS:
                       CALL  CopyOriginalToWork    ;start from original
                       CALL  InsertionSort         ;sort

                       PRINT WRKMSG                ;label
                       CALL  PrintWorkArray        ;print sorted
                       CALL  New_Line              ;newline

                       JMP   MAIN_MENU             ;back

    DO_QUICK:
                       CALL  CopyOriginalToWork    ;start from original

                       MOV   AX,0                  ;lo = 0
                       MOV   BX,N-1                ;hi = N-1
                       CALL  QuickSort             ;quick sort

                       PRINT WRKMSG                ;label
                       CALL  PrintWorkArray        ;print sorted
                       CALL  New_Line              ;newline

                       JMP   MAIN_MENU             ;back

    DO_MERGE:
                       CALL  CopyOriginalToWork    ;start from original
                       CALL  MergeSort             ;merge sort

                       PRINT WRKMSG                ;label
                       CALL  PrintWorkArray        ;print sorted
                       CALL  New_Line              ;newline

                       JMP   MAIN_MENU             ;back

    EXIT_NOW:
                       MOV   AH,4CH                ;DOS: exit
                       INT   21H                   ;terminate
MAIN ENDP

END MAIN

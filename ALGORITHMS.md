# Short algorithms (one per file)

## lab01_intro_registers_flags.asm

1. Initialize `DS` with the data segment.
2. Print the lab title message.
3. Load small values into registers (`AX`, `BX`).
4. Do a few arithmetic/compare instructions (`ADD`, `SUB`, `INC`, `DEC`, `CMP`).
5. Stop (exit to DOS). _(Main purpose: step-by-step observation of registers/flags in the emulator.)_

## lab02_jmp_and_simple_conditional.asm

1. Initialize `DS`.
2. Print a prompt and read one key (a digit character).
3. Unconditionally jump to the check label (demonstrate `JMP`).
4. Compare the input with character `'5'`.
5. If equal, print “YOU ENTERED 5”; otherwise print “YOU DID NOT ENTER 5”.
6. Exit.

## lab03_decision_print_larger_digit.asm

1. Initialize `DS`.
2. Read first digit character and store it.
3. Read second digit character and store it.
4. Compare the two ASCII digits.
5. Select the larger (or the first if equal).
6. Print the chosen digit and exit.

## lab04_compare_and_branch_relations.asm

1. Initialize `DS`.
2. Read character `A` and store.
3. Read character `B` and store.
4. Compare `A` and `B`.
5. If `A > B` print “A > B”; else if `A < B` print “A < B”; else print “A = B”.
6. Exit.

## lab05_compound_range_check.asm

1. Initialize `DS`.
2. Read one digit character.
3. If input < `'3'` → print “OUT OF RANGE”.
4. Else if input > `'7'` → print “OUT OF RANGE”.
5. Else print “IN RANGE (3..7)”.
6. Exit.

## lab06_loop_print_1_to_n.asm

1. Initialize `DS`.
2. Read one digit character `N`.
3. Convert ASCII to number: `N = N - '0'` and put it in `CX`.
4. If `N == 0`, exit.
5. Set output character to `'1'`.
6. Loop `N` times using `LOOP`: print current digit, then increment digit.
7. Exit.

## lab07_mul_div_single_digit.asm

1. Initialize `DS`.
2. Read digit `A` and convert to number.
3. Read digit `B` (1..9) and convert to number.
4. Multiply: compute `A * B` using `MUL` (result in `AX`).
5. If the result is a single digit (<= 9), print it; otherwise print a note to check registers.
6. Divide: compute `A / B` using `DIV` (quotient in `AL`, remainder in `AH`).
7. Print quotient and remainder (as digits), then exit.

## lab08_array_and_stack_reverse.asm

1. Initialize `DS`.
2. Prompt for 5 characters.
3. Repeat 5 times:
   - Read a character.
   - Store it in an array.
   - Push the same character on the stack.
4. Print “REVERSED:”.
5. Pop 5 characters from the stack and print each one (this outputs reverse order).
6. Exit.

## lab09_logic_ops_and_or_xor_not.asm

1. Initialize `DS`.
2. Read one digit and convert to number (0..9).
3. Check odd/even using `AND value, 1` (bit0).
4. Print “ODD” if bit0=1, else “EVEN”.
5. Do extra logic demos (results kept in registers):
   - `OR` with 8
   - `XOR` with `0Fh`
   - `NOT` on the value
6. Print a note telling which registers to inspect, then exit.

## lab10_shift_rotate_test.asm

1. Initialize `DS`.
2. Read one digit and convert to number (0..9).
3. Check odd/even using `TEST value, 1`.
4. Print “ODD” if bit0=1, else “EVEN”.
5. Do shift/rotate demos (results kept in registers):
   - `SHL` by 1
   - `SHR` by 1
   - `ROL` by 1
   - `ROR` by 1
6. Print a note telling which registers to inspect, then exit.

## lab11_general_mini_calculator.asm

1. Initialize `DS`.
2. Read digit `A` and convert to number.
3. Read operator character (`+`, `-`, `*`, `/`).
4. Read digit `B` and convert to number.
5. If operator is `+`, compute `A+B`.
6. If operator is `-`, compute `A-B` (print `-` first if result is negative).
7. If operator is `*`, compute `A*B`.
8. If operator is `/`, if `B==0` print “ERROR”; else compute `A/B` (quotient).
9. If the final result is a single digit, print it; otherwise print a note to check `AX`.
10. Exit.

## print_two_number.asm

1. Initialize `DS`.
2. Read first digit character and save it.
3. Read second digit character and save it.
4. Print the two digits (using DOS output), typically with a newline.
5. Exit.

## simple_branching_and_jump_operation.asm

1. Initialize `DS`.
2. Read a character (often a sign or a digit).
3. Use compares and conditional jumps to choose which message/output path runs.
4. Print the selected output.
5. Exit.

## simple_branching_and_jump_operation_2.asm

1. Initialize `DS`.
2. Read a character.
3. Branch using simple conditional jumps (`JE/JNE/JB/JA` style).
4. Print the corresponding message.
5. Exit.

## mycode.asm

1. Set up segments (`DS`) and program start.
2. Run a small demo sequence (basic I/O and/or register operations).
3. Exit to DOS.

## SortingProject8086/sorting_menu.asm

1. Initialize `DS`.
2. Show the menu in a loop (repeat until user chooses Exit).
3. If user chooses “Enter Numbers”, read 10 digits (ignore spaces/Enter) into an array.
4. For any sort option, first copy the original array into a working array.
5. Run the chosen algorithm on the working array:
   - Insertion sort: insert each element into the sorted left part.
   - Quick sort: partition around a pivot, then recursively sort left and right parts.
   - Merge sort: repeatedly merge sorted runs into a temp buffer, then copy back.
6. Print the sorted working array.
7. Return to the menu; Exit ends the program.

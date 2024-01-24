CODE SEGMENT PARA 'CODE'
    ASSUME CS:CODE, DS:DATASG, SS:STAK

STAK SEGMENT PARA STACK 'STACK'
    DW 20 DUP(?)
STAK ENDS

DATASG SEGMENT PARA 'DATA'
    NUMBERS DB 10010010B, 10000010B, 11111000B, 10000000B
    A DW 300H
    B DW 302H
    ZERO DB 0C0H
    Mode DW 306H
    PRINTVAR DB 00H
    PRINTVAR2 DB 00H
DATASG ENDS

START:

    MOV AX, DATASG
    MOV DS, AX

    ; Initialize display mode
    MOV DX, Mode
    MOV AL, 90H
    OUT DX, AL

    ; Initialize variables
    MOV DX, B
    MOV AL, ZERO
    MOV PRINTVAR, AL
    XOR DI, DI
    XOR CX, CX

ENDLESS:
    CALL DISPLAY

    MOV DX, A
    IN AL, DX
    TEST AL, 1H
    JZ BUTTON2
    CMP CX, 1H
    JE ENDLESS

    ; Display the current number
    MOV AL, NUMBERS[DI]
    MOV PRINTVAR, AL

    ; Display the previous number (reversed order)
    MOV SI, 3
    SUB SI, DI
    MOV AL, NUMBERS[SI]
    MOV PRINTVAR2, AL

    INC DI
    MOV CX, 1H
    CMP DI, 4H
    JNE ENDLESS
    MOV DI, 0H
    JMP ENDLESS

BUTTON2:
    TEST AL, 10H
    JZ NOTPRESSED
    CMP CX, 1H
    JE ENDLESS

    ; Reset to default value when the button is pressed
    MOV AL, ZERO
    MOV PRINTVAR, AL
    XOR DI, DI
    JMP ENDLESS

NOTPRESSED:
    XOR CX, CX
    JMP ENDLESS

DISPLAY PROC NEAR
    PUSH AX
    MOV DX, B
    MOV AL, PRINTVAR
    SHL AL, 1
    AND AL, 11111110B

    ; Display the current number on the screen
    OUT DX, AL

    PUSH CX
    MOV CX, 20

DELAY:
    DEC CX
    LOOP DELAY

    POP CX

    MOV AL, PRINTVAR
    CMP AL, 0C0H
    JZ CONT
    MOV AL, PRINTVAR2

CONT:
    SHL AL, 1
    OR AL, 00000001B

    ; Display the previous number on the screen
    OUT DX, AL

    POP AX
    RET
DISPLAY ENDP

RETF
CODE ENDS
END START

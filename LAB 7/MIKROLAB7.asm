CODE    SEGMENT PARA 'CODE'
        ASSUME CS:CODE, SS:STAK

STAK    SEGMENT PARA STACK 'STACK'
        DW 50 DUP(?)
STAK    ENDS

; 0000 0001 0101 1000 = 0158H
; 0000 0001 0101 1010 = 015AH

; 0158h Data Transfer
; 015Ah Control

START:
	MOV DX, 015Ah
	MOV AL, 01001101B
	OUT DX, AL
	; mod choose
	; 01 -> 1 stop bit
	; 00 -> disable parity
	; 11 -> 8bit long
	; 01 -> 1x baud
	
	MOV AL, 40H
	OUT DX, AL	; software reset
	
	MOV AL, 01001101B
	OUT DX, AL	; factor: 1, data: 8bit, stop: 1
	
	MOV AL, 00010101B
	OUT DX, AL	; activate Tx and Rx, last 101

ENDLESS:
	MOV DX, 015AH
	IN AL, DX
	AND AL, 02H	; Rx Ready? wait for Rx - status reg
	JZ ENDLESS
	
	MOV DX, 0158H
	IN AL, DX
	SHR AL, 1	; error protection
	
	CMP AL, 30H	; is AL == 0
	JZ ZERO
	
	; AL != 0
	INC SI		; SI counts stack
	XOR AH, AH
	PUSH AX
	JMP ENDLESS
	
ZERO:
	CMP SI, 00H
	JZ ENDLESS 	; nothing in stack
	
	CMP SI, 03H	; is SI == 3?
	JB SKIP		; if below, CX = SI
	MOV CX, 03H	; if equal or above CX = 03h
	JMP PRINT
	
	SKIP: 
	MOV CX, SI
	JMP PRINT

TURNBACK: JMP ENDLESS

PRINT: 
	MOV DX, 015AH
	IN AL, DX
	AND AL, 01H	; Tx Ready? wait for Tx - status reg
	JZ PRINT
	
	MOV DX, 0158H
	POP AX
	OUT DX, AL	; Output from stack
	
	DEC SI		; Decrement stack counter
	LOOP PRINT
	
	
	CMP SI, 00H	; Is stack empty?
	JMP TURNBACK
	
	MOV CX, SI
	POPLOOP:
	    POP AX	; Flush
	    LOOP POPLOOP
	
	XOR SI, SI
    JMP TURNBACK
	
CODE    ENDS
        END START
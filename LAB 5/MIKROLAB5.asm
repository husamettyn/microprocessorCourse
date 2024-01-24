CODE    SEGMENT PUBLIC 'CODE'
	 ASSUME CSCODE
	 START
	    buton 
	       MOV AL, 0ffh
	       OUT 00H, AL 
	       
	       IN AL, 00H 		;Check Push Buttons
	       NOT AL
	       CMP AL, 0ffh
	       JNE output
	       JMP buton
	    output
	       OUT 00H,AL
	    JMP buton       

CODE    ENDS
        END START

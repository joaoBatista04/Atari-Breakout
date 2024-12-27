global  delay
extern vel

delay:
		MOV		CX, word[vel]
del2:	PUSH 	CX
		MOV		CX, 0600h
del1:
		LOOP	del1
		POP 	CX
		LOOP	del2
		RET
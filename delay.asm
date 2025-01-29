global debounce
global debounce_intro
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

debounce:
		MOV		CX, 80
	.debounce_loop:
		PUSH	CX
		CALL	delay
		POP		CX
		LOOP	.debounce_loop
		
		RET

debounce_intro:
		MOV		CX, 35
	.debounce_loop:
		PUSH	CX
		CALL	delay
		POP		CX
		LOOP	.debounce_loop
		
		RET

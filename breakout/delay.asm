global debounce
global debounce_intro
global delay
extern vel

;Chamada da funcao delay
delay:
		MOV		CX, word[vel]
;Loop principal do delay, realizado uma quantidade de vezes proporcional à velocidade da bolinha
del2:	
		PUSH 	CX
		MOV		CX, 0600h
;Loop interno da funcao delay
del1:
		LOOP	del1
		POP 	CX
		LOOP	del2
		RET

;Chamada da funcao de delay para debounce das teclas (tempo ate que o usuario retire o dedo da tecla)
debounce:
		MOV		CX, 80
	;Loop principal do delay de debounce
	.debounce_loop:
		PUSH	CX
		CALL	delay	;Faz uso da funcao de delay acima, com parametro do loop principal personalizado (80)
		POP		CX
		LOOP	.debounce_loop	
		RET

;Chamada de funcao de delay para debounce durante o menu de selecao de dificuldade, que precisa de um tempo diferente de debounce por conta das varias opcoes que o usuario pode selecionar
debounce_intro:
		MOV		CX, 30
	;Loop principal do delay de debounce para o menu de selecao de dificuldade
	.debounce_loop:
		PUSH	CX
		CALL	delay	;Faz uso da funcao de delay acima, com parametro do loop principal personalizado (30)
		POP		CX
		LOOP	.debounce_loop
		RET

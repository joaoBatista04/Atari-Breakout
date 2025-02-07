global intro_menu
extern cor		
extern mens_intro
extern mens_facil		
extern mens_medio		
extern mens_dificil	
extern facil_line_pos	
extern facil_col_pos	
extern medio_line_pos	
extern medio_col_pos	
extern dif_line_pos	
extern dif_col_pos		
extern select_arrow	
extern arrow_col_pos
extern arrow_line_pos
extern cursor
extern caracter
extern vel
extern pressed_keys
extern debounce_intro

; --------------------------------------------------------------------------------------------
intro_menu:							; Escreve a mensagem (Selecione a dificuldade do jogo:)
	
	MOV     CX, 32              	; Número de caracteres
	MOV     BX, 0
	MOV     DH, 12              	; Linha 0-29
	MOV     DL, 24              	; Coluna 0-79

	MOV AL, 0x0F          			;Cor branco intenso
    MOV byte [cor], AL
l3:
	CALL	cursor
	MOV     AL, [BX + mens_intro]
	CALL	caracter
	INC     BX                  	; Próximo caractere
	INC     DL                  	; Avança a coluna
	LOOP    l3

	MOV AL, 0x02          			; Cor verde
    MOV byte [cor], AL

	CALL draw_facil					; Desenha a dificuldade facil em verde (inicia o menu selecionada)

	MOV AL, 0x0F          			; Cor branco intenso
    MOV byte [cor], AL

	CALL draw_medio					; Desenha a dificildade media em branco (padrao)
	CALL draw_dif					; Desenha a dificuldade dificil em branco (padrao)

	CALL draw_facil_arrow			; Desenha a seta seletora na posicao facil (>)
	JMP wait_input					; Aguarda a pressao de tecla

draw_facil:							; Escreve a mensagem (Fácil)
	
	MOV     CX, 5              		; Número de caracteres
	MOV     BX, 0
	MOV     DH, [facil_line_pos]    ; Linha 0-29
	MOV     DL, [facil_col_pos]     ; Coluna 0-79
	
l9:
	CALL	cursor
	MOV     AL, [BX + mens_facil]
	CALL	caracter
	INC     BX                 		; Próximo caractere
	INC     DL                  	; Avança a coluna
	LOOP    l9

	RET

draw_medio:							; Escreve a mensagem (Medio)
	
	MOV     CX, 5              		; Número de caracteres
	MOV     BX, 0
	MOV     DH, [medio_line_pos]    ; Linha 0-29
	MOV     DL, [medio_col_pos]     ; Coluna 0-79
l10:
	CALL	cursor
	MOV     AL, [BX + mens_medio]
	CALL	caracter
	INC     BX                  	; Próximo caractere
	INC     DL                  	; Avança a coluna
	LOOP    l10

	RET

draw_dif:							; Escreve a mensagem (Dificil)
	
	MOV     CX, 7              		; Número de caracteres
	MOV     BX, 0
	MOV     DH, [dif_line_pos]      ; Linha 0-29
	MOV     DL, [dif_col_pos]       ; Coluna 0-79
l11:
	CALL	cursor
	MOV     AL, [BX + mens_dificil]
	CALL	caracter
	INC     BX                  	; Próximo caractere
	INC     DL                  	; Avança a coluna
	LOOP    l11

	RET

draw_facil_arrow:					; Escreve a seta seletora na posicao facil (>)
	
	MOV     CX, 1              		; Número de caracteres
	MOV     BX, 0
	MOV     DH, [facil_line_pos]    ; Linha 0-29
	MOV     DL, [arrow_col_pos]     ; Coluna 0-79

	MOV AL, 0x02          			;Cor verde
    MOV byte [cor], AL

l20:
	CALL	cursor
	MOV     AL, [BX + select_arrow]
	CALL	caracter
	INC     BX                  	; Próximo caractere
	INC     DL                  	; Avança a coluna
	LOOP    l20

	RET

draw_medio_arrow:					; Escreve a seta seletora na posicao media (>)

	
	MOV     CX, 1              		; Número de caracteres
	MOV     BX, 0
	MOV     DH, [medio_line_pos]    ; Linha 0-29
	MOV     DL, [arrow_col_pos]     ; Coluna 0-79

	MOV AL, 0x0E          			; Cor amarelo
    MOV byte [cor], AL
l21:
	CALL	cursor
	MOV     AL, [BX + select_arrow]
	CALL	caracter
	INC     BX                  	; Próximo caractere
	INC     DL                  	; Avança a coluna
	LOOP    l21

	RET

draw_dif_arrow:							; Escreve a seta seletora na posicao dificil (>)

	
	MOV     CX, 1              			; Número de caracteres
	MOV     BX, 0
	MOV     DH, [dif_line_pos]         	; Linha 0-29
	MOV     DL, [arrow_col_pos]       	; Coluna 0-79
	
	;MOV     byte[cor], vermelho

	MOV AL, 0x04          ;Cor vermelho
    MOV byte [cor], AL

l22:
	CALL	cursor
	MOV     AL, [BX + select_arrow]
	CALL	caracter
	INC     BX                  		; Próximo caractere
	INC     DL                 			; Avança a coluna
	LOOP    l22

	RET

erase_arrow:							; Apaga a seta seletora (>)
	
	MOV     CX, 1              			; Número de caracteres
	MOV     BX, 0
	MOV     DH, [arrow_line_pos]        ; Linha 0-29
	MOV     DL, [arrow_col_pos]         ; Coluna 0-79
	
	MOV AL, 0x00          				; Cor preta
    MOV byte [cor], AL

l17:
	CALL	cursor
	MOV     AL, [BX + select_arrow]
	CALL	caracter
	INC     BX                  		; Próximo caractere
	INC     DL                  		; Avança a coluna
	LOOP    l17

	RET
wait_input:								; Aguarda a pressao de tecla
	
	CALL	debounce_intro

	MOV		AL, byte[pressed_keys]	
	CMP     AL, 49						; Verifica se a tecla pressionada foi a seta para cima
	JE		pos_up_verification		

	MOV		AL, byte[pressed_keys+1]
	CMP     AL, 49						; Verifica se a tecla pressionada foi a seta para baixo
	JE		pos_down_verification

	MOV		AL, byte[pressed_keys+8]
	CMP     AL, 49						; Verifica se a tecla pressionada foi enter
	JE		pos_enter_verification

	JMP     wait_input          		; Volta para aguardar entrada válida

pos_enter_verification:
										; Quando a tecla enter é clicada, verifica-se a posição da seta na 
										; tela e define-se a dificuldade do jogo

	CMP 	word[arrow_line_pos], 14	; Confere se a seta esta na posicao da dificuldade facil
	JE		select_facil				; Seleciona nivel facil

	CMP		word[arrow_line_pos], 16	; Confere se a seta esta na posicao da dificuldade medio
	JE		select_medio				; Seleciona nivel medio

	CMP		word[arrow_line_pos], 18	; Confere se a seta esta na posicao da dificuldade dificil
	JE		select_dificil				; Seleciona nivel dificil

	JMP 	wait_input					; Se a seta nao estiver em nenhuma das posicoes, aguarda nova pressao de tecla

select_facil:
	MOV     word[vel], 15        		; Configura velocidade para "fácil"
	JMP 	clear_intro_screen			; Limpa tela de introducao

select_medio:
	MOV     word[vel], 10       		; Configura velocidade para "médio"
	JMP 	clear_intro_screen			; Limpa tela de introducao

select_dificil:
	MOV     word[vel], 5       			; Configura velocidade para "difícil"
	JMP 	clear_intro_screen			; Limpa tela de introducao
	
pos_up_verification:

										; Se a tecla seta para cima é clicada, verificamos a posição da seta na tela. 

	CALL 	erase_arrow					; Apaga a seta atual

	CMP		word[arrow_line_pos], 16	; Confere se a seta esta na posicao media
	JE		move_arrow_medio_to_facil	; Move a seta para a nova posicao

	CMP		word[arrow_line_pos], 18	; Confere se a seta esta na posicao dificil
	JE		move_arrow_dif_to_medio		; Move a seta para a nova posicao

										; Se estiver na extremidade superior, a posicao da seta
										; nao muda ela eh redesenhada no mesmo local.

	MOV AL, 0x02          				; Cor verde
    MOV byte [cor], AL

	CALL	draw_facil_arrow			; Desenha seta na nova posicao e muda a cor da seta e da escrita
	JMP 	wait_input

pos_down_verification:					; Se a tecla seta para baixo é clicada, verificamos a posição da seta na tela. 
										
	CALL 	erase_arrow					; Apaga a seta atual

	CMP 	word[arrow_line_pos], 14	; Confere se a seta esta na posicao facil
	JE		move_arrow_facil_to_medio	; Move a seta para a nova posicao

	CMP		word[arrow_line_pos], 16	; Confere se a seta esta na posicao media
	JE		move_arrow_medio_to_dif		; Move a seta para a nova posicao
										
										; Se estiver na extremidade inferior, a posicao da seta 
										; nao muda e ela eh redesenhada no mesmo local, com a mesma cor.
		
	MOV AL, 0x04          				; Cor vermelho
    MOV byte [cor], AL

	CALL 	draw_dif_arrow				; Desenha seta na nova posicao e muda a cor da seta e da escrita
	JMP 	wait_input


move_arrow_medio_to_facil:				; Altera a selecao da dificuldade de medio para facil

										; Altera a cor da posicao medio para branco (padrao)
	MOV AL, 0x0F          				; Cor branco intenso
    MOV byte [cor], AL
	
	CALL	draw_medio					; Desenha a mensagem medio

	JMP move_arrow_facil				; Redesenha a posicao facil e a seta nessa posicao, ambas na cor verde


move_arrow_dif_to_medio: 				; Altera a selecao da dificuldade de dificil para medio

										; Altera a cor da posicao dificil para branco (padrao)
	MOV AL, 0x0F          				; Cor branco intenso
    MOV byte [cor], AL

	CALL	draw_dif					; Desenha a mensagem dificil

	JMP move_arrow_medio				; Redesenha a posicao media e a seta nessa posicao, ambas na cor amarela


move_arrow_facil_to_medio:				; Altera a selecao da dificuldade de facil para medio

										; Altera a cor da posicao facil para branco (padrao)
	MOV AL, 0x0F          				; Cor branco intenso
    MOV byte [cor], AL

	CALL	draw_facil					; Desenha a mensagem facil 

	JMP move_arrow_medio				; Redesenha a posicao media e a seta nessa posicao, ambas na cor amarela


move_arrow_medio_to_dif:				; Altera a selecao da dificuldade de medio para dificil
								
										; Altera a cor da posicao facil para branco (padrao)
	MOV AL, 0x0F          				; Cor branco intenso
    MOV byte [cor], AL
	
	CALL	draw_medio					; Desenha a mensagem medio

	JMP move_arrow_dif					; Redesenha a posicao dificil e a seta nessa posicao, ambas na cor vermelha


move_arrow_facil:						; Altera a cor da posicao facil e da seta pra verde
	
	MOV word[arrow_line_pos], 14

	MOV AL, 0x02          				; Cor verde
    MOV byte [cor], AL

	CALL 	draw_facil_arrow			; Desenha a seta na posicao facil

	MOV AL, 0x02          				; Cor verde
    MOV byte [cor], AL
	
	CALL	draw_facil					; Desenha mensagem facil

	JMP wait_input						; Aguarda nova pressao de tecla


move_arrow_medio:						; Altera a cor da posicao media e da seta pra amarelo
	
	MOV word[arrow_line_pos], 16

	MOV AL, 0x0E          				; Cor amarelo
    MOV byte [cor], AL

	CALL draw_medio_arrow				; Desenha a seta na posicao media

	MOV AL, 0x0E         				; Cor amarelo
    MOV byte [cor], AL

	CALL	draw_medio					; Desenha mensagem medio

	JMP wait_input						; Aguarda nova pressao de tecla

move_arrow_dif:							; Altera a cor da posicao dificil e da seta pra vermelho
	
	MOV word[arrow_line_pos], 18
	
	MOV AL, 0x04          				; Cor vermelho
    MOV byte [cor], AL

	CALL draw_dif_arrow					; Desenha a seta na posicao dificil

	MOV AL, 0x04          				; Cor vermelho
    MOV byte [cor], AL

	CALL	draw_dif					; Desenha mensagem dificil

	JMP wait_input						; Aguarda nova pressao de tecla


clear_intro_screen: 					; Apaga a mensagem (Selecione a dificuldade do jogo:)
	
	MOV     CX, 32              		; Número de caracteres
	MOV     BX, 0
	MOV     DH, 12              		; Linha 0-29
	MOV     DL, 24               		; Coluna 0-79

	MOV AL, 0x00          				; Cor preta
    MOV byte [cor], AL

l12:
	CALL	cursor
	MOV     AL, [BX + mens_intro]
	CALL	caracter
	INC     BX                  		; Próximo caractere
	INC     DL                  		; Avança a coluna
	LOOP    l12

	MOV AL, 0x00          				; Cor preta
    MOV byte [cor], AL

	CALL	draw_facil					; Apaga mensagem facil
	CALL	draw_medio					; Apaga mensagem medio
	CALL	draw_dif					; Apaga mensagem dificil
	CALL 	erase_arrow					; Apaga a seta

	RET
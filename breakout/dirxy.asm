global DirXY

extern posX
extern posY
extern dirX
extern dirY
extern raquete_y_1
extern raquete_y_2
extern raquete_y2_1
extern raquete_y2_2

extern obstacle_x
extern obstacle_x2
extern obstacle_y
extern obstacle_y2
extern cor
extern on_obstacles_right
extern game_over
extern verifyRight
extern verifyLeft

;Chamada da funcao de verificacao sobre condicoes de colisao da bolinha ao longo dos eixos X e Y
DirXY:	
DirX:	
		;Verifica se a bolinha esta em uma posicao (ao longo do eixo X) a esquerda da raquete da esquerda (ou seja, se a bolinha esta em contato com alguma das paredes do lado esquerdo)
		MOV		AX, word[posX]
		MOV		BX, 594
		CMP		AX, BX
		JE		verify_left_walls

		;Verifica se a bolinha esta em uma posicao (ao longo do eixo X) a direita da raquete da direita (ou seja, se a bolinha esta em contato com alguma das paredes do lado direito)
		MOV		AX, word[posX]
		MOV		BX, 41
		CMP		AX, BX
		JE		verify_right_walls
		
		;Verifica se a bolinha esta em uma posicao ao longo do eixo X que corresponde a raquete da esquerda
		MOV		AX, word[posX]
		MOV		BX, 564
		CMP		AX, BX
		JE		verify_raquete_2

		;Verifica se a bolinha esta em uma posicao ao longo do eixo X que corresponde a raquete da direita
		MOV		AX, word[posX]
		MOV		BX, 71
		CMP		AX, BX
		JE		verify_raquete_1

		;Verifica se a bolinha saiu pelo lado direito da tela. Se sim, eh decretado game over
		MOV		AX, word[posX]
		CMP		AX, 4
		JBE		game_over_call

		;Verifica se a bolinha saiu pelo lado esquerdo da tela. Se sim, eh decretado game over
		MOV		AX, word[posX]
		CMP		AX, 630
		JGE		game_over_call

		;Se nenhuma dessas condicoes descritas acima ocorreu, a posicao da bolinha eh incrementada (ou decrementada) no sentido do movimento que estava acontecente anteriormente (nao houve desvio de rota)
		JNE		inc_dec_x

;Chamada de funcao para o menu de game over
game_over_call:
		CALL	game_over
		;Se o usuario digitar y, ou seja, que quer continuar o jogo, eh colocado o valor 49h no registrador AH, para que o jogo identifique e recomece
		MOV		AH, 49
		RET

;Chamada de funcao para verificar se a bolinha colidiu com alguma parede da direita
verify_right_walls:
		;Determina em qual parede a bolinha se chocou baseando-se na altura da bolinha
		CALL	verifyRight
		JMP		inc_dec_x

;Chamada de funcao para verificar se a bolinha colidiu com alguma parede da esquerda
verify_left_walls:
		;Determina em qual parede a bolinha se chocou baseando-se na altura da bolinha
		CALL	verifyLeft
		JMP		inc_dec_x

;Verifica se a bolinha colidiu com a raquete da direita em seu limite inferior
verify_raquete_1:
		;Se a bolinha encontra-se no eixo X em uma posicao que corresponda a da raquete, o eixo Y eh verificado. Se a bolinha esta acima do limite inferior da raquete, segue-se com a verificacao da colisao. Se nao, o movimento da bolinha continua normalmente
		MOV		AX, word[posY]
		MOV		BX, word[raquete_y_1]
		SUB		BX, 10
		CMP		AX, BX
		JG		verify_raquete_1_2
		JMP		inc_dec_x

;Verifica se a bolinha colidiu com a raquete da direita em seu limite superior
verify_raquete_1_2:
		;Em caso positivo para o label anterior, o eixo Y continua sendo verificado. Se a bolinha esta abaixo do limite superior da raquete, houve colisao. Se nao, o movimento da bolinha continua normalmente
		MOV		AX, word[posY]
		MOV		BX, word[raquete_y2_1]
		ADD		BX, 10
		CMP		AX, BX
		JB		direita
		JMP		inc_dec_x

;Verifica se a bolinha colidiu com a raquete da esquerda em seu limite inferior
verify_raquete_2:
		;Se a bolinha encontra-se no eixo X em uma posicao que corresponda a da raquete, o eixo Y eh verificado. Se a bolinha esta acima do limite inferior da raquete, segue-se com a verificacao da colisao. Se nao, o movimento da bolinha continua normalmente
		MOV		AX, word[posY]
		MOV		BX, word[raquete_y_2]
		SUB		BX, 10
		CMP		AX, BX
		JG		verify_raquete_2_2
		JMP		inc_dec_x

;Verifica se a bolinha colidiu com a raquete da esquerda em seu limite superior
verify_raquete_2_2:
		;Em caso positivo para o label anterior, o eixo Y continua sendo verificado. Se a bolinha esta abaixo do limite superior da raquete, houve colisao. Se nao, o movimento da bolinha continua normalmente
		MOV		AX, word[posY]
		MOV		BX, word[raquete_y2_2]
		ADD		BX, 10
		CMP		AX, BX
		JB		esquerda
		JMP		inc_dec_x

;Se houve colisao na raquete da esquerda, o sentido de movimento da bolinha no eixo X eh alterado para que ela seja rebatida
esquerda:
		MOV		word[dirX], 1
		JMP		inc_dec_x

;Se houve colisao na raquete da direita, o sentido de movimento da bolinha no eixo X eh alterado para que ela seja rebatida
direita:
		MOV		word[dirX], 0
		JMP		inc_dec_x

;Incrementa ou decrementa a posicao da bolinha no eixo X
inc_dec_x:
		;Se a direcao da bolinha no eixo X for igual a 0, incrementa-se a posicao em 1.
		MOV		AX, word[dirX]
		MOV		BX, 0
		CMP		AX, BX
		JE		inc_x 

		;Se a direcao da bolinha no eixo X for igual a 1, decrementa-se a posicao em 1.
		MOV		AX, word[dirX]
		MOV		BX, 1
		CMP		AX, BX
		JE		dec_x 

inc_x:
		;Incremento da posicao no eixo X
		MOV		AX, word[posX]
		INC		AX
		MOV		word[posX], AX
		JMP		DirY

dec_x:
		;Decremento da posicao no eixo X
		MOV		AX, word[posX]
		DEC		AX
		MOV		word[posX], AX
		JMP		DirY

DirY:	
		;Verifica se a bolinha se colidiu com o limite inferior da tela
		MOV		AX, word[posY]
		MOV		BX, 468
		CMP		AX, BX
		JE		piso

		;Verifica se a bolinha se colidiu com o limite superior da tela
		MOV		AX, word[posY]
		MOV		BX, 12
		CMP		AX, BX
		JE		teto

		;Verifica se a bolinha se colidiu com o limite superior ou inferior da raquete do lado direito
		MOV		AX, word[posX]
		CMP		AX, 81
		JL		raquete_1_bounds

		;Verifica se a bolinha se colidiu com o limite superior ou inferior da raquete do lado esquerdo
		MOV		AX, word[posX]
		CMP		AX, 556
		JG		raquete_2_bounds

		;Se nenhuma das condicoes descritas acima ocorreu, segue-se com o movimento normal da bolinha
		JMP		inc_dec_y

piso:
		;Se houve colisao com o limite inferior da tela ou da raquete, a bolinha eh rebatida
		MOV		word[dirY], 1
		JMP		inc_dec_y
teto:
		;Se houve colisao com o limite superior da tela ou da raquete, a bolinha eh rebatida
		MOV		word[dirY], 0
		JMP		inc_dec_y

;Verifica se a bolinha se chocou com os limites da raquete da direita
raquete_1_bounds:
		;Se a bolinha ultrapassou a raquete da direita, verifica-se se nao houve colisao com uma das paredes. Eh para o caso de que a bolinha tenha quebrado uma das paredes e no decorrer do seu percurso encontra outra antes de sair
		MOV		AX, word[posX]
		CMP		AX, 41
		JL		.verify_block_1
		JMP		.segue_1

		;Verifica se houve colisao com alguma parede, como descrito acima
.verify_block_1:
		CALL	verifyRight

.segue_1:
		;Verifica se a bolinha se chocou com o limite inferior da raquete
		MOV		AX, word[posY]
		ADD		AX, 11
		CMP		AX, word[raquete_y_1]
		JE		piso

		;Verifica se a bolinha se chocou com o limite superior da raquete
		MOV		AX, word[posY]
		SUB		AX, 11
		CMP		AX, word[raquete_y2_1]
		JE		teto

		JMP 	inc_dec_y

;Verifica se a bolinha se chocou com os limites da raquete da esquerda
raquete_2_bounds:
		;Se a bolinha ultrapassou a raquete da esquerda, verifica-se se nao houve colisao com uma das paredes. Eh para o caso de que a bolinha tenha quebrado uma das paredes e no decorrer do seu percurso encontra outra antes de sair
		MOV		AX, word[posX]
		CMP		AX, 594
		JG		.verify_block_2
		JMP		.segue_2

		;Verifica se houve colisao com alguma parede, como descrito acima
.verify_block_2:
		CALL	verifyLeft

.segue_2:
		;Verifica se a bolinha se chocou com o limite inferior da raquete
		MOV		AX, word[posY]
		ADD		AX, 11
		CMP		AX, word[raquete_y_2]
		JE		piso

		;Verifica se a bolinha se chocou com o limite superior da raquete
		MOV		AX, word[posY]
		SUB		AX, 11
		CMP		AX, word[raquete_y2_2]
		JE		teto

		JMP		inc_dec_y

inc_dec_y:
		;Se a direcao da bolinha no eixo Y for igual a 0, incrementa-se a posicao em 1.
		MOV		AX, word[dirY]
		MOV		BX, 0
		CMP		AX, BX
		JE		inc_y

		;Se a direcao da bolinha no eixo Y for igual a 1, decrementa-se a posicao em 1.
		MOV		AX, word[dirY]
		MOV		BX, 1
		CMP		AX, BX
		JE		dec_y

inc_y:
		;Incremento da posicao no eixo Y
		MOV		AX, word[posY]
		INC		AX
		MOV		word[posY], AX
		RET

dec_y:
		;Decremento da posicao no eixo Y
		MOV		AX, word[posY]
		DEC		AX
		MOV		word[posY], AX
		RET
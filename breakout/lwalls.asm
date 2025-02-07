extern obstacle_x
extern obstacle_x2
extern obstacle_y
extern obstacle_y2
extern cor
extern full_rectangle
extern on_obstacles_left
extern dirX
extern dirY
extern posY

global verifyLeft

;Verifica se a posicao da bolinha no eixo Y corresponde a alguma parede da esquerda
verifyLeft:
		CALL	verify_wall_1
		CALL	verify_wall_2
		CALL	verify_wall_3
		CALL	verify_wall_4
		CALL	verify_wall_5
		RET

;Verifica a primeira parede
verify_wall_1:
		;Verifica se a posicao da bolinha no eixo Y eh superior ao limite inferior da primeira parede
		MOV		AX, [posY]
		CMP		AX, 5
		JG		.verify_wall_1_left
		JMP		.return_fn

		.verify_wall_1_left:
		;Se sim, verifica se a posicao da bolinha eh inferior ao eixo superior da primeira parede
		MOV		AX, [posY]
		CMP		AX, 100
		;Se sim, verifica a parede esta ativa
		JB		.verify_if_wall_is_on

		;Se nao, mantem o movimento da bolinha e retorna
		MOV		word[dirX], 1
		JMP		.return_fn

		.verify_if_wall_is_on:
		;Verifica se a parede esta ativa a partir do vetor de paredes ativas. Se sim, o valor associado ao indice da parede naquele vetor apresentara o numero 49
		MOV		AH, byte[on_obstacles_left]
		CMP		AH, 49
		;Em caso afirmativo, prossegue-se com a quebra da parede
		JE		.apaga_wall

		;Se nao, o movimento continua e retorna
		MOV		word[dirX], 0
		JMP		.return_fn
		
		.apaga_wall:
		;Em caso de a parede estar ativa, ela eh apagada da tela de jogo, marcada como inativa no vetor de paredes ativas e a direcao da bolinha eh alterada
		MOV		byte[on_obstacles_left], 48
		MOV		word[dirX], 1
		MOV		word[obstacle_x], 605
		MOV		word[obstacle_x2], 630
		MOV		word[obstacle_y], 5
		MOV		word[obstacle_y2], 86

		MOV		byte[cor], 0
		CALL	full_rectangle	

		.return_fn:
		RET

;Verifica a segunda parede
verify_wall_2:
		;Verifica se a posicao da bolinha no eixo Y eh superior ao limite inferior da segunda parede		
		MOV		AX, [posY]
		CMP		AX, 101
		JG		.verify_wall_2_left
		JMP		.return_fn

		;Se sim, verifica se a posicao da bolinha eh inferior ao eixo superior da segunda parede
		.verify_wall_2_left:
		MOV		AX, [posY]
		CMP		AX, 182

		;Se sim, verifica a parede esta ativa
		JB		.verify_if_wall_is_on_2

		;Se nao, mantem o movimento da bolinha e retorna
		MOV		word[dirX], 1
		JMP		.return_fn

		.verify_if_wall_is_on_2:
		;Verifica se a parede esta ativa a partir do vetor de paredes ativas. Se sim, o valor associado ao indice da parede naquele vetor apresentara o numero 49
		MOV		AH, byte[on_obstacles_left+1]
		CMP		AH, 49

		;Em caso afirmativo, prossegue-se com a quebra da parede
		JE		.apaga_wall_2

		;Se nao, o movimento continua e retorna
		MOV		word[dirX], 0
		JMP		.return_fn
		
		.apaga_wall_2:
		;Em caso de a parede estar ativa, ela eh apagada da tela de jogo, marcada como inativa no vetor de paredes ativas e a direcao da bolinha eh alterada
		MOV		byte[on_obstacles_left+1], 48
		MOV		word[dirX], 1
		MOV		word[obstacle_x], 605
		MOV		word[obstacle_x2], 630
		MOV		word[obstacle_y], 101
		MOV		word[obstacle_y2], 182

		MOV		byte[cor], 0
		CALL	full_rectangle	

		.return_fn:
		RET

;Verifica a terceira parede
verify_wall_3:
		;Verifica se a posicao da bolinha no eixo Y eh superior ao limite inferior da terceira parede
		MOV		AX, [posY]
		CMP		AX, 183
		JG		.verify_wall_3_left
		JMP		.return_fn

		;Se sim, verifica se a posicao da bolinha eh inferior ao eixo superior da terceira parede
		.verify_wall_3_left:
		MOV		AX, [posY]
		CMP		AX, 278

		;Se sim, verifica a parede esta ativa
		JB		.verify_if_wall_is_on_3

		;Se nao, mantem o movimento da bolinha e retorna
		MOV		word[dirX], 1
		JMP		.return_fn

		.verify_if_wall_is_on_3:
		;Verifica se a parede esta ativa a partir do vetor de paredes ativas. Se sim, o valor associado ao indice da parede naquele vetor apresentara o numero 49
		MOV		AH, byte[on_obstacles_left+2]
		CMP		AH, 49

		;Em caso afirmativo, prossegue-se com a quebra da parede
		JE		.apaga_wall_3

		;Se nao, o movimento continua e retorna
		MOV		word[dirX], 0
		JMP		.return_fn
		
		.apaga_wall_3:
		;Em caso de a parede estar ativa, ela eh apagada da tela de jogo, marcada como inativa no vetor de paredes ativas e a direcao da bolinha eh alterada
		MOV		byte[on_obstacles_left+2], 48
		MOV		word[dirX], 1
		MOV		word[obstacle_x], 605
		MOV		word[obstacle_x2], 630
		MOV		word[obstacle_y], 197
		MOV		word[obstacle_y2], 278

		MOV		byte[cor], 0
		CALL	full_rectangle	

		.return_fn:
		RET

;Verifica a quarta parede
verify_wall_4:
		;Verifica se a posicao da bolinha no eixo Y eh superior ao limite inferior da quarta parede		
		MOV		AX, [posY]
		CMP		AX, 279
		JG		.verify_wall_4_left
		JMP		.return_fn

		;Se sim, verifica se a posicao da bolinha eh inferior ao eixo superior da quarta parede
		.verify_wall_4_left:
		MOV		AX, [posY]
		CMP		AX, 374

		;Se sim, verifica a parede esta ativa
		JB		.verify_if_wall_is_on_4

		;Se nao, mantem o movimento da bolinha e retorna
		MOV		word[dirX], 1
		JMP		.return_fn

		.verify_if_wall_is_on_4:
		;Verifica se a parede esta ativa a partir do vetor de paredes ativas. Se sim, o valor associado ao indice da parede naquele vetor apresentara o numero 49		
		MOV		AH, byte[on_obstacles_left+3]
		CMP		AH, 49

		;Em caso afirmativo, prossegue-se com a quebra da parede
		JE		.apaga_wall_4

		;Se nao, o movimento continua e retorna
		MOV		word[dirX], 0
		JMP		.return_fn
		
		.apaga_wall_4:
		;Em caso de a parede estar ativa, ela eh apagada da tela de jogo, marcada como inativa no vetor de paredes ativas e a direcao da bolinha eh alterada
		MOV		byte[on_obstacles_left+3], 48
		MOV		word[dirX], 1
		MOV		word[obstacle_x], 605
		MOV		word[obstacle_x2], 630
		MOV		word[obstacle_y], 293
		MOV		word[obstacle_y2], 374

		MOV		byte[cor], 0
		CALL	full_rectangle	

		.return_fn:
		RET

;Verifica a quinta parede
verify_wall_5:
		;Verifica se a posicao da bolinha no eixo Y eh superior ao limite inferior da quinta parede
		MOV		AX, [posY]
		CMP		AX, 375
		JG		.verify_wall_5_left
		JMP		.return_fn
		
		;Se sim, verifica se a posicao da bolinha eh inferior ao eixo superior da quinta parede
		.verify_wall_5_left:
		MOV		AX, [posY]
		CMP		AX, 480

		;Se sim, verifica a parede esta ativa
		JB		.verify_if_wall_is_on_5

		;Se nao, mantem o movimento da bolinha e retorna
		MOV		word[dirX], 1
		JMP		.return_fn

		.verify_if_wall_is_on_5:
		;Verifica se a parede esta ativa a partir do vetor de paredes ativas. Se sim, o valor associado ao indice da parede naquele vetor apresentara o numero 49		
		MOV		AH, byte[on_obstacles_left+4]
		CMP		AH, 49

		;Em caso afirmativo, prossegue-se com a quebra da parede
		JE		.apaga_wall_5

		;Se nao, o movimento continua e retorna
		MOV		word[dirX], 0
		JMP		.return_fn
		
		.apaga_wall_5:
		;Em caso de a parede estar ativa, ela eh apagada da tela de jogo, marcada como inativa no vetor de paredes ativas e a direcao da bolinha eh alterada		
		MOV		byte[on_obstacles_left+4], 48
		MOV		word[dirX], 1
		MOV		word[obstacle_x], 605
		MOV		word[obstacle_x2], 630
		MOV		word[obstacle_y], 389
		MOV		word[obstacle_y2], 470

		MOV		byte[cor], 0
		CALL	full_rectangle	

		.return_fn:
		RET	
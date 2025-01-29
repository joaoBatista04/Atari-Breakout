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
extern full_rectangle
extern on_obstacles_right
extern game_over
extern verifyRight
extern verifyLeft

DirXY:	JMP		DirX

DirX:	
		MOV		AX, word[posX]
		MOV		BX, 594
		CMP		AX, BX
		JE		verify_left_walls

		MOV		AX, word[posX]
		MOV		BX, 41
		CMP		AX, BX
		JE		verify_right_walls
		
		MOV		AX, word[posX]
		MOV		BX, 564
		CMP		AX, BX
		JE		verify_raquete_2

		MOV		AX, word[posX]
		MOV		BX, 71
		CMP		AX, BX
		JE		verify_raquete_1

		MOV		AX, word[posX]
		CMP		AX, 4
		JBE		game_over_call

		MOV		AX, word[posX]
		CMP		AX, 630
		JGE		game_over_call

		JNE		inc_dec_x

game_over_call:
		CALL	game_over
		MOV		AH, 49
		RET

verify_right_walls:
		CALL	verifyRight
		JMP		inc_dec_x

verify_left_walls:
		CALL	verifyLeft
		JMP		inc_dec_x

verify_raquete_1:
		MOV		AX, word[posY]
		MOV		BX, word[raquete_y_1]
		SUB		BX, 10
		CMP		AX, BX
		JG		verify_raquete_1_2
		JMP		inc_dec_x

verify_raquete_1_2:
		MOV		AX, word[posY]
		MOV		BX, word[raquete_y2_1]
		ADD		BX, 10
		CMP		AX, BX
		JB		direita
		JMP		inc_dec_x

verify_raquete_2:
		MOV		AX, word[posY]
		MOV		BX, word[raquete_y_2]
		SUB		BX, 10
		CMP		AX, BX
		JG		verify_raquete_2_2
		JMP		inc_dec_x

verify_raquete_2_2:
		MOV		AX, word[posY]
		MOV		BX, word[raquete_y2_2]
		ADD		BX, 10
		CMP		AX, BX
		JB		esquerda
		JMP		inc_dec_x

esquerda:
		MOV		word[dirX], 1
		JMP		inc_dec_x
direita:
		MOV		word[dirX], 0
		JMP		inc_dec_x

inc_dec_x:
		MOV		AX, word[dirX]
		MOV		BX, 0
		CMP		AX, BX
		JE		inc_x 

		MOV		AX, word[dirX]
		MOV		BX, 1
		CMP		AX, BX
		JE		dec_x 

inc_x:
		MOV		AX, word[posX]
		INC		AX
		MOV		word[posX], AX
		JMP		DirY

dec_x:
		MOV		AX, word[posX]
		DEC		AX
		MOV		word[posX], AX
		JMP		DirY

DirY:	MOV		AX, word[posY]
		MOV		BX, 468
		CMP		AX, BX
		JE		piso

		MOV		AX, word[posY]
		MOV		BX, 12
		CMP		AX, BX
		JE		teto

		MOV		AX, word[posX]
		CMP		AX, 81
		JL		raquete_1_bounds

		MOV		AX, word[posX]
		CMP		AX, 556
		JG		raquete_2_bounds

		JMP		inc_dec_y

piso:
		MOV		word[dirY], 1
		JMP		inc_dec_y
teto:
		MOV		word[dirY], 0
		JMP		inc_dec_y

raquete_1_bounds:
		MOV		AX, word[posX]
		CMP		AX, 41
		JL		.verify_block_1
		JMP		.segue_1

.verify_block_1:
		CALL	verifyRight

.segue_1:
		MOV		AX, word[posY]
		ADD		AX, 11
		CMP		AX, word[raquete_y_1]
		JE		piso

		MOV		AX, word[posY]
		SUB		AX, 11
		CMP		AX, word[raquete_y2_1]
		JE		teto

		JMP 	inc_dec_y

raquete_2_bounds:
		MOV		AX, word[posX]
		CMP		AX, 594
		JG		.verify_block_2
		JMP		.segue_2

.verify_block_2:
		CALL	verifyLeft

.segue_2:
		MOV		AX, word[posY]
		ADD		AX, 11
		CMP		AX, word[raquete_y_2]
		JE		piso

		MOV		AX, word[posY]
		SUB		AX, 11
		CMP		AX, word[raquete_y2_2]
		JE		teto

		JMP		inc_dec_y

inc_dec_y:
		MOV		AX, word[dirY]
		MOV		BX, 0
		CMP		AX, BX
		JE		inc_y

		MOV		AX, word[dirY]
		MOV		BX, 1
		CMP		AX, BX
		JE		dec_y

inc_y:
		MOV		AX, word[posY]
		INC		AX
		MOV		word[posY], AX
		RET

dec_y:
		MOV		AX, word[posY]
		DEC		AX
		MOV		word[posY], AX
		RET
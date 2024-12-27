global DirXY

extern posX
extern posY
extern dirX
extern dirY
extern raquete_y_1
extern raquete_y_2
extern raquete_y2_1
extern raquete_y2_2

DirXY:	JMP		DirX

DirX:	MOV		AX, word[posX]
		MOV		BX, 594
		CMP		AX, BX
		JE		esquerda

		MOV		AX, word[posX]
		MOV		BX, 41
		CMP		AX, BX
		JE		direita

		MOV		AX, word[posX]
		MOV		BX, 564
		CMP		AX, BX
		JE		verify_raquete_2

		MOV		AX, word[posX]
		MOV		BX, 71
		CMP		AX, BX
		JE		verify_raquete_1

		JNE		inc_dec_x


verify_raquete_1:
		MOV		AX, word[posY]
		MOV		BX, word[raquete_y_1]
		CMP		AX, BX
		JG		verify_raquete_1_2
		JMP		inc_dec_x

verify_raquete_1_2:
		MOV		AX, word[posY]
		MOV		BX, word[raquete_y2_1]
		CMP		AX, BX
		JB		direita
		JMP		inc_dec_x

verify_raquete_2:
		MOV		AX, word[posY]
		MOV		BX, word[raquete_y_2]
		CMP		AX, BX
		JG		verify_raquete_2_2
		JMP		inc_dec_x

verify_raquete_2_2:
		MOV		AX, word[posY]
		MOV		BX, word[raquete_y2_2]
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

		JNE		inc_dec_y

piso:
		MOV		word[dirY], 1
		JMP		inc_dec_y
teto:
		MOV		word[dirY], 0
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

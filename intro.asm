global intro_menu

extern cor		
extern branco_intenso
extern	pRETo
extern verde
extern vermelho
extern amarelo		
extern branco_intenso	
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


intro_menu:
	; Escrever a mensagem (Selecione a dificuldade do jogo:)
	MOV     CX, 32              ; Número de caracteres
	MOV     BX, 0
	MOV     DH, 12              ; Linha 0-29
	MOV     DL, 24               ; Coluna 0-79
	MOV     byte[cor], branco_intenso
l3:
	CALL	cursor
	MOV     AL, [BX + mens_intro]
	CALL	caracter
	INC     BX                  ; Próximo caractere
	INC     DL                  ; Avança a coluna
	LOOP    l3

	MOV     byte[cor], verde
	CALL draw_facil

	MOV     byte[cor], branco_intenso
	CALL draw_medio
	CALL draw_dif
	CALL draw_facil_arrow
	JMP wait_input

draw_facil:
	; Escrever a mensagem (Fácil)
	MOV     CX, 5              ; Número de caracteres
	MOV     BX, 0
	MOV     DH, [facil_line_pos]              ; Linha 0-29
	MOV     DL, [facil_col_pos]               ; Coluna 0-79
	
l9:
	CALL	cursor
	MOV     AL, [BX + mens_facil]
	CALL	caracter
	INC     BX                  ; Próximo caractere
	INC     DL                  ; Avança a coluna
	LOOP    l9

	RET

draw_medio:
	; Escrever a mensagem (Médio)
	MOV     CX, 5              ; Número de caracteres
	MOV     BX, 0
	MOV     DH, [medio_line_pos]              ; Linha 0-29
	MOV     DL, [medio_col_pos]               ; Coluna 0-79
l10:
	CALL	cursor
	MOV     AL, [BX + mens_medio]
	CALL	caracter
	INC     BX                  ; Próximo caractere
	INC     DL                  ; Avança a coluna
	LOOP    l10

	RET

draw_dif:
	; Escrever a mensagem (Difícil)
	MOV     CX, 7              ; Número de caracteres
	MOV     BX, 0
	MOV     DH, [dif_line_pos]              ; Linha 0-29
	MOV     DL, [dif_col_pos]               ; Coluna 0-79
l11:
	CALL	cursor
	MOV     AL, [BX + mens_dificil]
	CALL	caracter
	INC     BX                  ; Próximo caractere
	INC     DL                  ; Avança a coluna
	LOOP    l11

	RET

draw_facil_arrow:

	; Escrever a seta seletora (>)
	MOV     CX, 1              ; Número de caracteres
	MOV     BX, 0
	MOV     DH, [facil_line_pos]              ; Linha 0-29
	MOV     DL, [arrow_col_pos]               ; Coluna 0-79
	MOV     byte[cor], verde

l20:
	CALL	cursor
	MOV     AL, [BX + select_arrow]
	CALL	caracter
	INC     BX                  ; Próximo caractere
	INC     DL                  ; Avança a coluna
	LOOP    l20

	RET

draw_medio_arrow:

	; Escrever a seta seletora (>)
	MOV     CX, 1              ; Número de caracteres
	MOV     BX, 0
	MOV     DH, [medio_line_pos]              ; Linha 0-29
	MOV     DL, [arrow_col_pos]               ; Coluna 0-79
	MOV     byte[cor], amarelo
l21:
	CALL	cursor
	MOV     AL, [BX + select_arrow]
	CALL	caracter
	INC     BX                  ; Próximo caractere
	INC     DL                  ; Avança a coluna
	LOOP    l21

	RET

draw_dif_arrow:

	; Escrever a seta seletora (>)
	MOV     CX, 1              ; Número de caracteres
	MOV     BX, 0
	MOV     DH, [dif_line_pos]              ; Linha 0-29
	MOV     DL, [arrow_col_pos]               ; Coluna 0-79
	MOV     byte[cor], vermelho
l22:
	CALL	cursor
	MOV     AL, [BX + select_arrow]
	CALL	caracter
	INC     BX                  ; Próximo caractere
	INC     DL                  ; Avança a coluna
	LOOP    l22

	RET
;----------------- fim do desenho do intro menu ----------------------


erase_arrow:
	; Escrever a seta seletora (>)
	MOV     CX, 1              ; Número de caracteres
	MOV     BX, 0
	MOV     DH, [arrow_line_pos]              ; Linha 0-29
	MOV     DL, [arrow_col_pos]               ; Coluna 0-79
	MOV     byte[cor], pRETo
l17:
	CALL	cursor
	MOV     AL, [BX + select_arrow]
	CALL	caracter
	INC     BX                  ; Próximo caractere
	INC     DL                  ; Avança a coluna
	LOOP    l17

	RET
wait_input:
	; Esperar entrada do usuário
	MOV     AH, 08h
	INT     21h
	CMP     AL, 72
	JE		pos_up_verification
	CMP     AL, 80
	JE		pos_down_verification
	CMP     AL, 13
	JE		pos_enter_verification
	JMP     wait_input          ; Volta para aguardar entrada válida

pos_enter_verification:

	CMP 	word[arrow_line_pos], 14
	JE		select_facil
	CMP		word[arrow_line_pos], 16
	JE		select_medio
	CMP		word[arrow_line_pos], 18
	JE		select_dificil
	JMP 	wait_input

select_facil:
	MOV     word[vel], 15        ; Configurar velocidade para "fácil"
	JMP 	clear_intro_screen

select_medio:
	MOV     word[vel], 10       ; Configurar velocidade para "médio"
	JMP 	clear_intro_screen

select_dificil:
	MOV     word[vel], 5       ; Configurar velocidade para "difícil"
	JMP 	clear_intro_screen
	
pos_up_verification:
	CALL 	erase_arrow

	CMP		word[arrow_line_pos], 16	;medio
	JE		move_arrow_medio_to_facil
	CMP		word[arrow_line_pos], 18	;dificil
	JE		move_arrow_dif_to_medio

	MOV     byte[cor], verde
	CALL	draw_facil_arrow
	JMP 	wait_input

pos_down_verification:
	CALL 	erase_arrow

	CMP 	word[arrow_line_pos], 14	;facil
	JE		move_arrow_facil_to_medio
	CMP		word[arrow_line_pos], 16	;medio
	JE		move_arrow_medio_to_dif
	
	MOV     byte[cor], vermelho
	CALL 	draw_dif_arrow
	JMP 	wait_input


move_arrow_medio_to_facil:

	MOV     byte[cor], branco_intenso
	CALL	draw_medio

	JMP move_arrow_facil

move_arrow_dif_to_medio:

	MOV     byte[cor], branco_intenso
	CALL	draw_dif

	JMP move_arrow_medio

move_arrow_facil_to_medio:

	MOV     byte[cor], branco_intenso
	CALL	draw_facil

	JMP move_arrow_medio

move_arrow_medio_to_dif:

	MOV     byte[cor], branco_intenso
	CALL	draw_medio

	JMP move_arrow_dif


move_arrow_facil:
	
	MOV word[arrow_line_pos], 14

	MOV     byte[cor], verde
	CALL 	draw_facil_arrow

	MOV     byte[cor], verde
	CALL	draw_facil

	JMP wait_input

move_arrow_medio:
	
	MOV word[arrow_line_pos], 16

	MOV     byte[cor], amarelo
	CALL draw_medio_arrow

	MOV     byte[cor], amarelo
	CALL	draw_medio

	JMP wait_input

move_arrow_dif:
	
	MOV word[arrow_line_pos], 18
	
	MOV     byte[cor], vermelho
	CALL draw_dif_arrow

	MOV     byte[cor], vermelho
	CALL	draw_dif
	JMP wait_input


clear_intro_screen:
	; apagar a mensagem (Selecione a dificuldade do jogo:)
	MOV     CX, 32              ; Número de caracteres
	MOV     BX, 0
	MOV     DH, 12              ; Linha 0-29
	MOV     DL, 24               ; Coluna 0-79
	MOV     byte[cor], pRETo

l12:
	CALL	cursor
	MOV     AL, [BX + mens_intro]
	CALL	caracter
	INC     BX                  ; Próximo caractere
	INC     DL                  ; Avança a coluna
	LOOP    l12

	MOV     byte[cor], pRETo
	CALL	draw_facil
	CALL	draw_medio
	CALL	draw_dif
	CALL 	erase_arrow

	RET



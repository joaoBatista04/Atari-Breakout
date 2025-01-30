global modo_anterior
global cor
global vel
global posX
global posY
global dirX
global dirY
global obstacle_x
global obstacle_x2
global obstacle_y
global obstacle_y2
global raquete_y_1
global raquete_y2_1
global raquete_y_2
global raquete_y2_2
global branco_intenso
global	pRETo
global verde
global vermelho
global amarelo		
global branco_intenso
global mens_new
global mens_intro
global mens_facil		
global mens_medio		
global mens_dificil	
global facil_line_pos	
global facil_col_pos	
global medio_line_pos	
global medio_col_pos	
global dif_line_pos	
global dif_col_pos		
global select_arrow	
global arrow_col_pos
global arrow_line_pos
global mens_game
global mens_over
global pressed_keys
global exit
global on_obstacles_right
global on_obstacles_left
global draw_lines

extern game_over
extern intro_menu
extern DirXY
extern plot_xy
extern line
extern full_circle
extern circle
extern cursor
extern caracter
extern rectangle
extern raquete_1Fn
extern raquete_2Fn
extern delay
extern full_rectangle
extern debounce

segment code
..start:
;Inicializa registradores
    	MOV		AX,data		; Inicializa DS
    	MOV 	DS,AX		; Inicializa DS
    	MOV 	AX,stack	; Inicializa SS
    	MOV 	SS,AX		; Inicializa SS
    	MOV 	SP,stacktop	; Inicializa SP

;Salvar modo corrente de video(vendo como está o modo de video da maquina)
        MOV  	AH,0Fh				; obtem modo de video atual
    	INT  	10h					; chama BIOS
    	MOV  	[modo_anterior],AL  ; salva modo de video 

;Alterar modo de video para gráfico 640x480 16 cores
    	MOV     	AL,12h	; 640x480 16 cores
   		MOV     	AH,0	; set video mode
    	INT     	10h		; chama BIOS

;Instalação do tratamento para iterrupcao de teclado (INT 9h)
		CLI											;Desabilita interrupções
        MOV 	AX, 0								;Pega o segmento do vetor de interrupção
        MOV 	ES, AX								;Coloca em ES
        MOV 	AX, [ES:4 * 9 + 2]					;Pega o segmento do vetor de interrupção
        MOV 	[DS:int9_original_segment], AX		;Salva o segmento
        MOV 	AX, [ES:4 * 9]						;Pega o offset do vetor de interrupção
        MOV 	[ds:int9_original_offset], AX		;Salva o offset
        MOV 	AX, CS								;Coloca o segmento do código em AX
        MOV 	word[ES:4 * 9 + 2], AX				;Coloca o segmento do código no vetor de interrupção
        MOV 	word[ES:4 * 9], key_handler			;Coloca o offset do código no vetor de interrupção
        STI

		;Menu inicial do jogo
		CALL intro_menu								;Chama o menu inicial

;Inicializar parametros
initialize_params:
		MOV		word[posX], 320					;posição X inicial da bola
		MOV		word[posY], 240					;posição Y inicial da bola

		MOV		byte[on_obstacles_right], 49	;barreira direita
		MOV		byte[on_obstacles_right+1], 49	;barreira direita
		MOV		byte[on_obstacles_right+2], 49	;barreira direita
		MOV		byte[on_obstacles_right+3], 49	;barreira direita
		MOV		byte[on_obstacles_right+4], 49	;barreira direita

		MOV		byte[on_obstacles_left], 49		;barreira esquerda
		MOV		byte[on_obstacles_left+1], 49	;barreira esquerda
		MOV		byte[on_obstacles_left+2], 49	;barreira esquerda
		MOV		byte[on_obstacles_left+3], 49	;barreira esquerda
		MOV		byte[on_obstacles_left+4], 49	;barreira esquerda

;Desenhar Retas de limitação
draw_lines:
		MOV		byte[cor],branco_intenso ;cor branca
		MOV 	AX, 30					 ;coluna 30
		PUSH	AX						 ;empilha coluna
		MOV		AX, 0					 ;linha 0
		PUSH	AX						 ;empilha linha
		MOV		AX, 600					 ;coluna 600
		PUSH 	AX						 ;empilha coluna
		MOV		AX, 0					 ;linha 0
		PUSH	AX						 ;empilha linha
		CALL	line					 ;desenha linha

		MOV 	AX, 30					 ;coluna 30
		PUSH	AX						 ;empilha coluna
		MOV		AX, 479					 ;linha 479
		PUSH	AX						 ;empilha linha
		MOV		AX, 600					 ;coluna 600
		PUSH 	AX						 ;empilha coluna
		MOV		AX, 479					 ;linha 479
		PUSH	AX						 ;empilha linha
		CALL	line					 ;desenha linha
		
		JMP 	walls					 ;desenha barreiras

;Desenhar retângulo
next_rect:
		MOV		AX, word[obstacle_y]	;pega a posição Y
		ADD		AX, 96					;incrementa 96
		MOV		word[obstacle_y], AX	;salva a nova posição Y

		MOV		AX, word[obstacle_y2]	;pega a posição Y2
		ADD		AX, 96					;incrementa 96
		MOV		word[obstacle_y2], AX	;salva a nova posição Y2
		RET

;Desenhar barreiras coloridas no lado direito
walls:	MOV		word[obstacle_x], 5		;posição X inicial
		MOV		word[obstacle_x2], 30	;posição X final
		MOV		word[obstacle_y], 5		;posição Y inicial
		MOV		word[obstacle_y2], 86	;posição Y final

		MOV		byte[cor], azul			;cor azul
		CALL	full_rectangle			;desenha retângulo
		CALL 	next_rect				;incrementa posição Y

		MOV		byte[cor], azul_claro	;cor azul claro
		CALL	full_rectangle			;desenha retângulo
		CALL	next_rect				;incrementa posição Y
		
		MOV		byte[cor], verde		;cor verde
		CALL	full_rectangle			;desenha retângulo
		CALL	next_rect				;incrementa posição Y

		MOV		byte[cor], amarelo		;cor amarelo
		CALL	full_rectangle			;desenha retângulo
		CALL	next_rect				;incrementa posição Y

		MOV		byte[cor], vermelho		;cor vermelho
		CALL	full_rectangle			;desenha retângulo
		CALL	next_rect				;incrementa posição Y
	
;Desenhar barreiras coloridas no lado esquerdo		
walls2:	MOV		word[obstacle_x], 605	;posição X inicial
		MOV		word[obstacle_x2], 630	;posição X final
		MOV		word[obstacle_y], 5		;posição Y inicial
		MOV		word[obstacle_y2], 86	;posição Y final

		MOV		byte[cor], azul			;cor azul
		CALL	full_rectangle			;desenha retângulo
		CALL	next_rect				;incrementa posição Y

		MOV		byte[cor], azul_claro	;cor azul claro
		CALL	full_rectangle			;desenha retângulo
		CALL	next_rect				;incrementa posição Y
		
		MOV		byte[cor], verde		;cor verde
		CALL	full_rectangle			;desenha retângulo
		CALL	next_rect				;incrementa posição Y

		MOV		byte[cor], amarelo		;cor amarelo
		CALL	full_rectangle			;desenha retângulo
		CALL	next_rect				;incrementa posição Y

		
		MOV		byte[cor], vermelho		;cor vermelho
		CALL	full_rectangle			;desenha retângulo
		CALL	next_rect				;incrementa posição Y

;Inicializar as raquetes e a bola
inicializa_raquetes:
		MOV		byte[cor], magenta		;cor magenta
		CALL	raquete_1Fn				;desenha raquete 1

		MOV		byte[cor], azul_claro	;cor azul claro
		CALL	raquete_2Fn				;desenha raquete 2
        JMP     print_ball				;desenha bola


initialize_params_je:
		JMP		initialize_params		;reinicializa os parametros

;===================== LOOP PRINCIPAL

verify_pause_menu:
        MOV     AH, [pressed_keys+4]	;verifica se a tecla P foi pressionada
        CMP     AH, 49					;compara com 1
        JE      call_pause_menu			;chama o menu de pause
        JMP     verify_game_over		;verifica se o jogo acabou

call_pause_menu:
        CALL    paused_menu				;chama o menu de pause

verify_game_over:
        MOV     AH, [pressed_keys+8]	;verifica se a tecla ENTER foi pressionada
        CMP     AH, 49					;compara com 1
        JE      call_game_over			;chama o game over
        JMP     verify_quit_menu		;verifica se o jogador quer sair

call_game_over:
        CALL    game_over				;chama o game over
        JMP     draw_lines				;desenha as linhas

    
verify_quit_menu:
        MOV     AH, [pressed_keys+7]	;verifica se a tecla Q foi pressionada
        CMP     AH, 49					;compara com 1
        JE      call_quit_menu			;chama o menu de sair
        JMP     print_ball				;desenha a bola

call_quit_menu:
        CALL    exit_menu				;chama o menu de sair


;imprime a bola
print_ball:
		MOV		byte[cor], pRETo		;cor preta
		MOV		AX, word[posX]			;posição X
		PUSH 	AX						;empilha posição X
		MOV		AX, word[posY]			;posição Y
		PUSH	AX						;empilha posição Y
		MOV		AX, 10					;raio
		PUSH 	AX						;empilha raio
		CALL	circle					;desenha a bola
		CALL	DirXY					;verifica a direção da bola
		CMP		AH, 49					;compara com 1
		JE		initialize_params_je	;reinicializa os parametros
		JMP		draw					;desenha a bola

;desenha a bola
draw:
		MOV		byte[cor], verde	;cor verde
		MOV		AX, word[posX]		;posição X
		PUSH 	AX					;empilha posição X
		MOV		AX, word[posY]		;posição Y
		PUSH	AX					;empilha posição Y
		MOV		AX, 10				;raio
		PUSH 	AX					;empilha raio
		CALL	circle				;desenha a bola

		CALL	delay				;delay

;verifica raquetes
check_raquete:
		MOV     AH, [pressed_keys]		;verifica se a tecla UP foi pressionada
        CMP     AH, 49					;compara com 1
        JNE     .check_raquete_2		;se não for 1, verifica a tecla 2
        CALL    verify_upper_bound_2 	;verifica se a raquete 2 está no limite superior
.check_raquete_2:
        MOV     AH, [pressed_keys+1]  	;verifica se a tecla DOWN foi pressionada
        CMP     AH, 49					;compara com 1
        JNE     .check_raquete_3		;se não for 1, verifica a tecla 3
        CALL    verify_lower_bound_2	;verifica se a raquete 2 está no limite inferior
.check_raquete_3:
        MOV     AH, [pressed_keys+2]  	;verifica se a tecla W foi pressionada
        CMP     AH, 49					;compara com 1
        JNE     .check_raquete_4		;se não for 1, verifica a tecla 4
        CALL    verify_upper_bound		;verifica se a raquete 1 está no limite superior
.check_raquete_4:
        MOV     AH, [pressed_keys+3]  	;verifica se a tecla S foi pressionada
        CMP     AH, 49					;compara com 1
        JNE     .check_raquete_5		;se não for 1, verifica outra possibilidade
        CALL    verify_lower_bound		;verifica se a raquete 1 está no limite inferior
.check_raquete_5:
		JMP		verify_pause_menu		;verifica se o jogo está pausado

;
verify_upper_bound:		
		MOV		BX, word[raquete_y2_1]	;pega a posição Y2 da raquete 1
		CMP		BX, 470					;compara com 470
		JL		raquete_up				;se for menor, sobe a raquete
		RET								;retorna

verify_upper_bound_2:		
		MOV		BX, word[raquete_y2_2]	;pega a posição Y2 da raquete 2
		CMP		BX, 470					;compara com 470
		JL		raquete_up_2			;se for menor, sobe a raquete
		RET								;retorna

verify_lower_bound:		
		MOV		BX, word[raquete_y_1]	;pega a posição Y da raquete 1
		CMP		BX, 5					;compara com 5
		JG		raquete_down			;se for maior, desce a raquete
		RET								;retorna

verify_lower_bound_2:		
		MOV		BX, word[raquete_y_2]	;pega a posição Y da raquete 2
		CMP		BX, 5					;compara com 5
		JG		raquete_down_2			;se for maior, desce a raquete
		RET								;retorna

raquete_up:
		MOV 	AX, word[raquete_1]		;pega a posição da raquete 1
		ADD		AX, 5					;incrementa 5
		MOV 	word[raquete_1], AX		;salva a nova posição	
		JMP		raquete_draw			;desenha a raquete

raquete_up_2:
		MOV 	AX, word[raquete_2]		;pega a posição da raquete 2
		ADD		AX, 5					;incrementa 5
		MOV 	word[raquete_2], AX		;salva a nova posição
		JMP		raquete_draw			;desenha a raquete

raquete_down:
		MOV 	AX, word[raquete_1]		;pega a posição da raquete 1
		SUB		AX, 5					;decrementa 5
		MOV 	word[raquete_1], AX		;salva a nova posição
		JMP		raquete_draw			;desenha a raquete

raquete_down_2:
		MOV 	AX, word[raquete_2]		;pega a posição da raquete 2
		SUB		AX, 5					;decrementa 5
		MOV 	word[raquete_2], AX		;salva a nova posição
		JMP		raquete_draw			;desenha a raquete

raquete_draw:	
		MOV		byte[cor], pRETo		;cor preta
		CALL	raquete_1Fn				;desenha a raquete 1
		CALL	raquete_2Fn				;desenha a raquete 2
		
		MOV		BX, [raquete_1]			;pega a posição da raquete 1
		ADD		BX, 220					;incrementa 220
		MOV		word[raquete_y_1], BX	;salva a nova posição
		ADD		BX, 81					;incrementa 81
		MOV		word[raquete_y2_1], BX	;salva a nova posição
		MOV		byte[cor], magenta		;cor magenta
		CALL	raquete_1Fn				;desenha a raquete 1

		MOV		BX, [raquete_2]			;pega a posição da raquete 2
		ADD		BX, 220					;incrementa 220
		MOV		word[raquete_y_2], BX	;salva a nova posição
		ADD		BX, 81					;incrementa 81
		MOV		word[raquete_y2_2], BX	;salva a nova posição
		MOV		byte[cor], azul_claro	;cor azul claro
		CALL	raquete_2Fn				;desenha a raquete 2

		RET								;retorna

;===================== LOOP PRINCIPAL

;===================== PAUSE MENU
paused_menu:
		;Escrever uma mensagem
    	MOV     CX,7						;número de caracteres
    	MOV     BX,0						;posição inicial
    	MOV     DH,14 						;linha 0-29
    	MOV     DL,36						;coluna 0-79
		MOV		byte[cor],branco_intenso	;cor branca

l7:
		CALL	cursor						;chama cursor
    	MOV     AL,[BX+paused_mens]			;pega o caracter
		CALL	caracter					;escreve o caracter
    	INC     BX							;proximo caracter
		INC		DL							;avanca a coluna
    	LOOP    l7							;repete

        CALL    debounce					;debounce

wait_paused_menu:
        MOV     AH, [pressed_keys+4]		;verifica se a tecla P foi pressionada
		CMP		AH, 49						;compara com 1
		JNE		wait_paused_menu			;se não for 1, aguarda
		JMP		quit_pause					;chama o menu de sair

quit_pause:
	;Escrever uma mensagem
        MOV     CX,7				;número de caracteres
    	MOV     BX,0				;posição inicial
    	MOV     DH,14				;linha 0-29
    	MOV     DL,36				;coluna 0-79
		MOV		byte[cor],pRETo		;cor preta

l8:
		CALL	cursor				;chama cursor
    	MOV     AL,[BX+paused_mens]	;pega o caracter
		CALL	caracter			;escreve o caracter
    	INC     BX					;proximo caracter
		INC		DL					;avanca a coluna
    	LOOP    l8

        CALL    debounce			;debounce

        RET							;retorna

;===================== QUIT MENU
exit_menu:
	;Escrever uma mensagem
    	MOV     CX,22				;número de caracteres
    	MOV     BX,0
    	MOV     DH,14				;linha 0-29
    	MOV     DL,30				;coluna 0-79
		MOV		byte[cor],branco_intenso
l4:
		CALL	cursor
    	MOV     AL,[BX+mens_exit]
		CALL	caracter
    	INC     BX					;proximo caracter
		INC		DL					;avanca a coluna
	
    	LOOP    l4

        CALL    debounce

wait_exit_input:
		; Esperar entrada do usuário
		MOV     AH, [pressed_keys+5]
        CMP     AH, 49
		JE      exit
		MOV     AH, [pressed_keys+6]
        CMP     AH, 49
		JE      clear_exit_screen
		JMP     wait_exit_input          ; Volta para aguardar entrada válida

clear_exit_screen:
	;apaga uma mensagem
    	MOV     CX,22				;número de caracteres
    	MOV     BX,0
    	MOV     DH,14				;linha 0-29
    	MOV     DL,30				;coluna 0-79
		MOV		byte[cor],pRETo
l5:
		CALL	cursor
    	MOV     AL,[BX+mens_exit]
		CALL	caracter
    	INC     BX					;proximo caracter
		INC		DL					;avanca a coluna
	
    	LOOP    l5

		CALL    debounce

        RET

;===================== EXIT
exit:	
		PUSH 	ES
		MOV 	AX, 0
		MOV 	ES, AX
		CLI
		MOV 	AX, [int9_original_offset]
		MOV 	[ES:4 * 9], AX
		MOV 	AX, [int9_original_segment]
		MOV 	[ES:4 * 9 + 2], AX
		STI
		POP 	ES
		
		MOV  	AH,0   				; set video mode
	    MOV  	AL,[modo_anterior] 	; modo anterior
	    INT  	10h
		MOV     AX,4C00h
		INT     21h

;===================== TRATAMENTO DE INTERRUPCOES
key_handler:
			PUSH    ES
			PUSH    AX
			PUSH    BX
			MOV     AX, ds
			MOV     es, AX
			IN      al, 60h

			MOV     BH, AL
			IN      AL, 061h       
			MOV     BL, AL
			OR      AL, 080h
			OUT     061h, AL     
			MOV     AL, BL
			OUT     061h, AL 
			MOV     AL, BH
			
			CMP     AL, 0e0h
			JZ      .ignore
			MOV     AH, 0
			MOV     BX, AX
			and     BL, 01111111b
			and     AL, 10000000b
			CMP     AL, 10000000b
			JZ      .key_released_jmp
		.key_pressed:
			CMP     BL, 72
            JE      .set_key_1
            CMP     BL, 80
            JE      .set_key_2
            CMP     BL, 17
            JE      .set_key_3
            CMP     BL, 31
            JE      .set_key_4
            CMP     BL, 25
            JE      .set_key_5
            CMP     BL, 21
            JE      .set_key_6
            CMP     BL, 49
            JE      .set_key_7
            CMP     BL, 16
            JE      .set_key_8
            CMP     BL, 28
            JE      .set_key_9
			JMP     .ignore

        .ignore:
            MOV     AL, 20h
			OUT     20h, AL
			POP     BX
			POP     AX
			POP     ES
			IRET 

        .key_released_jmp:
            JMP     .key_released

        .set_key_1:
            MOV     byte[pressed_keys], 49
            JMP     .ignore
        .set_key_2:
            MOV     byte[pressed_keys+1], 49
            JMP     .ignore
        .set_key_3:
            MOV     byte[pressed_keys+2], 49
            JMP     .ignore
        .set_key_4:
            MOV     byte[pressed_keys+3], 49
            JMP     .ignore
        .set_key_5:
            MOV     byte[pressed_keys+4], 49
            JMP     .ignore
        .set_key_6:
            MOV     byte[pressed_keys+5], 49
            JMP     .ignore
        .set_key_7:
            MOV     byte[pressed_keys+6], 49
            JMP     .ignore
        .set_key_8:
            MOV     byte[pressed_keys+7], 49
            JMP     .ignore
        .set_key_9:
            MOV     byte[pressed_keys+8], 49
            JMP     .ignore

		.key_released:
			CMP     BL, 72
            JE      .unset_key_1
            CMP     BL, 80
            JE      .unset_key_2
            CMP     BL, 17
            JE      .unset_key_3
            CMP     BL, 31
            JE      .unset_key_4
            CMP     BL, 25
            JE      .unset_key_5
            CMP     BL, 21
            JE      .unset_key_6
            CMP     BL, 49
            JE      .unset_key_7
            CMP     BL, 16
            JE      .unset_key_8
            CMP     BL, 28
            JE      .unset_key_9
            JMP     .ignore2

        .ignore2:
            MOV     AL, 20h
			OUT     20h, AL
			POP     BX
			POP     AX
			POP     ES
			IRET 

        .unset_key_1:
            MOV     byte[pressed_keys], 48
            JMP     .ignore2
        .unset_key_2:
            MOV     byte[pressed_keys+1], 48
            JMP     .ignore2
        .unset_key_3:
            MOV     byte[pressed_keys+2], 48
            JMP     .ignore2
        .unset_key_4:
            MOV     byte[pressed_keys+3], 48
            JMP     .ignore2
        .unset_key_5:
            MOV     byte[pressed_keys+4], 48
            JMP     .ignore2
        .unset_key_6:
            MOV     byte[pressed_keys+5], 48
            JMP     .ignore2
        .unset_key_7:
            MOV     byte[pressed_keys+6], 48
            JMP     .ignore2
        .unset_key_8:
            MOV     byte[pressed_keys+7], 48
            JMP     .ignore2
        .unset_key_9:
            MOV     byte[pressed_keys+8], 48
            JMP     .ignore2
disable_int9:
            PUSH    ES
			MOV     AX, 0
			MOV     ES, AX
			CLI
			MOV     AX, [int9_original_offset]
			MOV     [ES:4 * 9], AX
			MOV     AX, [int9_original_segment]
			MOV     [ES:4 * 9 + 2], AX
			STI
			POP     ES
			RET

;*******************************************************************
segment data

cor		db		branco_intenso
							; I R G B COR
pRETo			equ		0	; 0 0 0 0 pRETo
azul			equ		1	; 0 0 0 1 azul
verde			equ		2	; 0 0 1 0 verde
cyan			equ		3	; 0 0 1 1 cyan
vermelho		equ		4	; 0 1 0 0 vermelho
magenta			equ		5	; 0 1 0 1 magenta
marrom			equ		6	; 0 1 1 0 marrom
branco			equ		7	; 0 1 1 1 branco
cinza			equ		8	; 1 0 0 0 cinza
azul_claro		equ		9	; 1 0 0 1 azul claro
verde_claro		equ		10	; 1 0 1 0 verde claro
cyan_claro		equ		11	; 1 0 1 1 cyan claro
rosa			equ		12	; 1 1 0 0 rosa
magenta_claro	equ		13	; 1 1 0 1 magenta claro
amarelo			equ		14	; 1 1 1 0 amarelo
branco_intenso	equ		15	; 1 1 1 1 branco INTenso

modo_anterior	db		0
linha   		dw  	0
coluna  		dw  	0
deltAX			dw		0
deltay			dw		0	

mens_new		db		'Gostaria de iniciar uma nova partida? y/n'
mens_exit    	db  	'Deseja mesmo sair? y/n'
mens_intro		db 		'Selecione a dificuldade do jogo:'

mens_facil		db 		'Facil'
mens_medio		db		'Medio'
mens_dificil	db		'Dificil'
mens_game		db		'GAME'
mens_over		db		'OVER'

facil_line_pos	dw		14
facil_col_pos	dw		26
medio_line_pos	dw		16
medio_col_pos	dw		26
dif_line_pos	dw		18
dif_col_pos		dw		26

select_arrow	db		'>'

obstacle_y		dw		5
obstacle_y2		dw		86
obstacle_x		dw		5
obstacle_x2		dw		30

arrow_line_pos	dw		14
arrow_col_pos	dw		24

raquete_y_1		dw		220
raquete_y2_1	dw		301

raquete_y_2		dw		220
raquete_y2_2	dw		301

vel				dw		10
posX			dw		320
posY			dw		240
dirX			dw		0
dirY			dw		0

raquete_1		dw		0
raquete_2		dw		0

paused_mens		db 		'Pausado'

int9_original_offset	dw 0
int9_original_segment	dw 0
; UP DOWN W S P Y N Q Enter
pressed_keys            db '000000000'

on_obstacles_right 		db '11111'
on_obstacles_left 		db '11111'

;*************************************************************************
segment stack stack
	resb	512
stacktop:
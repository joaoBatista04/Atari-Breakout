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
global pRETo
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
global deltax
global deltay

extern game_over
extern intro_menu
extern DirXY
extern plot_xy
extern line
extern circle
extern cursor
extern caracter
extern raquete_1Fn
extern raquete_2Fn
extern delay
extern full_rectangle
extern debounce
extern key_handler

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

menu:
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

;Funcao que obtem as coordenadas da proxima parede a ser desenhada (incrementa 96 a posicao antiga cada vez que chamada, pois 96 eh a distancia entre cada parede)
next_rect:
		MOV		AX, word[obstacle_y]	;pega a posição Y
		ADD		AX, 96					;incrementa 96
		MOV		word[obstacle_y], AX	;salva a nova posição Y

		MOV		AX, word[obstacle_y2]	;pega a posição Y2
		ADD		AX, 96					;incrementa 96
		MOV		word[obstacle_y2], AX	;salva a nova posição Y2
		RET

;Desenhar paredes coloridas no lado direito
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
	
;Desenhar paredes coloridas no lado esquerdo		
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

;Inicializar as raquetes, colocando-as em uma posicao proxima ao centro da tela
inicializa_raquetes:
		MOV		byte[cor], magenta		;cor magenta
		CALL	raquete_1Fn				;desenha raquete 1

		MOV		byte[cor], azul_claro	;cor azul claro
		CALL	raquete_2Fn				;desenha raquete 2
        JMP     print_ball				;desenha bola


;Label auxiliar que realiza o jump para a reincializacao dos parametros se o jogador decidir recomecar o jogo apos um game over
initialize_params_je:
		JMP		initialize_params		;reinicializa os parametros

;========================================== LOOP PRINCIPAL ==========================================
;Verifica se a tecla 'p' foi pressionada. Se sim, faz a chamada do menu de pausa. Se nao, passa adiante para a proxima verificacao
verify_pause_menu:
        MOV     AH, [pressed_keys+4]	;verifica se a tecla P foi pressionada
        CMP     AH, 49					;compara com 1
        JE      call_pause_menu			;chama o menu de pause
        JMP     verify_game_over		;verifica se o jogo acabou

;Chama o menu de pausa em caso de o usuario ter pressionado a tecla 'p'
call_pause_menu:
        CALL    paused_menu
    
;Verifica se a tecla 'q' foi pressionada. Se sim, faz a chamada do menu de quit. Se nao, passa adiante para a proxima verificacao
verify_quit_menu:
        MOV     AH, [pressed_keys+7]	;verifica se a tecla Q foi pressionada
        CMP     AH, 49					;compara com 1
        JE      call_quit_menu			;chama o menu de sair
        JMP     print_ball				;desenha a bola

;Chama o menu de quit em caso de o usuario ter pressionado a tecla 'q'
call_quit_menu:
        CALL    exit_menu				;chama o menu de sair

;Faz a impressao da bolinha na tela
print_ball:
		;Desenha a bolinha de cor preta por cima da bolinha antiga na tela, para apagar a antiga e permitir o desenho em uma nova posicao
		MOV		byte[cor], pRETo
		MOV		AX, word[posX]
		PUSH 	AX
		MOV		AX, word[posY]
		PUSH	AX
		MOV		AX, 10
		PUSH 	AX
		CALL	circle

		;Verifica se algum evento ocorreu com a bolinha e efetua o seu deslocamento ou reacao em caso positivo
		CALL	DirXY

		;Se houve game over e o usuario decidiu recomecar o jogo, volta-se para a inicializacao dos parametros
		CMP		AH, 49
		JE		initialize_params_je

		;Se nao, segue-se com o desenho da bolinha
		JMP		draw

;Desenha a bolinha em nova posicao
draw:
		;Com a nova posicao da bolinha, ela eh desenhada em verde
		MOV		byte[cor], verde
		MOV		AX, word[posX]
		PUSH 	AX
		MOV		AX, word[posY]
		PUSH	AX
		MOV		AX, 10
		PUSH 	AX
		CALL	circle

		;Pequeno delay eh aplicado para que o deslocamento se torne fluido e visivel aos olhos
		CALL	delay

;Faz a verificao se algum dos jogadores (ou ambos) deslocaram suas raquetes
check_raquete:
		;Se a seta para cima foi pressionada, verifica condicoes da raquete da esquerda
		MOV     AH, [pressed_keys]
        CMP     AH, 49

		;Se nao foi pressionada, verifica-se o proximo comando para a raquete
        JNE     .check_raquete_2
		;Se foi, verifica-se condicoes da raquete da esquerda
        CALL    verify_upper_bound_2 

.check_raquete_2:
		;Se a seta para baixo foi pressionada, verifica condicoes da raquete da esquerda
        MOV     AH, [pressed_keys+1]  
        CMP     AH, 49

		;Se nao foi pressionada, verifica-se a proxima raquete
        JNE     .check_raquete_3

		;Se foi, verifica-se condicoes da raquete da esquerda
        CALL    verify_lower_bound_2

.check_raquete_3:
		;Se a tecla 'w' foi pressionada, verifica condicoes da raquete da direita
        MOV     AH, [pressed_keys+2]  
        CMP     AH, 49

		;Se nao foi pressionada, verifica-se o proximo comando para a raquete
        JNE     .check_raquete_4

		;Se foi, verifica-se condicoes da raquete da direita
        CALL    verify_upper_bound

.check_raquete_4:
		;Se a tecla 's' foi pressionada, verifica condicoes da raquete da direita
        MOV     AH, [pressed_keys+3]  
        CMP     AH, 49

		;Se nao foi pressionada, segue-se para o termino da verificacao de raquetes
        JNE     .check_raquete_5

		;Se foi, verifica-se condicoes da raquete da direita
        CALL    verify_lower_bound
.check_raquete_5:
		;Se nenhuma acao foi feita com as raquetes, segue-se com as verificacoes (no caso, se o menu de pausa foi acionado)
		JMP		verify_pause_menu
		
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

;========================================== PAUSE MENU ==========================================
;Funcao que escreve uma mensagem de pausa simples na tela e fica a espera de o usuario pressionar novamente a tecla 'p'
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

;Verifica se o usuario pressionou a tecla 'p'
wait_paused_menu:
        MOV     AH, [pressed_keys+4]		;verifica se a tecla P foi pressionada
		CMP		AH, 49						;compara com 1
		JNE		wait_paused_menu			;se não for 1, retorna ao inicio do loop para esperar uma resposta do usuario
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

;========================================== QUIT MENU ==========================================
;Funcao que escreve uma mensagem de quit simples na tela e fica a espera da decisao do usuario de finalizar ou nao o jogo
exit_menu:
	;Escrever uma mensagem
    	MOV     CX,22						;número de caracteres
    	MOV     BX,0						;posição inicial
    	MOV     DH,14						;linha 0-29
    	MOV     DL,30						;coluna 0-79
		MOV		byte[cor],branco_intenso	;cor branca
l4:
		CALL	cursor						;chama cursor
    	MOV     AL,[BX+mens_exit]			;pega o caracter
		CALL	caracter					;escreve o caracter
    	INC     BX							;proximo caracter
		INC		DL							;avanca a coluna
	
    	LOOP    l4							;repete

		;Faz um delay de debounce para dar tempo de o usuario retirar o dedo da tecla ate entao pressionada
        CALL    debounce					

wait_exit_input:
		; Esperar entrada do usuário
		MOV     AH, [pressed_keys+5]		;verifica se a tecla Y foi pressionada
        CMP     AH, 49						;compara com 1
		JE      exit						;chama a função de sair
		MOV     AH, [pressed_keys+6]		;verifica se a tecla N foi pressionada
        CMP     AH, 49						;compara com 1
		JE      clear_exit_screen			;apaga a mensagem
		JMP     wait_exit_input          	;repete para aguardar entrada válida

;apaga uma mensagem
clear_exit_screen:
		;Apaga a mensagem de quit da tela, sobrescrevendo-a com preto
    	MOV     CX,22				;número de caracteres
    	MOV     BX,0				;posição inicial
    	MOV     DH,14				;linha 0-29
    	MOV     DL,30				;coluna 0-79
		MOV		byte[cor],pRETo		;cor preta
l5:
		CALL	cursor				;chama cursor
    	MOV     AL,[BX+mens_exit]	;pega o caracter
		CALL	caracter			;escreve o caracter
    	INC     BX					;proximo caracter
		INC		DL					;avanca a coluna
	
    	LOOP    l5					;repete

		;Faz um delay de debounce para dar tempo de o usuario retirar o dedo da tecla ate entao pressionada
		CALL    debounce

        RET
;========================================== QUIT MENU ==========================================

;========================================== EXIT ==========================================
;Realiza a finalizacao do programa
exit:	
		PUSH 	ES								
		MOV 	AX, 0							
		MOV 	ES, AX							;Coloca 0 em ES
		CLI										;Desabilita interrupções
		MOV 	AX, [int9_original_offset]		;Pega o offset do vetor de interrupção
		MOV 	[ES:4 * 9], AX					;Coloca o offset do vetor de interrupção em ES
		MOV 	AX, [int9_original_segment]		;Pega o segmento do vetor de interrupção
		MOV 	[ES:4 * 9 + 2], AX				;Coloca o segmento do vetor de interrupção em ES
		STI										;Habilita interrupções
		POP 	ES								;Restaura ES
		
		MOV  	AH,0   							;restaura modo de video
	    MOV  	AL,[modo_anterior] 				;modo anterior
	    INT  	10h								;chama BIOS
		
		MOV     AX,4C00h						;termina o programa
		INT     21h								;chama DOS
;========================================== EXIT ==========================================

;========================================== DATA ==========================================
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

modo_anterior	db		0   ;Modo anterior (saida do modo grafico)
linha   		dw  	0
coluna  		dw  	0
deltax			dw		0
deltay			dw		0	

mens_new		db		'Gostaria de iniciar uma nova partida? y/n'		;mensagem de novo jogo
mens_exit    	db  	'Deseja mesmo sair? y/n'						;mensagem de saida
mens_intro		db 		'Selecione a dificuldade do jogo:'				;mensagem de introdução
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

select_arrow	db		'>'			;seta de seleção

;Variaveis utilizadas para desenhar as paredes e verificar a posicao deles quando a bolinha colide
obstacle_y		dw		5
obstacle_y2		dw		86
obstacle_x		dw		5
obstacle_x2		dw		30

arrow_line_pos	dw		14			;posição da linha da seta	
arrow_col_pos	dw		24			;posição da coluna da seta

raquete_y_1		dw		220			;Limite inferior atual da raquete da direita
raquete_y2_1	dw		301			;Limite superior atual da raquete da direita

raquete_y_2		dw		220			;Limite inferior atual da raquete da esquerda
raquete_y2_2	dw		301			;Limite superior atual da raquete da esquerda

vel				dw		10		;Velocidade da bolinha
posX			dw		320		;Posicao da bolinha no eixo X
posY			dw		240		;Posicao da bolinha no eixo Y
dirX			dw		0		;Direcao atual da bolinha no eixo X
dirY			dw		0		;Direcao atual da bolinha no eixo Y

raquete_1		dw		0
raquete_2		dw		0		

paused_mens		db 		'Pausado'	;Mensagem de pausa

;Segmente e offset original do tratamento de interrupcoes
int9_original_offset	dw 0
int9_original_segment	dw 0

;Vetor de teclas pressionadas, na seguinte ordem: UP DOWN W S P Y N Q Enter
pressed_keys            db '000000000'

;Vetores de paredes que estao ativas em ambos os lados
on_obstacles_right 		db '11111'
on_obstacles_left 		db '11111'
;========================================== DATA ==========================================

segment stack stack
	resb	512
stacktop:
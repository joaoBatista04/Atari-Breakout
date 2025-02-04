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
    	MOV		AX,data
    	MOV 	DS,AX
    	MOV 	AX,stack
    	MOV 	SS,AX
    	MOV 	SP,stacktop

;Salvar modo corrente de video(vendo como está o modo de video da maquina)
        MOV  	AH,0Fh
    	INT  	10h
    	MOV  	[modo_anterior],AL   

;Alterar modo de video para gráfico 640x480 16 cores
    	MOV     	AL,12h
   		MOV     	AH,0
    	INT     	10h

;Instalação do tratamento para iterrupcao de teclado (INT 9h)
		CLI
        MOV 	AX, 0
        MOV 	ES, AX
        MOV 	AX, [ES:4 * 9 + 2]
        MOV 	[DS:int9_original_segment], AX
        MOV 	AX, [ES:4 * 9]
        MOV 	[ds:int9_original_offset], AX
        MOV 	AX, CS
        MOV 	word[ES:4 * 9 + 2], AX
        MOV 	word[ES:4 * 9], key_handler
        STI

menu:
		;Menu inicial do jogo
		CALL intro_menu

initialize_params:
		;Inicializacao de todos os parametros; Apesar de estarem definidos inicialmente no segmento de dados, essas variaveis precisam ser reinicializadas quando ocorre um game over e o jogador decide recomecar a partida

		;Inicializacao da posicao da bolinha
		MOV		word[posX], 320
		MOV		word[posY], 240

		;Definindo as paredes como ativas
		MOV		CX, 5
		XOR		BX, BX
		.ativa_paredes:
		;Loop de 5 iteracoes, para cada uma das paredes. Em cada iteracao, as paredes de ambos os lados no mesmo nivel sao definidas como ativas
		MOV		byte[on_obstacles_right+BX], 49
		MOV		byte[on_obstacles_left+BX], 49
		INC		BX
		LOOP 	.ativa_paredes

;Desenhar Retas
draw_lines:
		;Desenha a reta branca que define o limite inferior da tela
		MOV		byte[cor],branco_intenso
		MOV 	AX, 30
		PUSH	AX
		MOV		AX, 0
		PUSH	AX
		MOV		AX, 600
		PUSH 	AX
		MOV		AX, 0
		PUSH	AX
		CALL	line

		;Desenha a reta branca que define o limite superior da tela
		MOV 	AX, 30
		PUSH	AX
		MOV		AX, 479
		PUSH	AX
		MOV		AX, 600
		PUSH 	AX
		MOV		AX, 479
		PUSH	AX
		CALL	line
		
		JMP 	walls

;Funcao que obtem as coordenadas da proxima parede a ser desenhada (incrementa 96 a posicao antiga cada vez que chamada, pois 96 eh a distancia entre cada parede)
next_rect:
		MOV		AX, word[obstacle_y]
		ADD		AX, 96
		MOV		word[obstacle_y], AX

		MOV		AX, word[obstacle_y2]
		ADD		AX, 96
		MOV		word[obstacle_y2], AX
		RET

;Desenha as paredes coloridas no lado direito
walls:	
		MOV		word[obstacle_x], 5
		MOV		word[obstacle_x2], 30
		MOV		word[obstacle_y], 5
		MOV		word[obstacle_y2], 86

		MOV		byte[cor], azul
		CALL	full_rectangle	
		CALL 	next_rect

		MOV		byte[cor], azul_claro
		CALL	full_rectangle
		CALL	next_rect
		
		MOV		byte[cor], verde
		CALL	full_rectangle
		CALL	next_rect

		MOV		byte[cor], amarelo
		CALL	full_rectangle
		CALL	next_rect

		MOV		byte[cor], vermelho
		CALL	full_rectangle
		CALL	next_rect
	
;Desenha as paredes coloridas no lado esquerdo		
walls2:	MOV		word[obstacle_x], 605
		MOV		word[obstacle_x2], 630
		MOV		word[obstacle_y], 5
		MOV		word[obstacle_y2], 86

		MOV		byte[cor], azul
		CALL	full_rectangle
		CALL	next_rect

		MOV		byte[cor], azul_claro
		CALL	full_rectangle
		CALL	next_rect
		
		MOV		byte[cor], verde
		CALL	full_rectangle
		CALL	next_rect

		MOV		byte[cor], amarelo
		CALL	full_rectangle
		CALL	next_rect

		
		MOV		byte[cor], vermelho
		CALL	full_rectangle
		CALL	next_rect

;Inicializar as raquetes, colocando-as em uma posicao proxima ao centro da tela
inicializa_raquetes:
		MOV		byte[cor], magenta
		CALL	raquete_1Fn

		MOV		byte[cor], azul_claro
		CALL	raquete_2Fn
        JMP     print_ball

;Label auxiliar que realiza o jump para a reincializacao dos parametros se o jogador decidir recomecar o jogo apos um game over
initialize_params_je:
		JMP		initialize_params

;========================================== LOOP PRINCIPAL ==========================================
;Verifica se a tecla 'p' foi pressionada. Se sim, faz a chamada do menu de pausa. Se nao, passa adiante para a proxima verificacao
verify_pause_menu:
        MOV     AH, [pressed_keys+4]
        CMP     AH, 49
        JE      call_pause_menu
        JMP     verify_game_over

;Chama o menu de pausa em caso de o usuario ter pressionado a tecla 'p'
call_pause_menu:
        CALL    paused_menu
    
;Verifica se a tecla 'q' foi pressionada. Se sim, faz a chamada do menu de quit. Se nao, passa adiante para a proxima verificacao
verify_quit_menu:
        MOV     AH, [pressed_keys+7]
        CMP     AH, 49
        JE      call_quit_menu
        JMP     print_ball

;Chama o menu de quit em caso de o usuario ter pressionado a tecla 'q'
call_quit_menu:
        CALL    exit_menu

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
		;Verifica se a raquete da direita esta abaixo do limite superior da tela. Se sim, sua posicao eh alterada para cima. Se nao, nada acontece
		MOV		BX, word[raquete_y2_1]
		CMP		BX, 470
		JL		raquete_up
		RET

verify_upper_bound_2:	
		;Verifica se a raquete da esquerda esta abaixo do limite superior da tela. Se sim, sua posicao eh alterada para cima. Se nao, nada acontece	
		MOV		BX, word[raquete_y2_2]
		CMP		BX, 470
		JL		raquete_up_2
		RET

verify_lower_bound:	
		;Verifica se a raquete da direita esta acima do limite inferior da tela. Se sim, sua posicao eh alterada para baixo. Se nao, nada acontece		
		MOV		BX, word[raquete_y_1]
		CMP		BX, 5
		JG		raquete_down
		RET

verify_lower_bound_2:
		;Verifica se a raquete da esquerda esta acima do limite inferior da tela. Se sim, sua posicao eh alterada para baixo. Se nao, nada acontece
		MOV		BX, word[raquete_y_2]
		CMP		BX, 5
		JG		raquete_down_2
		RET

raquete_up:
		;Se a raquete da direita estiver abaixo do limite superior da tela e o usuario pressionou a seta para cima, a raquete tem sua posicao incrementada em 5
		MOV 	AX, word[raquete_1]
		ADD		AX, 5
		MOV 	word[raquete_1], AX
		JMP		raquete_draw

raquete_up_2:
		;Se a raquete da esquerda estiver abaixo do limite superior da tela e o usuario pressionou a tecla 'w', a raquete tem sua posicao incrementada em 5
		MOV 	AX, word[raquete_2]
		ADD		AX, 5
		MOV 	word[raquete_2], AX
		JMP		raquete_draw

raquete_down:
		;Se a raquete da esquerda estiver acima do limite inferior da tela e o usuario pressionou a seta para baixo, a raquete tem sua posicao decrementada em 5
		MOV 	AX, word[raquete_1]
		SUB		AX, 5
		MOV 	word[raquete_1], AX
		JMP		raquete_draw

raquete_down_2:
		;Se a raquete da direita estiver acima do limite inferior da tela e o usuario pressionou a tecla 's', a raquete tem sua posicao decrementada em 5
		MOV 	AX, word[raquete_2]
		SUB		AX, 5
		MOV 	word[raquete_2], AX
		JMP		raquete_draw

raquete_draw:	
		;Desenha raquetes em preto nas suas posicoes antigas, com o objetivo de apaga-las da tela
		MOV		byte[cor], pRETo
		CALL	raquete_1Fn
		CALL	raquete_2Fn
		
		;Desenha a raquete magenta em sua nova posicao
		MOV		BX, [raquete_1]
		ADD		BX, 220
		MOV		word[raquete_y_1], BX
		ADD		BX, 81
		MOV		word[raquete_y2_1], BX	
		MOV		byte[cor], magenta
		CALL	raquete_1Fn

		;Desenha a raquete azul em sua nova posicao
		MOV		BX, [raquete_2]
		ADD		BX, 220
		MOV		word[raquete_y_2], BX
		ADD		BX, 81
		MOV		word[raquete_y2_2], BX	
		MOV		byte[cor], azul_claro
		CALL	raquete_2Fn

		RET
;========================================== LOOP PRINCIPAL ==========================================

;========================================== PAUSE MENU ==========================================
;Funcao que escreve uma mensagem de pausa simples na tela e fica a espera de o usuario pressionar novamente a tecla 'p'
paused_menu:
		;Escreve a mensagem de pause na tela
    	MOV     CX,7				
    	MOV     BX,0
    	MOV     DH,14 			
    	MOV     DL,36				
		MOV		byte[cor],branco_intenso

l7:
		CALL	cursor
    	MOV     AL,[BX+paused_mens]
		CALL	caracter
    	INC     BX					
		INC		DL					
    	LOOP    l7

        CALL    debounce

;Verifica se o usuario pressionou a tecla 'p'
wait_paused_menu:
        MOV     AH, [pressed_keys+4]
		CMP		AH, 49
		;Se nao, fica travado em loop esperando por essa acao do usuario
		JNE		wait_paused_menu	
		;Se sim, retoma o jogo
		JMP		quit_pause

quit_pause:
		;Apaga a mensagem de pausa da tela, sobrescrevendo-a com preto
        MOV     CX,7				
    	MOV     BX,0
    	MOV     DH,14				
    	MOV     DL,36				
		MOV		byte[cor],pRETo

l8:
		CALL	cursor
    	MOV     AL,[BX+paused_mens]
		CALL	caracter
    	INC     BX					
		INC		DL					
    	LOOP    l8

		;Faz um delay de debounce para dar tempo de o usuario retirar o dedo da tecla ate entao pressionada
        CALL    debounce

        RET
;========================================== PAUSE MENU ==========================================

;========================================== QUIT MENU ==========================================
;Funcao que escreve uma mensagem de quit simples na tela e fica a espera da decisao do usuario de finalizar ou nao o jogo
exit_menu:
		;Escreve a mensagem de quit, perguntando ao usuario se ele realmente deseja finalizar o jogo
    	MOV     CX,22				
    	MOV     BX,0
    	MOV     DH,14				
    	MOV     DL,30				
		MOV		byte[cor],branco_intenso
l4:
		CALL	cursor
    	MOV     AL,[BX+mens_exit]
		CALL	caracter
    	INC     BX					
		INC		DL					
	
    	LOOP    l4

		;Faz um delay de debounce para dar tempo de o usuario retirar o dedo da tecla ate entao pressionada
        CALL    debounce

wait_exit_input:
		;Verifica se o usuario pressionou a tecla 'y' (no caso, se ele decidiu encerrar o jogo)
		MOV     AH, [pressed_keys+5]
        CMP     AH, 49
		JE      exit

		;Verifica se o usuario pressionou a tecla 'n' (no caso, se ele decidiu nao encerrar o jogo)
		MOV     AH, [pressed_keys+6]
        CMP     AH, 49
		JE      clear_exit_screen

		;Se nenhuma das teclas foi pressionada, volta o loop e fica a espera da decisao do usuario
		JMP     wait_exit_input          

clear_exit_screen:
		;Apaga a mensagem de quit da tela, sobrescrevendo-a com preto
    	MOV     CX,22				;número de caracteres
    	MOV     BX,0
    	MOV     DH,14				;linha 0-29
    	MOV     DL,30				;coluna 0-79
		MOV		byte[cor],pRETo
l5:
		CALL	cursor
    	MOV     AL,[BX+mens_exit]
		CALL	caracter
    	INC     BX					
		INC		DL					
	
    	LOOP    l5

		;Faz um delay de debounce para dar tempo de o usuario retirar o dedo da tecla ate entao pressionada
		CALL    debounce

        RET
;========================================== QUIT MENU ==========================================

;========================================== EXIT ==========================================
;Realiza a finalizacao do programa
exit:	
		;Desinstala a interrupcao INT 9h e restaura os valores originais
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
		
		;Sai do modo grafico
		MOV  	AH,0   				; set video mode
	    MOV  	AL,[modo_anterior] 	; modo anterior
	    INT  	10h

		;Finaliza o programa
		MOV     AX,4C00h
		INT     21h
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

vel				dw		10		;Velocidade da bolinha
posX			dw		320		;Posicao da bolinha no eixo X
posY			dw		240		;Posicao da bolinha no eixo Y
dirX			dw		0		;Direcao atual da bolinha no eixo X
dirY			dw		0		;Direcao atual da bolinha no eixo Y

raquete_1		dw		0		
raquete_2		dw		0		

paused_mens		db 		'Pausado'	;Mensagem de pausa

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
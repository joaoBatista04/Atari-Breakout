; versão de 10/05/2007
; corrigido erro de arredondamento na rotina line.
; circle e full_circle DISPonibilizados por JEfferson Moro em 10/2009
; 
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
		
;Menu inicial do jogo
		CALL intro_menu

;Desenhar Retas
draw_lines:
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

next_rect:
		MOV		AX, word[obstacle_y]
		ADD		AX, 96
		MOV		word[obstacle_y], AX

		MOV		AX, word[obstacle_y2]
		ADD		AX, 96
		MOV		word[obstacle_y2], AX
		RET

walls:	MOV		word[obstacle_x], 5
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

inicializa_raquetes:
		MOV		byte[cor], magenta
		CALL	raquete_1Fn

		MOV		byte[cor], azul_claro
		CALL	raquete_2Fn
		JMP ver_off

jump_to_game_over:
	CALL game_over
	JMP	check_raquete

ver_off:
		MOV		AH, 0Bh
		INT 	21h
		CMP		AL, 0

		JNE		off
		JMP		print_ball

off:	MOV    	AH,08h
		INT     21h
		CMP		AL, 'q'
		JE		exit_menu
		CMP 	AL, 'p'
		JE 		paused_menu
		CMP		AL, 'o'
		JE		jump_to_game_over
		JMP 	check_raquete

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

wait_exit_input:
		; Esperar entrada do usuário
		MOV     AH, 08h
		INT     21h
		CMP     AL, 'y'
		JE      exit
		CMP     AL, 'n'
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

		JMP		print_ball

exit:	
		MOV  	AH,0   				; set video mode
	    MOV  	AL,[modo_anterior] 	; modo anterior
	    INT  	10h
		MOV     AX,4C00h
		INT     21h

print_ball:
		MOV		byte[cor], pRETo
		MOV		AX, word[posX]
		PUSH 	AX
		MOV		AX, word[posY]
		PUSH	AX
		MOV		AX, 10
		PUSH 	AX
		CALL	circle
		CALL	DirXY
		JMP		draw

paused_menu:
		;Escrever uma mensagem
    	MOV     CX,7				;número de caracteres
    	MOV     BX,0
    	MOV     DH,14 			;linha 0-29
    	MOV     DL,36				;coluna 0-79
		MOV		byte[cor],branco_intenso

l7:
		CALL	cursor
    	MOV     AL,[BX+paused_mens]
		CALL	caracter
    	INC     BX					;proximo caracter
		INC		DL					;avanca a coluna
    	LOOP    l7

wait_paused_menu:
		MOV    	AH,08h
		INT     21h
		CMP		AL, 'p'
		JNE		wait_paused_menu	
		JMP		quit_pause

quit_pause:
	;Escrever uma mensagem
    	MOV     CX,7				;número de caracteres
    	MOV     BX,0
    	MOV     DH,14				;linha 0-29
    	MOV     DL,36				;coluna 0-79
		MOV		byte[cor],pRETo

l8:
		CALL	cursor
    	MOV     AL,[BX+paused_mens]
		CALL	caracter
    	INC     BX					;proximo caracter
		INC		DL					;avanca a coluna
    	LOOP    l8

		JMP check_raquete

check_raquete:
		CMP		AL, 'w'
		JE		verify_upper_bound
		CMP		AL, 's'
		JE		verify_lower_bound
		CMP		AL, 72 ; Código de scan da seta para cima
		JE		verify_upper_bound_2
		CMP		AL, 80 ; Código de scan da seta para baixo
		JE		verify_lower_bound_2

		JMP		print_ball

verify_upper_bound:		
		MOV		BX, word[raquete_y2_1]
		CMP		BX, 470
		JL		raquete_up
		JMP		print_ball

verify_upper_bound_2:		
		MOV		BX, word[raquete_y2_2]
		CMP		BX, 470
		JL		raquete_up_2
		JMP		print_ball

verify_lower_bound:		
		MOV		BX, word[raquete_y_1]
		CMP		BX, 5
		JG		raquete_down
		JMP		print_ball

verify_lower_bound_2:		
		MOV		BX, word[raquete_y_2]
		CMP		BX, 5
		JG		raquete_down_2
		JMP		print_ball

raquete_up:
		MOV 	AX, word[raquete_1]
		ADD		AX, 10
		MOV 	word[raquete_1], AX
		JMP		raquete_draw

raquete_up_2:
		MOV 	AX, word[raquete_2]
		ADD		AX, 10
		MOV 	word[raquete_2], AX
		JMP		raquete_draw

raquete_down:
		MOV 	AX, word[raquete_1]
		SUB		AX, 10
		MOV 	word[raquete_1], AX
		JMP		raquete_draw

raquete_down_2:
		MOV 	AX, word[raquete_2]
		SUB		AX, 10
		MOV 	word[raquete_2], AX
		JMP		raquete_draw

raquete_draw:	
		MOV		byte[cor], pRETo
		CALL	raquete_1Fn
		CALL	raquete_2Fn
		
		MOV		BX, [raquete_1]
		ADD		BX, 5
		MOV		word[raquete_y_1], BX
		ADD		BX, 81
		MOV		word[raquete_y2_1], BX	
		MOV		byte[cor], magenta
		CALL	raquete_1Fn

		MOV		BX, [raquete_2]
		ADD		BX, 5
		MOV		word[raquete_y_2], BX
		ADD		BX, 81
		MOV		word[raquete_y2_2], BX	
		MOV		byte[cor], azul_claro
		CALL	raquete_2Fn

		JMP		print_ball
draw:
		MOV		byte[cor], verde
		MOV		AX, word[posX]
		PUSH 	AX
		MOV		AX, word[posY]
		PUSH	AX
		MOV		AX, 10
		PUSH 	AX
		CALL	circle

		CALL	delay

		JMP		ver_off
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

raquete_y_1		dw		5
raquete_y2_1	dw		86

raquete_y_2		dw		5
raquete_y2_2	dw		86

vel				dw		10
posX			dw		320
posY			dw		240
dirX			dw		0
dirY			dw		0

raquete_1		dw		0
raquete_2		dw		0

paused_mens		db 		'Pausado'

;*************************************************************************
segment stack stack
	resb	512
stacktop:

; versão de 10/05/2007
; corrigido erro de arredondamento na rotina line.
; circle e full_circle DISPonibilizados por JEfferson Moro em 10/2009
; 
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
		
;Desenhar Retas
		MOV		byte[cor],branco_intenso	;antenas
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

		MOV		byte[cor], verde
		MOV		word[obstacle_x], 5
		MOV		word[obstacle_x2], 30
		MOV		word[obstacle_y], 5
		MOV		word[obstacle_y2], 86
		
		MOV		CX, 5
walls:	CALL	rectangle
		LOOP 	walls

		MOV		byte[cor], azul_claro
		MOV		word[obstacle_x], 605
		MOV		word[obstacle_x2], 630
		MOV		word[obstacle_y], 5
		MOV		word[obstacle_y2], 86
		
		MOV		CX, 5
walls2:	CALL	rectangle
		LOOP 	walls2

inicializa_raquetes:
		MOV		byte[cor], rosa
		CALL	raquete_1Fn

		MOV		byte[cor], rosa
		CALL	raquete_2Fn

ver_off:
		MOV		AH, 0Bh
		INT 	21h
		CMP		AL, 0

		JNE		off
		JMP		print_ball

off:	MOV    	AH,08h
		INT     21h
		CMP		AL, 'p'
		JNE		check_raquete

		JMP 	sai

sai:	
		MOV  	AH,0   				; set video mode
	    MOV  	AL,[modo_anterior] 	; modo anterior
	    INT  	10h
		MOV     AX,4C00h
		INT     21h

check_raquete:
		CMP		AL, 'w'
		JE		verify_upper_bound

		CMP		AL, 's'
		JE		verify_lower_bound

		CMP		AL, 'r'
		JE		verify_upper_bound_2

		CMP		AL, 'f'
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
		MOV		byte[cor], rosa
		CALL	raquete_1Fn

		MOV		BX, [raquete_2]
		ADD		BX, 5
		MOV		word[raquete_y_2], BX
		ADD		BX, 81
		MOV		word[raquete_y2_2], BX	
		MOV		byte[cor], rosa
		CALL	raquete_2Fn

		JMP		print_ball

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

draw:
		MOV		byte[cor], vermelho
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
mens    		db  	'Funcao Grafica'

obstacle_y		dw		5
obstacle_y2		dw		86
obstacle_x		dw		5
obstacle_x2		dw		30

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
;*************************************************************************
segment stack stack
	resb	512
stacktop:

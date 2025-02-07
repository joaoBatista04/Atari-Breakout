global raquete_1Fn
global raquete_2Fn
global check_raquete

extern raquete_y_1
extern raquete_y2_1 
extern raquete_y_2
extern raquete_y2_2
extern line

;Funcao para desenhar a primeira raquete
raquete_1Fn:
            ;Desenha o limite direito da raquete
            MOV		AX, 35
            PUSH	AX
            MOV		AX, [raquete_y_1]
            PUSH	AX
            MOV		AX, 35
            PUSH	AX
            MOV		AX, [raquete_y2_1]
            PUSH	AX
            CALL	line

            ;Desenha o limite superior da raquete
            MOV		AX, 35
            PUSH	AX
            MOV		AX, [raquete_y2_1]
            PUSH	AX
            MOV		AX, 60
            PUSH    AX
            MOV   	AX, [raquete_y2_1]
            PUSH 	AX
            CALL	line

            ;Desenha o limite esquerdo da raquete
            MOV		AX, 60
            PUSH	AX
            MOV		AX, [raquete_y_1]
            PUSH	AX
            MOV		AX, 60
            PUSH    AX
            MOV   	AX, [raquete_y2_1]
            PUSH 	AX
            CALL	line

            ;Desenha o limite inferior da raquete
            MOV		AX, 60
            PUSH	AX
            MOV		AX, [raquete_y_1]
            PUSH	AX
            MOV		AX, 35
            PUSH    AX
            MOV   	AX, [raquete_y_1]
            PUSH 	AX
            CALL	line
            RET

;Funcao para desenhar a primeira raquete
raquete_2Fn:
            ;Desenha o limite direito da raquete
            MOV		AX, 575
            PUSH	AX
            MOV		AX, [raquete_y_2]
            PUSH	AX
            MOV		AX, 575
            PUSH	AX
            MOV		AX, [raquete_y2_2]
            PUSH	AX
            CALL	line

            ;Desenha o limite superior da raquete
            MOV		AX, 575
            PUSH	AX
            MOV		AX, [raquete_y2_2]
            PUSH	AX
            MOV		AX, 600
            PUSH    AX
            MOV   	AX, [raquete_y2_2]
            PUSH 	AX
            CALL	line

            ;Desenha o limite esquerdo da raquete
            MOV		AX, 600
            PUSH	AX
            MOV		AX, [raquete_y_2]
            PUSH	AX
            MOV		AX, 600
            PUSH    AX
            MOV   	AX, [raquete_y2_2]
            PUSH 	AX
            CALL	line

            ;Desenha o limite inferior da raquete
            MOV		AX, 600
            PUSH	AX
            MOV		AX, [raquete_y_2]
            PUSH	AX
            MOV		AX, 575
            PUSH    AX
            MOV   	AX, [raquete_y_2]
            PUSH 	AX
            CALL	line
            RET
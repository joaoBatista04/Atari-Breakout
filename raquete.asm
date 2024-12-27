global raquete_1Fn
global raquete_2Fn
global check_raquete

extern raquete_y_1
extern raquete_y2_1 
extern raquete_y_2
extern raquete_y2_2
extern line

raquete_1Fn:
            MOV		AX, 35
            PUSH	AX
            MOV		AX, [raquete_y_1]
            PUSH	AX
            MOV		AX, 35
            PUSH	AX
            MOV		AX, [raquete_y2_1]
            PUSH	AX
            CALL	line

            MOV		AX, 35
            PUSH	AX
            MOV		AX, [raquete_y2_1]
            PUSH	AX
            MOV		AX, 60
            PUSH    AX
            MOV   	AX, [raquete_y2_1]
            PUSH 	AX
            CALL	line

            MOV		AX, 60
            PUSH	AX
            MOV		AX, [raquete_y_1]
            PUSH	AX
            MOV		AX, 60
            PUSH    AX
            MOV   	AX, [raquete_y2_1]
            PUSH 	AX
            CALL	line

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

raquete_2Fn:
            MOV		AX, 575
            PUSH	AX
            MOV		AX, [raquete_y_2]
            PUSH	AX
            MOV		AX, 575
            PUSH	AX
            MOV		AX, [raquete_y2_2]
            PUSH	AX
            CALL	line

            MOV		AX, 575
            PUSH	AX
            MOV		AX, [raquete_y2_2]
            PUSH	AX
            MOV		AX, 600
            PUSH    AX
            MOV   	AX, [raquete_y2_2]
            PUSH 	AX
            CALL	line

            MOV		AX, 600
            PUSH	AX
            MOV		AX, [raquete_y_2]
            PUSH	AX
            MOV		AX, 600
            PUSH    AX
            MOV   	AX, [raquete_y2_2]
            PUSH 	AX
            CALL	line

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
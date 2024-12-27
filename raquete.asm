global raquete

extern obstacle_y
extern obstacle_y2
extern line

raquete:
            MOV		AX, 35
            PUSH	AX
            MOV		AX, [obstacle_y]
            PUSH	AX
            MOV		AX, 35
            PUSH	AX
            MOV		AX, [obstacle_y2]
            PUSH	AX
            CALL	line

            MOV		AX, 35
            PUSH	AX
            MOV		AX, [obstacle_y2]
            PUSH	AX
            MOV		AX, 60
            PUSH    AX
            MOV   	AX, [obstacle_y2]
            PUSH 	AX
            CALL	line

            MOV		AX, 60
            PUSH	AX
            MOV		AX, [obstacle_y]
            PUSH	AX
            MOV		AX, 60
            PUSH    AX
            MOV   	AX, [obstacle_y2]
            PUSH 	AX
            CALL	line

            MOV		AX, 60
            PUSH	AX
            MOV		AX, [obstacle_y]
            PUSH	AX
            MOV		AX, 35
            PUSH    AX
            MOV   	AX, [obstacle_y]
            PUSH 	AX
            CALL	line
            RET
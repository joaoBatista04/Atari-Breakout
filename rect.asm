global rectangle
extern line
extern obstacle_x
extern obstacle_x2
extern obstacle_y
extern obstacle_y2

rectangle:
            MOV		AX, [obstacle_x]
            PUSH	AX
            MOV		AX, [obstacle_y]
            PUSH	AX
            MOV		AX, [obstacle_x]
            PUSH	AX
            MOV		AX, [obstacle_y2]
            PUSH	AX
            CALL	line

            MOV		AX, [obstacle_x]
            PUSH	AX
            MOV		AX, [obstacle_y2]
            PUSH	AX
            MOV		AX, [obstacle_x2]
            PUSH    AX
            MOV   	AX, [obstacle_y2]
            PUSH 	AX
            CALL	line

            MOV		AX, [obstacle_x2]
            PUSH	AX
            MOV		AX, [obstacle_y]
            PUSH	AX
            MOV		AX, [obstacle_x2]
            PUSH    AX
            MOV   	AX, [obstacle_y2]
            PUSH 	AX
            CALL	line

            MOV		AX, [obstacle_x2]
            PUSH	AX
            MOV		AX, [obstacle_y]
            PUSH	AX
            MOV		AX, [obstacle_x]
            PUSH    AX
            MOV   	AX, [obstacle_y]
            PUSH 	AX
            CALL	line

            MOV		AX, word[obstacle_y]
            ADD		AX, 96
            MOV		word[obstacle_y], AX

            MOV		AX, word[obstacle_y2]
            ADD		AX, 96
            MOV		word[obstacle_y2], AX
            RET
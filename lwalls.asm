extern obstacle_x
extern obstacle_x2
extern obstacle_y
extern obstacle_y2
extern cor
extern full_rectangle
extern on_obstacles_left
extern dirX
extern dirY
extern posY

global verifyLeft

verifyLeft:
		CALL	verify_wall_1
		CALL	verify_wall_2
		CALL	verify_wall_3
		CALL	verify_wall_4
		CALL	verify_wall_5
		RET

verify_wall_1:
		MOV		AX, [posY]
		CMP		AX, 5
		JG		.verify_wall_1_left
		JMP		.return_fn
		.verify_wall_1_left:
		MOV		AX, [posY]
		CMP		AX, 100
		JB		.verify_if_wall_is_on
		MOV		word[dirX], 1
		JMP		.return_fn

		.verify_if_wall_is_on:
		MOV		AH, byte[on_obstacles_left]
		CMP		AH, 49
		JE		.apaga_wall
		MOV		word[dirX], 0
		JMP		.return_fn
		
		.apaga_wall:
		MOV		byte[on_obstacles_left], 48
		MOV		word[dirX], 1
		MOV		word[obstacle_x], 605
		MOV		word[obstacle_x2], 630
		MOV		word[obstacle_y], 5
		MOV		word[obstacle_y2], 86

		MOV		byte[cor], 0
		CALL	full_rectangle	

		.return_fn:
		RET

verify_wall_2:
		MOV		AX, [posY]
		CMP		AX, 101
		JG		.verify_wall_2_left
		JMP		.return_fn
		.verify_wall_2_left:
		MOV		AX, [posY]
		CMP		AX, 182
		JB		.verify_if_wall_is_on_2
		MOV		word[dirX], 1
		JMP		.return_fn

		.verify_if_wall_is_on_2:
		MOV		AH, byte[on_obstacles_left+1]
		CMP		AH, 49
		JE		.apaga_wall_2
		MOV		word[dirX], 0
		JMP		.return_fn
		
		.apaga_wall_2:
		MOV		byte[on_obstacles_left+1], 48
		MOV		word[dirX], 1
		MOV		word[obstacle_x], 605
		MOV		word[obstacle_x2], 630
		MOV		word[obstacle_y], 101
		MOV		word[obstacle_y2], 182

		MOV		byte[cor], 0
		CALL	full_rectangle	

		.return_fn:
		RET

verify_wall_3:
		MOV		AX, [posY]
		CMP		AX, 183
		JG		.verify_wall_3_left
		JMP		.return_fn
		.verify_wall_3_left:
		MOV		AX, [posY]
		CMP		AX, 278
		JB		.verify_if_wall_is_on_3
		MOV		word[dirX], 1
		JMP		.return_fn

		.verify_if_wall_is_on_3:
		MOV		AH, byte[on_obstacles_left+2]
		CMP		AH, 49
		JE		.apaga_wall_3
		MOV		word[dirX], 0
		JMP		.return_fn
		
		.apaga_wall_3:
		MOV		byte[on_obstacles_left+2], 48
		MOV		word[dirX], 1
		MOV		word[obstacle_x], 605
		MOV		word[obstacle_x2], 630
		MOV		word[obstacle_y], 197
		MOV		word[obstacle_y2], 278

		MOV		byte[cor], 0
		CALL	full_rectangle	

		.return_fn:
		RET

verify_wall_4:
		MOV		AX, [posY]
		CMP		AX, 279
		JG		.verify_wall_4_left
		JMP		.return_fn
		.verify_wall_4_left:
		MOV		AX, [posY]
		CMP		AX, 374
		JB		.verify_if_wall_is_on_4
		MOV		word[dirX], 1
		JMP		.return_fn

		.verify_if_wall_is_on_4:
		MOV		AH, byte[on_obstacles_left+3]
		CMP		AH, 49
		JE		.apaga_wall_4
		MOV		word[dirX], 0
		JMP		.return_fn
		
		.apaga_wall_4:
		MOV		byte[on_obstacles_left+3], 48
		MOV		word[dirX], 1
		MOV		word[obstacle_x], 605
		MOV		word[obstacle_x2], 630
		MOV		word[obstacle_y], 293
		MOV		word[obstacle_y2], 374

		MOV		byte[cor], 0
		CALL	full_rectangle	

		.return_fn:
		RET

verify_wall_5:
		MOV		AX, [posY]
		CMP		AX, 375
		JG		.verify_wall_5_left
		JMP		.return_fn
		.verify_wall_5_left:
		MOV		AX, [posY]
		CMP		AX, 480
		JB		.verify_if_wall_is_on_5
		MOV		word[dirX], 1
		JMP		.return_fn

		.verify_if_wall_is_on_5:
		MOV		AH, byte[on_obstacles_left+4]
		CMP		AH, 49
		JE		.apaga_wall_5
		MOV		word[dirX], 0
		JMP		.return_fn
		
		.apaga_wall_5:
		MOV		byte[on_obstacles_left+4], 48
		MOV		word[dirX], 1
		MOV		word[obstacle_x], 605
		MOV		word[obstacle_x2], 630
		MOV		word[obstacle_y], 389
		MOV		word[obstacle_y2], 470

		MOV		byte[cor], 0
		CALL	full_rectangle	

		.return_fn:
		RET
global key_handler

;========================================== TRATAMENTO DE INTERRUPCOES ==========================================
key_handler:
			;Salva o contexto dos registradores
			PUSH    ES
			PUSH    AX
			PUSH    BX
			MOV     AX, ds
			MOV     es, AX	
			IN      al, 60h

			;Faz a leitura do teclado por meio da chamada da interrupcao
			MOV     BH, AL
			IN      AL, 061h       
			MOV     BL, AL
			OR      AL, 080h
			OUT     061h, AL     
			MOV     AL, BL
			OUT     061h, AL 
			MOV     AL, BH
			
			;Se nenhuma tecla dentro do range de valores make/break foi pressionada, retorna. Se nao, verifica se a tecla em questao foi pressionada ou despressionada
			CMP     AL, 0e0h
			JZ      .ignore
			MOV     AH, 0
			MOV     BX, AX
			and     BL, 01111111b
			and     AL, 10000000b
			CMP     AL, 10000000b
			JZ      .key_released_jmp
		
		;Se a tecla foi pressionada, verifica qual delas sofreu a acao
		.key_pressed:
			;Seta para cima
			CMP     BL, 72
            JE      .set_key_1
			;Seta para baixo
            CMP     BL, 80
            JE      .set_key_2
			;Tecla 'w'
            CMP     BL, 17
            JE      .set_key_3
			;Tecla 's'
            CMP     BL, 31
            JE      .set_key_4
			;Tecla 'p'
            CMP     BL, 25
            JE      .set_key_5
			;Tecla 'y'
            CMP     BL, 21
            JE      .set_key_6
			;Tecla 'n'
            CMP     BL, 49
            JE      .set_key_7
			;Tecla 'q'
            CMP     BL, 16
            JE      .set_key_8
			;Tecla Enter
            CMP     BL, 28
            JE      .set_key_9
			;Se nenhuma das teclas acima foi pressionada, retorna
			JMP     .ignore

        .ignore:
            ;Atende a interrupcao, restura os registradores e retorna
			MOV     AL, 20h
			OUT     20h, AL
			POP     BX
			POP     AX
			POP     ES
			IRET 

		;Label auxiliar para fazer jump condicional para o tratamento de tecla sendo despressionada
        .key_released_jmp:
            JMP     .key_released

		;A partir daqui, verifica a tecla pressionada e coloca o valor '1' (49) no vetor de teclas pressionadas, na respectiva posicao
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

		;Se a interrupcao foi gerada por uma tecla sendo despressionada, o trecho seguinte de codigo eh acionada
		.key_released:
			;Seta para cima
			CMP     BL, 72
            JE      .unset_key_1
			;Tecla para baixo
            CMP     BL, 80
            JE      .unset_key_2
			;Tecla 'w'
            CMP     BL, 17
            JE      .unset_key_3
			;Tecla 's'
            CMP     BL, 31
            JE      .unset_key_4
			;Tecla 'p'
            CMP     BL, 25
            JE      .unset_key_5
			;Tecla 'y'
            CMP     BL, 21
            JE      .unset_key_6
			;Tecla 'n'
            CMP     BL, 49
            JE      .unset_key_7
			;Tecla 'q'
            CMP     BL, 16
            JE      .unset_key_8
			;Tecla Enter
            CMP     BL, 28
            JE      .unset_key_9
			;Se nenhuma das teclas acima foi despressionada, retorna
            JMP     .ignore2

        .ignore2:
			;Atende a interrupcao, restura os registradores e retorna
            MOV     AL, 20h
			OUT     20h, AL
			POP     BX
			POP     AX
			POP     ES
			IRET 

			;A partir daqui, verifica a tecla despressionada e coloca o valor '0' (48) no vetor de teclas pressionadas, na respectiva posicao
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
;========================================== TRATAMENTO DE INTERRUPCOES ==========================================
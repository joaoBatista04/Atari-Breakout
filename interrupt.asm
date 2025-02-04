global key_handler

;========================================== TRATAMENTO DE INTERRUPCOES ==========================================
key_handler:
			PUSH    ES			
			PUSH    AX			
			PUSH    BX			
			MOV     AX, ds				;Coloca o segmento de dados em AX
			MOV     es, AX				;Coloca o segmento de dados em ES
			IN      al, 60h				;Lê a porta 60h

			MOV     BH, AL				;Salva AL em BH
			IN      AL, 061h    		;Lê a porta 61h
			MOV     BL, AL				;Salva AL em BL
			OR      AL, 080h			;Liga o bit 7
			OUT     061h, AL    		;Escreve na porta 61h
			MOV     AL, BL				;Coloca BL em AL
			OUT     061h, AL 			;Escreve na porta 61h
			MOV     AL, BH				;Coloca BH em AL
			
			CMP     AL, 0e0h			;Verifica se a tecla foi pressionada
			JZ      .ignore				;Se não foi, ignora
			MOV     AH, 0				;Se foi, coloca 0 em AH
			MOV     BX, AX				;Coloca AX em BX
			and     BL, 01111111b		
			and     AL, 10000000b
			CMP     AL, 10000000b
			JZ      .key_released_jmp	;Se a tecla foi solta, pula para key_released
		
		.key_pressed:
			CMP     BL, 72				;Verifica se a tecla UP foi pressionada
            JE      .set_key_1			;Se foi, pula para set_key_1

            CMP     BL, 80				;Verifica se a tecla DOWN foi pressionada
            JE      .set_key_2			;Se foi, pula para set_key_2

            CMP     BL, 17				;Verifica se a tecla W foi pressionada
            JE      .set_key_3			;Se foi, pula para set_key_3

            CMP     BL, 31				;Verifica se a tecla S foi pressionada
            JE      .set_key_4			;Se foi, pula para set_key_4

            CMP     BL, 25				;Verifica se a tecla P foi pressionada
            JE      .set_key_5			;Se foi, pula para set_key_5

            CMP     BL, 21				;Verifica se a tecla Y foi pressionada
            JE      .set_key_6			;Se foi, pula para set_key_6

            CMP     BL, 49				;Verifica se a tecla N foi pressionada
            JE      .set_key_7			;Se foi, pula para set_key_7	

            CMP     BL, 16				;Verifica se a tecla Q foi pressionada
            JE      .set_key_8			;Se foi, pula para set_key_8

            CMP     BL, 28				;Verifica se a tecla ENTER foi pressionada
            JE      .set_key_9			;Se foi, pula para set_key_9
			
			JMP     .ignore				;Se não foi nenhuma das teclas, ignora

        .ignore:
            MOV     AL, 20h				;Coloca	20h em AL
			OUT     20h, AL				;Escreve em 20h
			POP     BX
			POP     AX
			POP     ES
			IRET 						;Retorna da interrupção

        .key_released_jmp:
            JMP     .key_released		;Pula para key_released

        .set_key_1:
            MOV     byte[pressed_keys], 49		;Coloca 1 em pressed_keys (UP)
            JMP     .ignore						;Pula para ignore

        .set_key_2:
            MOV     byte[pressed_keys+1], 49	;Coloca 1 em pressed_keys+1 (DOWN)
            JMP     .ignore						;Pula para ignore

        .set_key_3:
            MOV     byte[pressed_keys+2], 49	;Coloca 1 em pressed_keys+2 (W)
            JMP     .ignore						;Pula para ignore

        .set_key_4:
            MOV     byte[pressed_keys+3], 49	;Coloca 1 em pressed_keys+3 (S)
            JMP     .ignore						;Pula para ignore

        .set_key_5:
            MOV     byte[pressed_keys+4], 49	;Coloca 1 em pressed_keys+4 (P)
            JMP     .ignore						;Pula para ignore

        .set_key_6:
            MOV     byte[pressed_keys+5], 49	;Coloca 1 em pressed_keys+5 (Y)
            JMP     .ignore						;Pula para ignore

        .set_key_7:
            MOV     byte[pressed_keys+6], 49	;Coloca 1 em pressed_keys+6 (N)
            JMP     .ignore						;Pula para ignore

        .set_key_8:
            MOV     byte[pressed_keys+7], 49	;Coloca 1 em pressed_keys+7 (Q)
            JMP     .ignore						;Pula para ignore

        .set_key_9:
            MOV     byte[pressed_keys+8], 49	;Coloca 1 em pressed_keys+8 (ENTER)
            JMP     .ignore						;Pula para ignore


		.key_released:

			CMP     BL, 72						;Verifica se a tecla UP foi solta
            JE      .unset_key_1				;Se foi, pula para unset_key_1

            CMP     BL, 80						;Verifica se a tecla DOWN foi solta
            JE      .unset_key_2				;Se foi, pula para unset_key_2

            CMP     BL, 17						;Verifica se a tecla W foi solta
            JE      .unset_key_3				;Se foi, pula para unset_key_3

            CMP     BL, 31						;Verifica se a tecla S foi solta
            JE      .unset_key_4				;Se foi, pula para unset_key_4

            CMP     BL, 25						;Verifica se a tecla P foi solta
            JE      .unset_key_5				;Se foi, pula para unset_key_5

            CMP     BL, 21						;Verifica se a tecla Y foi solta
            JE      .unset_key_6				;Se foi, pula para unset_key_6

            CMP     BL, 49						;Verifica se a tecla N foi solta
            JE      .unset_key_7				;Se foi, pula para unset_key_7

            CMP     BL, 16						;Verifica se a tecla Q foi solta
            JE      .unset_key_8				;Se foi, pula para unset_key_8

            CMP     BL, 28						;Verifica se a tecla ENTER foi solta
            JE      .unset_key_9				;Se foi, pula para unset_key_9

            JMP     .ignore2					;Se não foi nenhuma das teclas, ignora

        .ignore2:
            MOV     AL, 20h						;Coloca 20h em AL
			OUT     20h, AL						;Escreve em 20h
			POP     BX
			POP     AX
			POP     ES
			IRET 								;Retorna da interrupção

        .unset_key_1:
            MOV     byte[pressed_keys], 48		;Coloca 0 em pressed_keys (UP)
            JMP     .ignore2					;Pula para ignore2

        .unset_key_2:
            MOV     byte[pressed_keys+1], 48	;Coloca 0 em pressed_keys+1 (DOWN)
            JMP     .ignore2					;Pula para ignore2

        .unset_key_3:
            MOV     byte[pressed_keys+2], 48	;Coloca 0 em pressed_keys+2 (W)
            JMP     .ignore2					;Pula para ignore2

        .unset_key_4:
            MOV     byte[pressed_keys+3], 48	;Coloca 0 em pressed_keys+3 (S)
            JMP     .ignore2					;Pula para ignore2

        .unset_key_5:
            MOV     byte[pressed_keys+4], 48	;Coloca 0 em pressed_keys+4 (P)
            JMP     .ignore2					;Pula para ignore2

        .unset_key_6:
            MOV     byte[pressed_keys+5], 48	;Coloca 0 em pressed_keys+5 (Y)
            JMP     .ignore2					;Pula para ignore2

        .unset_key_7:
            MOV     byte[pressed_keys+6], 48	;Coloca 0 em pressed_keys+6 (N)
            JMP     .ignore2					;Pula para ignore2

        .unset_key_8:
            MOV     byte[pressed_keys+7], 48	;Coloca 0 em pressed_keys+7 (Q)
            JMP     .ignore2					;Pula para ignore2

        .unset_key_9:
            MOV     byte[pressed_keys+8], 48	;Coloca 0 em pressed_keys+8 (ENTER)
            JMP     .ignore2					;Pula para ignore2
;========================================== TRATAMENTO DE INTERRUPCOES ==========================================
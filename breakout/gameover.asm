global game_over

extern cor		
extern mens_game
extern mens_new
extern mens_over		
extern mens_dificil	
extern facil_line_pos	
extern facil_col_pos	
extern medio_line_pos	
extern medio_col_pos	
extern dif_line_pos	
extern dif_col_pos		
extern select_arrow	
extern arrow_col_pos
extern arrow_line_pos
extern cursor
extern caracter
extern vel
extern modo_anterior
extern pressed_keys
extern exit

game_over:

 ; Escrever a mensagem (Gostaria de iniciar uma nova partida? y/n)
        MOV     CX, 41              ; Número de caracteres
        MOV     BX, 0
        MOV     DH, 15              ; Linha 0-29
        MOV     DL, 20               ; Coluna 0-79

        MOV AL, 0x0F          ;Cor branco intenso
        MOV byte [cor], AL
    l3:
        CALL	cursor
        MOV     AL, [BX + mens_new]
        CALL	caracter
        INC     BX                  ; Próximo caractere
        INC     DL                  ; Avança a coluna
        LOOP    l3

    loop_colors:
        ; Primeira cor (branco)
        MOV     AL, 0x0F           ; Cor branca intensa
        MOV byte [cor], AL
        CALL    write_game
        CALL    write_over
        CALL    wait_500ms

        MOV     AH, [pressed_keys+5]
        CMP     AH, 49
        JE      ret_call

        MOV     AH, [pressed_keys+6]
        CMP     AH, 49
        JE      exit_call
    loop_colors2:
        ; Segunda cor (amarelo)
        MOV     AL, 0x0E           ; Cor amarela
        MOV byte [cor], AL
        CALL    write_game
        CALL    write_over
        CALL    wait_500ms

        MOV     AH, [pressed_keys+5]
        CMP     AH, 49
        JE      ret_call

        MOV     AH, [pressed_keys+6]
        CMP     AH, 49
        JE      exit_call
    loop_colors3:
        ; Terceira cor (verde)
        MOV     AL, 0x02           ; Cor verde
        MOV byte [cor], AL
        CALL    write_game
        CALL    write_over
        CALL    wait_500ms

        MOV     AH, [pressed_keys+5]
        CMP     AH, 49
        JE      ret_call

        MOV     AH, [pressed_keys+6]
        CMP     AH, 49
        JE      exit_call
    loop_colors4:
        ; Quarta cor (vermelho)
        MOV     AL, 0x04           ; Cor vermelha
        MOV byte [cor], AL
        CALL    write_game
        CALL    write_over
        CALL    wait_500ms

        MOV     AH, [pressed_keys+5]
        CMP     AH, 49
        JE      ret_call

        MOV     AH, [pressed_keys+6]
        CMP     AH, 49
        JE      exit_call

        JMP     loop_colors   

exit_call:
        CALL    exit

ret_call:
        ;Apaga a mensagem (Gostaria de iniciar uma nova partida? y/n)
        MOV     CX, 41              ; Número de caracteres
        MOV     BX, 0
        MOV     DH, 15              ; Linha 0-29
        MOV     DL, 20               ; Coluna 0-79

        MOV     AL, 0x00          ;Cor preta
        MOV     byte [cor], AL
    apaga_msg:
        CALL	cursor
        MOV     AL, [BX + mens_new]
        CALL	caracter
        INC     BX                  ; Próximo caractere
        INC     DL                  ; Avança a coluna
        LOOP    apaga_msg

        ;Apaga texto de game over
        MOV     AL, 0x00           ; Cor preta
        MOV     byte [cor], AL
        CALL    write_game
        CALL    write_over

        RET

write_game:
    ; Escrever a mensagem (GAME)
        MOV     CX, 4              ; Número de caracteres
        MOV     BX, 0
        MOV     DH, 12              ; Linha 0-29
        MOV     DL, 38               ; Coluna 0-79

        
    l1:
        CALL	cursor
        MOV     AL, [BX + mens_game]
        CALL	caracter
        INC     BX                  ; Próximo caractere
        INC     DL                  ; Avança a coluna
        LOOP    l1
        
        RET        
write_over:
; Escrever a mensagem (OVER)
        MOV     CX, 4              ; Número de caracteres
        MOV     BX, 0
        MOV     DH, 13              ; Linha 0-29
        MOV     DL, 38               ; Coluna 0-79

    l2:
        CALL	cursor
        MOV     AL, [BX + mens_over]
        CALL	caracter
        INC     BX                  ; Próximo caractere
        INC     DL                  ; Avança a coluna
        LOOP    l2

        RET

wait_500ms:
    MOV     AX, 0x8600         ; Função para esperar
    MOV     CX, 0x0000         ; 0 milissegundos
    MOV     DX,  0xDE00         ; ~500 milissegundos
    INT     15h
    RET
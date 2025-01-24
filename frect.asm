global full_rectangle
extern line
extern obstacle_x
extern obstacle_x2
extern obstacle_y
extern obstacle_y2

full_rectangle:
    ; Salvar os registradores que serão usados
    PUSH    AX
    PUSH    BX
    PUSH    CX
    PUSH    DX
    PUSH    SI
    PUSH    DI

    ; Inicializar as coordenadas do retângulo
    MOV     AX, [obstacle_x]    ; X inicial
    MOV     BX, [obstacle_x2]   ; X final
    MOV     CX, [obstacle_y]    ; Y inicial
    MOV     DX, [obstacle_y2]   ; Y final

fill_loop:
    CMP     CX, DX              ; Verificar se o Y inicial ultrapassou o Y final
    JG      end_fill            ; Se ultrapassou, terminar

    ; Desenhar uma linha horizontal no nível atual de Y
    PUSH    AX                  ; X inicial
    PUSH    CX                  ; Y atual
    PUSH    BX                  ; X final
    PUSH    CX                  ; Y atual
    CALL    line

    ; Incrementar Y para a próxima linha
    INC     CX
    JMP     fill_loop           ; Repetir para a próxima linha

end_fill:
    ; Restaurar os registradores
    POP     DI
    POP     SI
    POP     DX
    POP     CX
    POP     BX
    POP     AX
    RET

[BITS 16]
[ORG 100h]

msg_mask   DB "IRQ1 enmascarado (teclado deshabilitado)...$"
msg_unmask DB 0Dh,0Ah,"IRQ1 restaurado.$"

start:

; Leer IMR actual
    IN AL, 21h
    PUSH AX

; Enmascarar IRQ1
    OR AL, 02h
    OUT 21h, AL

; Mostrar mensaje
    MOV AH, 09h
    MOV DX, msg_mask
    INT 21h

; Esperar ~3 segundos
    MOV AH, 00h
    INT 1Ah

    MOV BX, DX
    ADD BX, 55

wait_loop:
    MOV AH, 00h
    INT 1Ah

    CMP DX, BX
    JL wait_loop

; Restaurar IMR original
    POP AX
    OUT 21h, AL

; Mostrar restauración
    MOV AH, 09h
    MOV DX, msg_unmask
    INT 21h

; Salir
    MOV AH, 4Ch
    INT 21h
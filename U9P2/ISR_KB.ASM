[BITS 16]
[ORG 100h]

section .data
contador DW 0
MAX_KEYS EQU 5

old_isr DD 0

msg_tecla DB 0Dh,0Ah,"Tecla detectada por ISR propio$"
msg_fin DB 0Dh,0Ah,"ISR restaurado. Fin del programa.$"

section .text

start:

; Guardar vector original INT 09h
    MOV AX, 3509h
    INT 21h

    MOV [old_isr], BX
    MOV [old_isr+2], ES

; Instalar ISR propio
    PUSH DS

    MOV AX, CS
    MOV DS, AX

    MOV DX, mi_isr

    MOV AX, 2509h
    INT 21h

    POP DS

    STI

esperar:
    MOV AX, [contador]
    CMP AX, MAX_KEYS
    JL esperar

; Restaurar ISR original
    CLI

    LDS DX, [old_isr]

    MOV AX, 2509h
    INT 21h

    STI

    MOV AH, 09h
    MOV DX, msg_fin
    INT 21h

    MOV AH, 4Ch
    INT 21h

; ---------- ISR ----------
mi_isr:

    PUSH AX
    PUSH DX
    PUSH DS

    MOV AX, CS
    MOV DS, AX

; Leer scancode
    IN AL, 60h

; Mostrar mensaje
    MOV AH, 09h
    MOV DX, msg_tecla
    INT 21h

; Incrementar contador
    INC WORD [contador]

; EOI al PIC
    MOV AL, 20h
    OUT 20h, AL

    POP DS
    POP DX
    POP AX

    IRET
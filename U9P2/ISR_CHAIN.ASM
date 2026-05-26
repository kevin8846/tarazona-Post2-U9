[BITS 16]
[ORG 100h]

section .data

contador DW 0
old_isr DD 0

msg DB 0Dh,0Ah,"Tecla registrada por ISR_CHAIN$"
msg_fin DB 0Dh,0Ah,"ISR_CHAIN finalizado.$"

section .text

start:

; Obtener ISR original
    MOV AX, 3509h
    INT 21h

    MOV [old_isr], BX
    MOV [old_isr+2], ES

; Instalar nuevo ISR
    PUSH DS

    MOV AX, CS
    MOV DS, AX

    MOV DX, mi_isr_chain

    MOV AX, 2509h
    INT 21h

    POP DS

    STI

; Esperar varias teclas
wait_keys:
    MOV AX, [contador]
    CMP AX, 5
    JL wait_keys

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

; -------- ISR encadenado --------
mi_isr_chain:

    PUSH AX
    PUSH DX
    PUSH DS

    MOV AX, CS
    MOV DS, AX

; Mensaje propio
    MOV AH, 09h
    MOV DX, msg
    INT 21h

; Contador
    INC WORD [contador]

    POP DS
    POP DX
    POP AX

; Encadenar ISR original
    PUSHF
    CALL FAR [old_isr]

    IRET
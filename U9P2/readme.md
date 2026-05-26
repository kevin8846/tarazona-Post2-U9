# PostContenido 2 - Unidad 9
KEVIN ALEJANDRO TARAZONA MARTINEZ - 1152297
## Arquitectura de Computadores

### Objetivo

Implementar Rutinas de Servicio de Interrupción (ISR) personalizadas en ensamblador x86 utilizando NASM y DOSBox, manipulando el PIC 8259A y el IRQ1 del teclado.

---

# Prerrequisitos

- DOSBox 0.74 o superior
- NASM 2.x
- Editor de texto
- Carpeta de trabajo montada en DOSBox

---

# Programas desarrollados

## 1. ISR_KB.ASM

Instala un ISR personalizado para IRQ1 (teclado), detecta 5 teclas y luego restaura el handler original.

### Compilación

```bash
nasm -f bin ISR_KB.ASM -o ISR_KB.COM

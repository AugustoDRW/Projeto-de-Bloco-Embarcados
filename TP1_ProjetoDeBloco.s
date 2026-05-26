.global _start
.section .text

_start:
    mov w1,#138
    //Alocando espaco na pilha, sempre em multiplos de 16 bits
    sub sp, sp, #16

    //Salva o valor do volume na memoria
    strb w1, [sp]

    mov x2, sp          //Endereco da stack
    ldrb w3,[x2]

    //Restaura pilha
    add sp, sp, #16

    mov x0,#0
    mov x8,#93
    svc 0

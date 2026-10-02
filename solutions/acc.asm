; функция fibonacci acc32

.data
    .org 0x100
    input_addr:     .word 0x80          ; ввод
    output_addr:    .word 0x84          ; вывод
    a:              .word 0x00000000    ; переменная a
    b:              .word 0x00000001    ; переменная b
    n:              .word 0x00000000    ; переменная n
    i:              .word 0x00000002    ; счётчик
    tmp:            .word 0x00000000    ; переменная для обмена
    const:          .word 0x00000001    ; константа = 1

.text

_start:
    .org 0x200
    ; загружаем ввод
    load input_addr
    load_acc
    store n

    ; < 0
    bltz minus

    ; = 0
    beqz zero

    ; = 1
    sub const
    beqz one_result
    add const

; цикл
loop:
    ; делаем обмен
    load b
    store tmp
    
    ; проверка на переполнение
    add a
    bvs overflow
    store b

    load tmp
    store a

    ; i = n 
    load i
    sub n
    beqz finish

    ; i++
    load i
    add const
    store i

    jmp loop

finish:
    load b
    store_ind output_addr
    halt

minus:
    load_imm 0xFFFFFFFF
    store_ind output_addr
    halt

zero:
    load_imm 0x00000000
    store_ind output_addr
    halt

one_result:
    load_imm 0x00000001
    store_ind output_addr
    halt

overflow:
    load_imm 0xCCCCCCCC
    store_ind output_addr
    halt
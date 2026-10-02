; функция big_to_little_endian risc-v-32

; sp - адрес вершины стека
; ra - адрес возврата из функции
; a0 - число на вход, затем младший байт, в конце результат
; t0 - регистр адресов result, input_adr, output_adr
; t2 - значение маски
; t3 - адрес маски
; s0 - оставшаяся часть исходного числа
; s1 - собираемый результат
; s2 - количество оставшихся байтов

.data
    .org 0x100
    mask:       .word 0x000000FF
    result:     .word 0x00000000

    input_adr:  .word 0x80
    output_adr: .word 0x84

.text
    .org 0x200

_start:
    lui sp, %hi(0x1000)
    addi sp, sp, %lo(0x1000)

    ; адрес input_adr сохраним в t0
    lui t0, %hi(input_adr)
    addi t0, t0, %lo(input_adr)

    ; считаем адрес 0x80, затем число по этому адресу
    lw t0, 0(t0)
    lw a0, 0(t0)

    ; вызов процедуры перестановки байтов
    jal ra, reverse_bytes

    ; адрес result сохраним в t0
    lui t0, %hi(result)
    addi t0, t0, %lo(result)

    ; сохраним результат
    sw a0, 0(t0)

    ; адрес output_adr сохраним в t0
    lui t0, %hi(output_adr)
    addi t0, t0, %lo(output_adr)

    ; сохранение в 0x84
    lw t0, 0(t0)
    sw a0, 0(t0)
    
    halt


; аргумент и результат в a0
reverse_bytes:
    ; выделим в стеке место для четырёх регистров
    addi sp, sp, -16

    ; сохраним адрес возврата и прежние значения регистров
    sw ra, 12(sp)
    sw s0, 8(sp)
    sw s1, 4(sp)
    sw s2, 0(sp)

    ; исходное число сохраним в s0
    addi s0, a0, 0

    ; обнулим результат
    addi s1, zero, 0

    ; обработать нужно четыре байта
    addi s2, zero, 4

reverse_loop:
    ; передадим оставшуюся часть числа в get_byte
    addi a0, s0, 0
    jal ra, get_byte

    ; сдвинем результат на восемь бит влево, добавим полученный байт, ; уберём обработанный байт из исходного числа
    slli s1, s1, 8
    or s1, s1, a0
    srli s0, s0, 8

    ; уменьшим количество оставшихся байтов, результат сохраним в a0
    addi s2, s2, -1
    bne s2, zero, reverse_loop
    addi a0, s1, 0

    ; восстановим прежние значения регистров и адрес возврата
    lw s2, 0(sp)
    lw s1, 4(sp)
    lw s0, 8(sp)
    lw ra, 12(sp)

    ; jосвобождение выделенного места
    addi sp, sp, 16
    jr ra


; аргумент и результат в a0
get_byte:
    ; адрес маски сохраним в t3
    lui t3, %hi(mask)
    addi t3, t3, %lo(mask)

    ; считаем маску в t2, оставим младшие восемь бит, вернемся в reverse_bytes
    lw t2, 0(t3)
    and a0, a0, t2
    jr ra
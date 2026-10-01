; функция big_to_little_endian risc-iv-32

; s1 - адрес result
; s3 - адрес input_adr
; s4 - адрес output_adr

; t1 - наше число на вход
; t2 - регистр для масок
; t3 - регистр адресов масок

.data
    .org 0x100
    mask1:      .word   0x000000FF
    mask2:      .word   0x0000FF00
    mask3:      .word   0x00FF0000
    mask4:      .word   0xFF000000
    result:     .word   0x00000000

    input_adr:  .word   0x80
    output_adr: .word   0x84

.text
    .org 0x200

_start:
    ; адрес result сохраним в s1
    lui s1, %hi(result)
    addi s1, s1, %lo(result)

    ; адрес input_adr сохраним в s3
    lui s3, %hi(input_adr)
    addi s3, s3, %lo(input_adr)

    ; адрес output_adr сохраним в s4
    lui s4, %hi(output_adr)
    addi s4, s4, %lo(output_adr)

    ; считаем данные из 0x80 (input_adr) и сохраним в регистр t1
    lw t1, 0(s3)
    lw t1, 0(t1)

    ; кладем адрес маски
    lui t3, %hi(mask1)
    addi t3, t3, %lo(mask1)

    ; первые 8 бит
    lw t2, 0(t3)
    and t2, t1, t2
    slli t2, t2, 24
    sw t2, 0(s1)

    ; вторые 8 бит
    lui t3, %hi(mask2)
    addi t3, t3, %lo(mask2)

    lw t2, 0(t3)
    and t2, t1, t2
    slli t2, t2, 8
    lw t3, 0(s1)
    add t2, t3, t2
    sw t2, 0(s1)

    ; третьи 8 бит
    lui t3, %hi(mask3)
    addi t3, t3, %lo(mask3)

    lw t2, 0(t3)
    and t2, t1, t2
    srli t2, t2, 8
    lw t3, 0(s1)
    add t2, t3, t2
    sw t2, 0(s1)

    ; четвёртые 8 бит
    lui t3, %hi(mask4)
    addi t3, t3, %lo(mask4)

    lw t2, 0(t3)
    and t2, t1, t2
    srli t2, t2, 24
    lw t3, 0(s1)
    add t2, t3, t2
    sw t2, 0(s1)

    ; сохранение в 0x84 (output_adr)
    lw t2, 0(s1)
    lw s4, 0(s4)
    sw t2, 0(s4)

    halt
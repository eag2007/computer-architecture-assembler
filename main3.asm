; функция glob_match m68k

.data
    .org 0x100
    
    pattern:         .byte   '--------------------------------'
    text:            .byte   '--------------------------------'

    input_adr:       .word   0x80
    output_adr:      .word   0x84
    index_pattern:   .word   0x0
    index_text:      .word   0x0      
    star:            .byte   '*'
    question:        .byte   '?'

.text
    .org 0x200

_start:
    ; адрес начала стека
    movea.l 0x1000, A7

    ; кладем адрес ввода в A0, адрес буффера pattern в A1
    movea.l input_adr, A0
    movea.l (A0), A0
    movea.l 0x100, A1

    jsr readline

    ; кладем адрес ввода в A0, адрес буфера text в A1
    movea.l input_adr, A0
    movea.l (A0), A0
    movea.l 0x120, A1

    jsr readline

    ; начинается маска
    move.l 0x100, D0
    move.l 0x120, D1

    jsr match

    movea.l output_adr, A3
    movea.l (A3), A3
    move.l D7, (A3)

    jmp hlt

readline:
    ; count и флаг (overflow)
    clr.l D1

read_loop:
    ; читаем символ
    move.b (A0), D3

    ; если символ  == \n
    cmp.b 0x0a, D3
    beq read_finish

    ; если символов больше чем 31
    cmp.l 31, D1
    bge overflow

    ; запишем символ
    move.b D3, (A1)+

    ; count++ 
    add.l 1, D1

    jmp read_loop

match:
    ; A0 - указатель на pattern A1 - указатель на text
    ; D2 - элемент pattern, D3 - элемент text
    movea.l D0, A0
    movea.l D1, A1

    ; достаем текущие элементы pattern, text
    move.b (A0), D2
    move.b (A1), D3

    ; if p == ""
    cmp.b 0, D2
    beq pattern_is_empty

    ; if p[0] == "*"
    movea.l star, A2
    cmp.b (A2), D2
    beq match_star

    ; if t == ""
    cmp.b 0, D3
    beq text_is_empty

    ; if p[0] == "?"
    movea.l question, A2
    cmp.b (A2), D2
    beq match_next

    ; if p[0] == t[0]
    cmp.b D2, D3
    beq match_next

    jmp match_false

match_star:
    link A6, -8

    move.l D0, -4(A6)
    move.l D1, -8(A6)

    add.l 1, D0

    jsr match

    move.l -4(A6), D0
    move.l -8(A6), D1

    unlk A6

    ; if match(p[1:], t) -> 1
    cmp.l 1, D7
    beq match_true

    ; if t != ""
    movea.l D1, A1
    move.b (A1), D3

    cmp.b 0, D3
    beq match_false

    add.l 1, D1
    jsr match
    rts

text_is_empty:
    jmp match_false

match_next:
    add.l 1, D0
    add.l 1, D1
    jsr match
    rts

pattern_is_empty:
    cmp.b 0, D3
    beq match_true
    jmp match_false

match_true:
    move.l 1, D7
    rts

match_false:
    move.l 0, D7
    rts

read_finish:
    ; записываем 0 как конец строки
    move.b 0x0, (A1)+
    rts

overflow:       
    movea.l output_adr, A3
    movea.l (A3), A3
    move.l 0xcccccccc, (A3)
    jmp hlt

hlt:
    halt
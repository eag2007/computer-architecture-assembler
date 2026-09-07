.data
    .org 0x0
    buffer1:    .word 0x5f5f5f5f
    buffer2:    .word 0x5f5f5f5f
    buffer3:    .word 0x5f5f5f5f
    buffer4:    .word 0x5f5f5f5f
    buffer5:    .word 0x5f5f5f5f
    buffer6:    .word 0x5f5f5f5f
    buffer7:    .word 0x5f5f5f5f
    buffer8:    .word 0x5f5f5f5f


.text
    .org 0x100

_start:
    \ a = 0 переменная указывающая на ссылки
    0
    a!

    loop ;


loop:
    \ загрузка значения символа 0x80
    @p 0x80

    dup

    \ проверка на \n
    0x0a
    inv
    1
    +
    +

    if stop_symbol


    dup

    \ проверка на overflow
    a
    31
    inv
    1
    +
    +

    if overflow


    dup

    \ проверка на < 0x61
    inv
    1
    +
    0x60
    +

    -if success_char


    dup

    \ проверка на > 0x7a
    0x7b
    inv
    1
    +
    +

    -if success_char


    \ из lower case в upper case
    0x20
    inv
    1
    +
    +

    success_char ;

\ отсеиваем символ (младшие 8 бит)
success_char:
    @

    0xffffff00
    and

    xor

    !+

    loop ;


\ запись стоп символа в буфер
stop_symbol:
    \ убираем \n
    drop

    \ записываем 0 в конец строки
    0
    \ кладем с стек
    @

    0xffffff00
    and

    xor

    !+

    \ возвращаемся в начало буфера
    0
    a!

    output ;

\ вывод буфера
output:
    @+

    0xff
    and

    dup

    if end

    \ выводим символ
    !p 0x84

    output ;

\ завершение
end:
    drop

    halt

\ обработка overflow
overflow:
    \ убираем символ со стека
    drop

    0xCCCCCCCC

    !p 0x84

    halt
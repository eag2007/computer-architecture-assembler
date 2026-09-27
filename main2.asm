.data
    .org 0x0
    buffer1:    .word   0x5f5f5f5f
    buffer2:    .word   0x5f5f5f5f
    buffer3:    .word   0x5f5f5f5f
    buffer4:    .word   0x5f5f5f5f
    buffer5:    .word   0x5f5f5f5f
    buffer6:    .word   0x5f5f5f5f
    buffer7:    .word   0x5f5f5f5f
    buffer8:    .word   0x5f5f5f5f

    input_adr:  .word   0x80
    output_adr: .word   0x84

    end_symbol: .word   0x0a
    lower_edge: .word   0x60
    upper_edge: .word   0x7b
    delta:      .word   0x20
    mask_and:   .word   0xffffff00
    mask_out:   .word   0x000000ff
    over_out:   .word   0xcccccccc

.text
    .org 0x200

_start:
    lit 0x0
    a!
    loop ;

loop:
    read_char
    dup

    @p end_symbol
    inv
    1
    +
    +
    if stop_symbol


    a
    31
    inv
    1
    +   
    +
    if stop_overflow

    dup

    inv
    1
    +
    @p lower_edge
    +
    -if success_char

    dup

    @p upper_edge
    inv
    1
    +
    +
    -if success_char 

    @p delta
    inv
    1
    +
    +

    success_char ;


read_char:
    @p input_adr
    b!
    @b
    ;

stop_symbol:
    drop

    0
    @
    @p mask_and
    and
    xor
    !+

    0
    a!
    output ;

stop_overflow:
    drop

    @p over_out
    @p output_adr
    b!
    !b
    halt

success_char:
    store_char
    loop ;

store_char:
    @
    @p mask_and
    and

    xor
    !+
    ;

output:
    @+
    @p mask_out
    and

    dup
    if end

    @p output_adr
    b!

    !b
    output ;

end:
    drop
    halt
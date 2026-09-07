.data
    .org 0x100

    is_upper:   .word 0x0
    is_lower:   .word 0x0

    input_addr: .word 0x80
    output_addr: .word 0x84

    end:        .word 0x00
    flag:       .word 0x0a

    min_lower:  .word 0x61
    max_lower:  .word 0x7a

    min_upper:  .word 0x41
    max_upper:  .word 0x5a

    delta:      .word 0x20

    none:       .word 0x0a

.text

_start:
    loop ;

loop:
    @p input_addr
    a!
    @
    a!

    check_none

    \ если a >= 0x61 тоесть lower
    a
    0xFFFFFF9F
    +
    -if left_lower_big

    \ если a <= 0x7a тоесть lower
    a
    0xFFFFFF85
    +
    -if right_lower_small

    write
    loop ;

left_lower_big:
    a
    0xFFFFFFE0 \ -delta
    +
    a!
    write
    loop ;

right_lower_small:
    a
    0xFFFFFFE0 \ -delta
    +
    a!
    write
    loop ;

write:
    a
    !p output_addr
    ;

check_none:
    a
    0xFFFFFFF6
    +
    if hlt
    ;

hlt:
    halt
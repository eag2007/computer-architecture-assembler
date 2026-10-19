.data
input_addr:         .word   0x80
output_addr:        .word   0x84
i:                  .word   0x00
fnv32_prime:        .word   0x01000193
hash_value:         .word   0x811C9DC5

.text
.org 0x88

_start:
    lui a0, %hi(input_addr)            / lui a1, %hi(output_addr)           /                   /
    addi a0, a0, %lo(input_addr)       / addi a1, a1, %lo(output_addr)      /                   /

    lui a2, %hi(fnv32_prime)           / lui a3, %hi(hash_value)            / lw t1, 0(a0)      /
    addi a2, a2, %lo(fnv32_prime)      / addi a3, a3, %lo(hash_value)       / lw t2, 0(a1)      /
                                       /                                    / lw t3, 0(a2)      /
                                       /                                    / lw t3, 0(a2)      /
                                       /                                    / lw t4, 0(a3)      /
    addi t6, zero, 0xFF                /                                    / lw t4, 0(a3)      /

loop:
                                       /                                    / lb t5, 0(t1)      /
    and t5, t5, t6                     /                                    /                   / beqz t5, done
    xor t4, t4, t5                     /                                    /                   /
    mul t4, t4, t3                     /                                    /                   / j loop

done:
                                       /                                    / sw t4, 0(t2)      / halt
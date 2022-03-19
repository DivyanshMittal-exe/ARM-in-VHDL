@Code compatible with ARMSIM. The difference is that armsim has byte index, whereas we have word index
.equ SWI_Exit, 0x11
.text
    ldr r0, = AA
    mov r1,#4
    mov r2,#0
    mov r6,#170
    add r2,r2,r6
    add r2,r2,r6,LSL#8
    add r2,r2,r6,LSL#16
    add r2,r2,r6,LSL#24

    str r2,[r0],r1
    str r2,[r0,r1]!
    str r2,[r0,r1]

    strh r2,[r0],r1
    strh r2,[r0,r1]!
    strh r2,[r0,r1]

    strb r2,[r0],r1
    strb r2,[r0,r1]!
    strb r2,[r0,r1]

    ldr r0, = AA

    ldr r3,[r0],#4
    ldrb r4,[r0,#4]!
    ldrh r5,[r0,#4]

    ldr r0, = AA
    add r0,r0,#4

    ldrsb r4,[r0,#4]!
    ldrsh r5,[r0,#4]

.data
AA: .space 200
.end

@   Code in binary
@        0 => X"E3A00020",
@        1 => X"E3A01001",
@        2 => X"E3A02000",
@        3 => X"E3A060AA",
@        4 => X"E0822006",
@        5 => X"E0822406",
@        6 => X"E0822806",
@        7 => X"E0822C06",
@        8 => X"E6802001",
@        9 => X"E7A02001",
@        10 => X"E7802001",
@        11 => X"E08020B1",
@        12 => X"E1A020B1",
@        13 => X"E18020B1",
@        14 => X"E6C02001",
@        15 => X"E7E02001",
@        16 => X"E7C02001",
@        17 => X"E3A00020",
@        18 => X"E4903001",
@        19 => X"E5F04001",
@        20 => X"E1D050B1",
@        21 => X"E3A00021",
@        22 => X"E1F040D1",
@        23 => X"E1D050F1",

@   Code that the above binary represents
@.equ SWI_Exit, 0x11
@.text
@    mov r0,#32
@    mov r1,#1
@    mov r2,#0
@    mov r6,#170
@    add r2,r2,r6
@    add r2,r2,r6,LSL#8
@    add r2,r2,r6,LSL#16
@    add r2,r2,r6,LSL#24
@
@    str r2,[r0],r1
@    str r2,[r0,r1]!
@    str r2,[r0,r1]
@
@    strh r2,[r0],r1
@    strh r2,[r0,r1]!
@    strh r2,[r0,r1]
@
@    strb r2,[r0],r1
@    strb r2,[r0,r1]!
@    strb r2,[r0,r1]
@
@    mov r0,#32
@
@    ldr r3,[r0],#1
@    ldrb r4,[r0,#1]!
@    ldrh r5,[r0,#1]
@
@    mov r0,#33
@
@    ldrsb r4,[r0,#1]!
@    ldrsh r5,[r0,#1]
@
@.data
@AA: .space 200
@.end
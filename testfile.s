.equ SWI_Exit, 0x11
.text
    mov r0,#32
    mov r1,#1
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

    mov r0,#32

    ldr r3,[r0],#1
    ldrb r4,[r0,#1]!
    ldrh r5,[r0,#1]

    mov r0,#32

    ldrsb r4,[r0,#1]!
    ldrsh r5,[r0,#1]

.data
AA: .space 200
.end

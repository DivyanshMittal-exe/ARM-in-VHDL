.equ SWI_Exit, 0x11
.text
    mov r0, #800
    mov r1,#170
    mov r2,#4
    add r3, r0, r1, LSL #2
    add r4, r0, r1, LSR #2
    add r5, r0, r1, ASR #2
    add r6, r0, r1, ROR #2
    add r7, r0, r1, LSL r2
    add r8, r0, r1, LSR r2
    add r9, r0, r1, ASR r2
    add r10, r0, r1, ROR r2
    ldr r1, = AA                @To run in armsim, change it to ldr r1, = AA
    str r0, [r1,#8]
    ldr r11, [r1,#8]
    str r2, [r1, r2, LSL #1]
    ldr r12, [r1, r2, LSL #1]
.data
AA: .space 200
.end

        @; 1 => X"E3A010AA",
        @; 0 => X"E3A00E32",
        @; 2 => X"E3A02004",
        @; 3 => X"E0803101",
        @; 4 => X"E0804121",
        @; 5 => X"E0805141",
        @; 6 => X"E0806161",
        @; 7 => X"E0807211",
        @; 8 => X"E0808231",
        @; 9 => X"E0809251",
        @; 10 => X"E080A271",
        @; 11 => X"E3A01020",
        @; 12 => X"E5810006",
        @; 13 => X"E591B006",
        @; 14 => X"E7812082",
        @; 15 => X"E791B082",
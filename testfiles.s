.equ SWI_Exit, 0x11
.text
mov r0, #134
mov r0, #134
mov r1, #113
and r2,r0,r1
eor r2,r0,r1
sub r2,r0,r1
rsb r2,r0,r1
add r2,r0,r1
adc r2,r0,r1
sbc r2,r0,r1
rsc r2,r0,r1
tst r0,r1
teq r0,r1
cmp r0,r1
cmn r0,r1
orr r2,r0,r1
mov r0,r1
bic r2,r0,r1
mvn r0,r1
.data
.end

; 0 => x"E3A00086" ,
; 1 => x"E3A00086" ,
; 2 => x"E3A01071",
; 3 => x"E0002001",
; 4 => x"E0202001" ,
; 5 => x"E0402001" ,
; 6 => x"E0602001" ,
; 7 => x"E0802001" ,
; 8 => x"E0A02001" ,
; 9 => x"E0002001" ,
; 10 => x"E0E02001", 
; 11 => x"E1100001", 
; 12 => x"E1300001", 
; 13 => x"E1500001", 
; 14 => x"E1700001", 
; 15 => x"E1802001", 
; 16 => x"E1A00001", 
; 17 => x"E1C02001", 
; 18 => x"E1E00001", 

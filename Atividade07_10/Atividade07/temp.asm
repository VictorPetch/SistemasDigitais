.include "m328pdef.inc"
.org 0x0000
rjmp setup
.org 0x0004
rjmp Interruption

setup:
cbi DDRC, 4
cbi DDRC, 3
cbi DDRC, 2
cbi DDRC, 0
sbi DDRD, 1
sbi DDRD, 2
sbi DDRD, 3
sbi DDRD, 4
ldi r16, 0b00000010
sts EIMSK, r16
ldi r16, 0b00000111
sts PCMSK1, r16
ldi r16, 0b00000100
sts EICRA, r16
sei
jmp main

main:
sbi PORTD, 1
jmp main

Interruption:
sbi PORTD, 3
reti

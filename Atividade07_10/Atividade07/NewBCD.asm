.include "m328pdef.inc"
.org 0x0000
rjmp seila
seila:
	ldi r15,9
	out PORTD,r15
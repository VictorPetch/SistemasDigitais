.include "m328pdef.inc"
.org 0x0000
rjmp setup ; salte para init:
.org 0x0016
rjmp Interruption
delay:
	sbrs r22,0 ; Skip if bit 0 in r22 is set
	jmp delay
	ldi r22,0
	ret
setup:
	ldi r20,0b11111100
	out DDRD,r20
	ldi r20,0b00000111
	out DDRB,r20
	ldi r20,0
	out PORTB,r20
	sei ; Enable global interruption
	ldi r20,0b00000010
	sts TIMSK1,r20; Enable timer match A interrupt
	ldi r20,0b00000000 ;  OCR0A does nothing  and set mode normal
	sts TCCR1A, r20
	ldi r20, 0b00001101 ; Set clk select to clkIO/1024
	sts TCCR1B,r20
LightingUp:
	;Contagem do timer
	ldi r20,0b00000000
	ldi r21,0b01111111
	sts OCR1AH,r20
	sts OCR1AL,r21

	;Display 1
	sbi PORTB,1
	ldi r20,0b11111100 ; set to light up
	out PORTD,r20
	in r20, PORTB ; WARNING: bit 1 and 2 is the transistor pin. This need to be fixed
	ldi r21,0b00000001; Just work on bit 0 to change the display
	or r20,r21
	out PORTB,r20
	call delay
	cbi PORTB,15

	;Display 2
	sbi PORTB,2
	ldi r20,0b11111100 ; set to light up
	out PORTD,r20
	in r20,PORTB
	ldi r21,0b00000000; Just work on bit 0 to change the display
	or r20,r21
	out PORTB,r20
	call delay
	cbi PORTB,2

	jmp LightingUp
Interruption:
	ldi r22,0b00000001 ; Seta o bit 0 pra sair do delay
		reti


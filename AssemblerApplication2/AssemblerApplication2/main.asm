
.include "m328pdef.inc"
.org 0x0000
rjmp init ; salte para init:
outInit:
	sbi DDRD,2
	sbi DDRD,3
	sbi DDRD,4
	sbi DDRD,5
	sbi DDRD,6
	sbi DDRD,7

adcInit:
	ldi r16,0b01100000 ; bits 6 and 7 to enable Vref. Bit 5 to left adjustment.
					   ; bit 4 reserved. bit 3-0 to ADC0
	sts ADMUX,r16
	ldi r16,0b10000111 ; first bit to enable adc. second to start.
	sts ADCSRA,r16
	ret
adcRead:
	ldi r16, 0b01000000
	lds r17, ADCSRA; Isso pra setar apenas o segundo bit pra 1
	or r17,r16
	sts ADCSRA,r17
	ret
adcWait:
	lds r17,ADCSRA
	sbrs r17,4 ; bit 4(ADIF) mostra se a conversao acabou.
	jmp adcWait ; Se ADIF ==1, ele pula esse jump
	ldi r16, 0b00010000
	lds r17,ADCSRA
	or r17,r16
	sts ADCSRA,r17
	ret
init:
	call adcInit
	call outInit
main:
	call adcRead
	call adcWait
	lds r18,ADCL
	lds r19,ADCH
	;	ldi r21, 0b00011100	
	;out PORTD,r19
	cpi r19,50; 11001101
	brsh setbit1
	cbi PORTD,2
	jmp main
setbit1:
	sbi PORTD,2
	cpi r19,100; 11001101
	brsh setbit2
	cbi PORTD,3
	jmp main	
setbit2:
	sbi PORTD,3
	cpi r19,150
	brsh setbit3
	cbi PORTD,4
	jmp main
setbit3:
	sbi PORTD,4
	cpi r19,200
	brsh setbit4
	cbi PORTD,5
	jmp main
setbit4:
	sbi PORTD,5
	jmp main

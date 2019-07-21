

.include "m328pdef.inc"
.org 0x0000
rjmp AnalogSetup
.def AnalogReg = r18
.def rmp = r16
adcInit:
	ldi r16,0b01100000 ; bit 3-0 to ADC0	    
	sts ADMUX,r16
	ldi r16,0b10000111 ; 
	sts ADCSRA,r16
	ret
adcRead:
	ldi r16, 0b01000000
	lds r17, ADCSRA; Isso pra setar apenas o segundo bit pra 1 sem mudar o resto
	or r17,r16
	sts ADCSRA,r17
	ret	
adcWait:
	lds r17,ADCSRA
	sbrs r17,4  ; Bit 4(ADIF) mostra se a conversao acabou.
	jmp adcWait ; Se ADIF ==1, ele pula esse jump
				; Terminou a conversão
	ldi r16, 0b00010000
	lds r17,ADCSRA
	or r17,r16
	sts ADCSRA,r17
	ret
AnalogSetup:
	call adcInit ; LSB
	call adcRead
	call adcWait
	lds AnalogReg,ADCH ; Recebe 8 valores
PWM:
	; Init output pin OC0A
	sbi DDRD,6 ; OC0A as output

	; PWM compare value to timer 0 match A
	;ldi r16, 5 ; Quanto menor, mais potente
	out OCR0A,AnalogReg ; 

	; Timer 0 in Fast PWM mode, output A low at cycle start
	ldi rmp,(1<<COM0A1)|(1<<COM0A0)|(1<<WGM01)|(1<<WGM00)
	out TCCR0A,rmp 

	; Start Timer 0 with prescaler = 1
	ldi rmp,1<<CS00 
	out TCCR0B,rmp 

jmp AnalogSetup 
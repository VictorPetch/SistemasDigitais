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
	sbi DDRB,0
	sbi DDRB,1
	;ldi r16,0b10001000
	;sts CLKPR,r16
	;sbi SREG,7 ; Enable global interruption
	sbi TIMSK0,1; Enable timer match A interrupt
	ldi r20,0b00000000 ;  OCR0A does nothing  and set mode normal
	sts TCCR1A, r20
	ldi r20, 0b00001101 ; Set clk select to clkIO/1024
	sts TCCR1B,r20
adcInitA0:
	ldi r16,0b01100000 ; bits 6 and 7 to enable Vref. Bit 5 to ADLAR.
					   ; bit 4 reserved. bit 3-0 to ADC0t
	sts ADMUX,r16
	ldi r16,0b10000111 ; first bit to enable adc. second to start.
	sts ADCSRA,r16
	ret
adcInitA1:
	ldi r16,0b01100001 ; bit 3-0 to ADC1
					    
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

init:
	call outInit ; Seta os pinos de saida (2 to 9) e a interrupção	
main:
	call adcInitA0 ; LSB
	call adcRead
	call adcWait
	lds r18,ADCH ; Recebe 8 valores
	call adcInitA1 ; MSB
	call adcRead
	call adcWait
	lds r19,ADCH ; Recebe 8 valores
	cpi r19,240 ; if A1 > 240, jmp to Triangle
	brsh Triangle
	cpi r18,240 ; if A0 > 240, jmp to Saw
	brsh Saw ; else go to Square
Square:
	ldi r20,0b11111111
	sts OCR1AH,r20
	sts OCR1AL,r20
	ldi r20, 0b11111100 ; Por causa do tx e rx
	ldi r21, 0b00000011 ; Apenas os bits 8 e 9
	out PORTD,r20
	out PORTB,r21

	timerWait:
		in r20,TIFR1
		sbrs r20,1 ; bit 1 mostra se deu overflow
		jmp timerWait ;

	in r20,TIFR1
	ldi r21,0b00000010
	or r20,r21
	out TIFR1,r20

	ldi r20, 0b00000000 ; Por causa do tx e rx
	ldi r21, 0b00000000 ; Apenas os bits 8 e 9
	out PORTD,r20
	out PORTB,r21

	timerWait2:
		in r20,TIFR1
		sbrs r20,1 ; bit 1 mostra se deu overflow
		jmp timerWait2 ;

	in r20,TIFR1
	ldi r21,0b00000010	
	or r20,r21
	out TIFR1,r20

jmp main
Triangle:
	ldi r20,0b11111111
	sts OCR1AH,r20
	sts OCR1AL,r20
	lds r20,TCNT1L
	out PORTD,r20
	timerWait4:
		in r20,TIFR1
		sbrs r20,1 ; bit 1 mostra se deu overflow
		jmp timerWait4 ;
	in r20,TIFR1
	ldi r21,0b00000010
	or r20,r21
	out TIFR1,r20
jmp main
Saw:
	ldi r20,0b11111111
	ldi r21,0b11111111
	sts OCR1AH,r20
	sts OCR1AL,r20
	
	timerWait3:
		lds r20,TCNT1L
		out PORTD,r20
		in r20,TIFR1
		sbrs r20,1 ; bit 1 mostra se deu overflow
		jmp timerWait3 ;

	seila:
	ldi r20,0
	out PORTD,r20
	jmp seila

	
	
	in r20,TIFR1
	ldi r21,0b00000010
	or r20,r21
	out TIFR1,r20
jmp main
	




	
.include "m328pdef.inc"
.org 0x0000
rjmp init ; salte para init:
.org 0x0016
rjmp Interruption
.org 0x001A
rjmp TriangleInterruption

outInit:
	ldi r20,0b11111100
	out DDRD,r20
	ldi r20,0b00000011
	out DDRB,r20
	sei ; Enable global interruption
	ldi r20,0b00000010
	sts TIMSK1,r20; Enable timer match A interrupt
	ldi r20,0b00000000 ;  OCR0A does nothing  and set mode normal
	sts TCCR1A, r20
	ldi r20, 0b00001101 ; Set clk select to clkIO/1024
	sts TCCR1B,r20
	ldi r22,0
adcInitA0:
	ldi r16,0b01100000 ; bits 6 and 7 to enable Vref. Bit 5 to ADLAR.
					   ; bit 4 reserved. bit 3-0 to ADC0t
	sts ADMUX,r16
	ldi r16,0b10000111' ; first bit to enable adc. second to start.
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

waitSquare:
	sbrs r22,0 ; Skip if bit 0 in r20 is set
	jmp waitSquare
	ldi r22,0
	ret
waitSaw:
	
	lds r20,TCNT1L
	lds r21,TCNT1H
	out PORTD,r21
	out PORTB,r21
	sbrs r22,0
	jmp waitSaw
	ldi r22,0
	ret
waitTriangle:
	lds r20,TCNT1L
	lds r21,TCNT1H
	out PORTD,r21
	out PORTB,r21
	sbrs r22,0
	jmp waitTriangle
	ldi r22,0
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
	;Contagem do timer

	ldi r20,0b11111111
	ldi r21,0b11111111
	sts OCR1AH,r20
	sts OCR1AL,r21

	
	;Set 1 na saida
	ldi r20, 0b11111100 ; Por causa do tx e rx
	ldi r21, 0b00000011 ; Apenas os bits 8 e 9
	out PORTD,r20
	out PORTB,r21

	call waitSquare ; Loop até interrupção ocorrer no bit 0 do r22


	;Set 0 na saida
	ldi r20, 0 
	ldi r21, 0  
	out PORTD,r20
	out PORTB,r21

	call waitSquare

jmp main

Saw:
	;Contagem do timer
	ldi r20,0b11111111
	ldi r21,0b11111111
	sts OCR1AH,r20
	sts OCR1AL,r21
	out PORTD,r20
	delay:
		jmp delay
	call waitSaw

jmp main
Triangle:
	ldi r20, 0b00000011 ;  set mode to phase correction
	sts TCCR1A,r20
	ldi r20, 0b00010101 ; Set mode to phase correction
	sts TCCR1B,r20
	ldi r20,0b00000001
	sts TIMSK1,r20; Enable overflow interrupt because of phase correction mode
	;Set counter top
	ldi r20,0b11111111
	ldi r21,0b11111111
	sts OCR1AH,r20
	sts OCR1AL,r21
	call waitTriangle
jmp main

Interruption:
	cpi r18,240 ; if A0 >= 240, jmp to Saw
	brsh IntSaw ; else go to Square
	IntSquare:
		ldi r22,0b00000001 ; Seta o bit 0 pra sair do waitSquare
		reti
	IntSaw:
		ldi r22,0b00000001 ; Seta o bit 0 pra sair do waitSaw
		reti
	
		
TriangleInterruption:
		ldi r22,0b00000001 ; Seta o bit 0 pra sair do waitTriangle
		reti



	
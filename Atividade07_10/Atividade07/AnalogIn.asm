
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
main:
	call adcInitA0 ; LSB
	call adcRead
	call adcWait
	lds r16,ADCH ; Recebe 8 valores
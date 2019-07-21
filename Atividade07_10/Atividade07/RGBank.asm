.include "m328pdef.inc"
.org 0x0000
rjmp setup
.org 0x0016
rjmp CounterInterruption
.def bankflag = r16
.def Counterflag = r22
.def SoUmNumero = r24
delayquick:
	clr r17
	clr r18
	ldi r19,4
	jmp delay_loop
delaymed:
	clr r17
	clr r18
	ldi r19,15
	jmp delay_loop
delayslow:
	clr r17 ; defina r17 para 0
	clr r18 ; defina r18 para 0
	ldi r19, 30 ; defina r19 para 10
delay_loop:
	dec r18 ; decremente r18
	brne delay_loop ; salte para delay_loop se r18 n~ao ´e 0
	dec r17 ; decremente r17
	brne delay_loop ; salte para delay_loop se r17 n~ao ´e 0
	dec r19 ; decrament r19
	brne delay_loop ; salte para delay_loop se r19 n~ao ´e 0
	ret ; retorne

LightWhite:
	ldi r20,0b00011100 ; Liga branco
	out PORTD,r20
	call delayslow
	ldi r20,0 ; Desliga
	out PORTD,r20
	call delayslow
	ret
LightRedQuick:
	ldi r20,0b00000100 ; Liga vermelho
	out PORTD,r20
	call delayquick
	ldi r20,0 ; Desliga
	out PORTD,r20
	call delayquick
	ret
SucessiveRedQuick:
	call LightRedQuick
	call delayquick
	call LightRedQuick
	call delayquick
	call LightRedQuick
	call delayquick
	call LightRedQuick
	ret
LightGreenQuick:
	ldi r20,0b00001000 ; Liga verde
	out PORTD,r20
	call delayquick
	ldi r20,0 ; Desliga
	out PORTD,r20
	call delayquick
	ret
SucessiveGreenQuick:
	call LightGreenQuick
	call delayquick
	call LightGreenQuick
	call delayquick
	call LightGreenQuick
	call delayquick
	call LightGreenQuick
	ret
LightBlueQuick:
	ldi r20,0b00010000 ; Liga azul
	out PORTD,r20
	call delayslow
	ldi r20,0 ; Desliga
	out PORTD,r20
	call delayslow
	ret




CounterStart:
	;Counter for the cycle
	ldi r20,0b11111111
	ldi r21,0b11111111
	sts OCR1AH,r20
	sts OCR1AL,r21
	ret
DeuCerto:
	call SucessiveGreenQuick
	clr r20 ; Seta o contador pra 0 pra n ocorrer interrupção
	sts TCNT1H,r20
	sts TCNT1L,r20
	ret
DeuErrado:
	call SucessiveRedQuick
	clr r20 ; Seta o contador pra 0 pra n ocorrer interrupção
	sts TCNT1H,r20
	sts TCNT1L,r20
	ret
setup:
	ldi r20,0b00011100; 3 saidas
	out DDRD,r20
	ldi r20,0b11100000
	out PORTD,r20
	sei ; Enable global interruption
	ldi r20,0b00000010
	sts TIMSK1,r20; Enable timer match A interrupt
	ldi r20,0b00000000 ;  OCR0A does nothing  and set mode normal
	sts TCCR1A, r20
	ldi r20, 0b00001101 ; Set clk select to clkIO/1024
	sts TCCR1B,r20

	ldi bankflag,0
	ldi SoUmNumero, 32
FourSeconds:
	;If counter is at 4 sec, jmp to begin 
	in r20,PIND
	mov r23,r20
	com r23
	lsr r23
	lsr r23
	lsr r23
	out PORTD,r23
	call delaymed
	clr r23
	out PORTD,r23
	call delaymed
	;Liga O led que foi apertadO
	ldi r21, 0b11100000
	and r20,r21
	cpse r20,SoUmNumero ; Skip if equal
	jmp secondbutton
	inc bankflag
	

secondbutton:
	ldi SoUmNumero,64
	;If counter is at 4 sec, jmp to begin 
	in r20,PIND
	mov r23,r20
	com r23
	lsr r23
	lsr r23
	lsr r23
	out PORTD,r23
	call delaymed
	clr r23
	out PORTD,r23
	call delaymed
	;Liga O led que foi apertadO
	ldi r21, 0b11100000
	and r20,r21
	cpse r20,SoUmNumero ; Skip if equal
	jmp thirdbutton
	inc bankflag
thirdbutton:
	ldi SoUmNumero,32
	;If counter is at 4 sec, jmp to begin 
	in r20,PIND
	mov r23,r20
	com r23
	lsr r23
	lsr r23
	lsr r23
	out PORTD,r23
	call delaymed
	clr r23
	out PORTD,r23
	call delaymed
	;Liga O led que foi apertadO
	ldi r21, 0b11100000
	and r20,r21
	cpse r20,SoUmNumero ; Skip if equal
	jmp fourthbutton
	inc bankflag
fourthbutton:
	ldi SoUmNumero,128
	;If counter is at 4 sec, jmp to begin 
	in r20,PIND
	mov r23,r20
	com r23
	lsr r23
	lsr r23
	lsr r23
	out PORTD,r23
	call delaymed
	clr r23
	out PORTD,r23
	call delaymed
	;Liga O led que foi apertadO
	ldi r21, 0b11100000
	and r20,r21
	cpse r20,SoUmNumero ; Skip if equal
	jmp verify
	inc bankflag

verify:
	jmp FourSeconds


CounterInterruption:
	;cpse IntrrptFlag,r22; Se for 0 ele skip. Else jump
	call SucessiveRedQuick
	clr r20
	sts TCNT1H,r20
	sts TCNT1L,r20
	ldi Counterflag,0b11111111
	reti


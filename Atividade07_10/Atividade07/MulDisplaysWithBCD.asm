.include "m328pdef.inc"
.org 0x0000
rjmp setup ; salte para init:
.org 0x0016
rjmp Interruption

;BIN BCD-------------------
;Using registers from r16 to r20. Coloca o valor em r16 e vai sair em 
;r20(unidade), ,r21(dezena),r22(centena)
BCDsetup:
	ldi r16,55 ; Number to enter bcd conversion
	ldi r17,100 ; Maior ordem do numero
	ldi r18,0 ; Saida BCD pra cada dezena, unidade
	ldi r19,0b00000100; Second bit set means its subtracting from 10
SubLoop:
	sub r16,r17
	cpi r16,0
	brge Contmaismais; jump if r16 >= 0. Therefore, sub again
	ChangeR17:
	add r16,r17
	sbrs r19,2
	jmp Finish;Essa parte de baixo apenas se tiver centena
	ldi r19,0b00000010
	ldi r17,10
	mov r22,r18
	ldi r18,0
	jmp SubLoop
Contmaismais:
	inc r18
	jmp SubLoop
Finish:
	mov r21,r18
	mov r20,r16
	ret
;End of BCD--------------------------


;7Seg------------------------------
DisplayOut:
cpi r19,9 ; Antes dessa função, faça r19 receber o regis necessário
brsh Load9
cpi r19,8
brsh Load8
cpi r19,7
brsh Load7
cpi r19,6
brsh Load6
cpi r19,5
brsh Load5
cpi r19,4
brsh Load4
cpi r19,3
brsh Load3
cpi r19,2
brsh Load2
cpi r19,1
brsh Load1
Load0:
ldi r19,0b00111111
ret
Load1:
ldi r19,0b00000110
ret
Load2:
ldi r19,0b01011011
ret
Load3:
ldi r19,0b01001111
ret
Load4:
ldi r19,0b01100110
ret
Load5:
ldi r19,0b01101101
ret
Load6:
ldi r19,0b01111101
ret
Load7:
ldi r19,0b00000111
ret
Load8:
ldi r19,0b01111111
ret
Load9:
ldi r19,0b01101111
ret
;7Seg-----------------------------


ShiftRight:
lsr r19
lsr r19
lsr r19
lsr r19
lsr r19
lsr r19
ret
delay:
	sbrs r22,0 ; Skip if bit 0 in r22 is set
	jmp delay
	ldi r22,0
	ret
setup:
	ldi r20,0b11111100
	out DDRD,r20
	ldi r20,0b11111111
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
	call BCDsetup;r20 e r21 estão ocupados

	;Display 2 - Dezenas
	sbi PORTB,2
	cbi PORTB,0
	mov r19,r21
	call DisplayOut ; Aqui sai o numero em formato do display
	mov r18,r19
	lsl r18
	lsl r18
	out PORTD,r18

	;Apenas pro bit g do display
	call ShiftRight
	ldi r17,1; mascara pra pegar o bit 0 apenas
	and r19,r17
	in r16,PORTB
	or r16,r19
	out PORTB,r16
	call delay
	cbi PORTB,2

	;Display 1 - Unidades
	sbi PORTB,1
	cbi PORTB,0
	mov r19,r20
	call DisplayOut ; Aqui sai o numero em formato do display
	mov r18,r19
	lsl r18
	lsl r18
	out PORTD,r18

	;Apenas pro bit g do display
	call ShiftRight
	ldi r17,1; mascara pra pegar o bit 0 apenas
	and r19,r17
	in r16,PORTB
	or r16,r19
	out PORTB,r16
	call delay
	cbi PORTB,1

	jmp LightingUp

Interruption:
	ldi r22,0b00000001 ; Seta o bit 0 pra sair do delay
	reti


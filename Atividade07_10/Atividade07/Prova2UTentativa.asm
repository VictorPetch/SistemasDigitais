.include "m328pdef.inc"
.org 0x0000
rjmp ValoresIniciais
.org 0x0016
rjmp Interruption
.def ViL = r17
;.def ViH = r17
.def c0 = r18
.def c1 = r19
.def c2 = r23
.def c3 = r24
.def c4 = r25
.def temp = r16

;r20 ate r21 são para BCD
;r10 ate r15 são pra guardar valores finais depois do BCD
;de cada tipo de moeda
delay:
	clr r20 ; defina r17 para 0
	clr r21 ; defina r18 para 0
	ldi r22, 60 ; defina r19 para 10
delay_loop:
	dec r21 ; decremente r18
	brne delay_loop ; salte para delay_loop se r18 n~ao ´e 0
	dec r20 ; decremente r17
	brne delay_loop ; salte para delay_loop se r17 n~ao ´e 0
	dec r22 ; decrament r19
	brne delay_loop ; salte para delay_loop se r19 n~ao ´e 0
	ret ; retorne
adcInitA0:
	ldi r16,0b01100000 ; bit 3-0 to ADC0	    
	sts ADMUX,r16
	ldi r16,0b10000111 ; 
	sts ADCSRA,r16
	ret
adcInitA1:
	ldi r16,0b01100001 ; bit 3-0 to ADC0	    
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

Subc5:
mov r30,Vil
mov r28,r26
cpse r28,temp; skip if n tem moeda nesse cofre
jmp loop5
ret
	loop5:
		subi r30,100 ; Vil - Moeda_i
		cpi r30,0
		brge Contmenosmenos5; if r30 >= 0, jump
		jmp Return5; if deu negativo: soma de novo e sai do loop
		jmp loop5
		Contmenosmenos5:
			dec r28
			cpi r28,0; if deu maior que zero, volta pro loop
			breq Return5b; Se deu igual a zero, vai pra return
			jmp loop5
		Return5:
			ldi r29,100
			add r30,r29
		Return5b:
			cpse r26,r28
			sub r26,r28
			ret
Subc4:
mov r28,c4
cpse r28,temp; skip if n tem moeda nesse cofre
jmp loop4
ret
	loop4:
		subi r30,50 ; Vil - Moeda_i
		cpi r30,0
		brge Contmenosmenos4; if r30 >= 0, jump
		jmp Return4; if deu negativo: soma de novo e sai do loop
		jmp loop4
		Contmenosmenos4:
			dec r28
			cpi r28,0; if deu maior que zero, volta pro loop
			breq Return4b; Se deu igual a zero, vai pra return
			jmp loop4
		Return4:
			ldi r29,50
			add r30,r29
		Return4b:
			cpse c4,r28
			sub c4,r28
			ret
Subc3:
mov r28,c3
cpse r28,temp; skip if n tem moeda nesse cofre
jmp loop3
ret
	loop3:
		subi r30,25 ; Vil - Moeda_i
		cpi r30,0
		brge Contmenosmenos3; if r30 >= 0, jump
		jmp Return3; if deu negativo: soma de novo e sai do loop
		jmp loop3
		Contmenosmenos3:
			dec r28
			cpi r28,0; if deu maior que zero, volta pro loop
			breq Return3b; Se deu igual a zero, vai pra return
			jmp loop3
		Return3:
			ldi r29,25
			add r30,r29
		Return3b:
			cpse c3,r28
			sub c3,r28
			ret
Subc2:
mov r28,c2
cpse r28,temp; skip if n tem moeda nesse cofre
jmp loop2
ret
	loop2:
		subi r30,10 ; Vil - Moeda_i
		cpi r30,0
		brge Contmenosmenos2; if r30 >= 0, jump
		jmp Return2; if deu negativo: soma de novo e sai do loop
		jmp loop2
		Contmenosmenos2:
			dec r28
			cpi r28,0; if deu maior que zero, volta pro loop
			breq Return2b; Se deu igual a zero, vai pra return
			jmp loop2
		Return2:
			ldi r29,10
			add r30,r29
		Return2b:
			cpse c2,r28
			sub c2,r28
			ret
Subc1:
mov r28,c1
cpse r28,temp; skip if n tem moeda nesse cofre
jmp loop1
ret
	loop1:
		subi r30,5 ; Vil - Moeda_i
		cpi r30,0
		brge Contmenosmenos1; if r30 >= 0, jump
		jmp Return1; if deu negativo: soma de novo e sai do loop
		jmp loop1
		Contmenosmenos1:
			dec r28
			cpi r28,0; if deu maior que zero, volta pro loop
			breq Return1b; Se deu igual a zero, vai pra return
			jmp loop1
		Return1:
			ldi r29,5
			add r30,r29
		Return1b:
			cpse c1,r28
			sub c0,r28
			ret
Subc0:
mov r28,c0
cpse r28,temp; skip if n tem moeda nesse cofre
jmp loop0
ret
	loop0:
		subi r30,1 ; Vil - Moeda_i
		cpi r30,0
		brge Contmenosmenos0; if r30 >= 0, jump
		jmp Return0; if deu negativo: soma de novo e sai do loop
		jmp loop0
		Contmenosmenos0:
			dec r28
			cpi r28,0; if deu maior que zero, volta pro loop
			breq Return0b; Se deu igual a zero, vai pra return
			jmp loop0
		Return0:
			ldi r29,1
			add r30,r29
		Return0b:
			cpse c0,r28
			sub c0,r28
			ret

;--------------------------DISPLAY----------------------------------
BCDsetup:
	ldi r17,100 ; Maior ordem do numero
	ldi r18,0 ; Saida BCD pra cada dezena, unidade
	ldi r19,0b00000100; Second bit set means its subtracting from 10
SubLoop:
	sub r31,r17
	cpi r31,0
	brge Contmaismais; jump if r16 >= 0. Therefore, sub again
	ChangeR17:
	add r31,r17
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
	mov r20,r31
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
delayBCD:
	sbrs r22,0 ; Skip if bit 0 in r22 is set
	jmp delayBCD
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
	ldi r31,72
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
	call delayBCD
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
	call delayBCD
	cbi PORTB,1

	jmp LightingUp

Interruption:
	ldi r22,0b00000001 ; Seta o bit 0 pra sair do delay
	reti
;--------------------------DISPLAY----------------------------------



;----------------------------MAiN-----------------------------------
ValoresIniciais:
ldi r16,0
ldi ViL, 151
ldi c0,1
ldi c1,0
ldi c2,0
ldi c3,0
ldi c4,7
ldi r26,0; c5 eh r26



;r9 para fazer o loop
Subtracao:
call Subc5; 100
call Subc4; 50
call Subc3; 25
call Subc2; 10
call Subc1; 5
call Subc0; 1

;pegar o r30 e ver se deu 0
cpse r30,temp
jmp Fail
jmp Sucess

Fail:
jmp Fail

Sucess:
call Display0

call adcInitA0 ; LSB
call adcRead
call adcWait
lds r16,ADCH ; Recebe 8 valores
cpi r16,240 ; if A0 > 240, jmp to Display1 
brsh Display1; else volta

call adcInitA1 
call adcRead
call adcWait
lds r16,ADCH 
cpi r16,240 ; if A1 > 240, jmp to Display5
brsh Jumpgrande		
jmp Sucess
JumpGrande:
jmp Display5

Display0:
ldi r31,10
call setup

ret

Display1:

mov r16,c1
call setup

call adcInitA0 ; LSB
call adcRead
call adcWait
lds r16,ADCH ; Recebe 8 valores
cpi r16,240 ; if A0 > 240, jmp to Display1 
brsh Display2; else volta

call adcInitA1 
call adcRead
call adcWait
lds r16,ADCH 
cpi r16,240 ; if A1 > 240, jmp to Display5
brsh Display0
	
jmp Display1

Display2:
mov r16,c2
call setup

ldi r16,0
out PORTB,r16
call adcInitA0 ; LSB
call adcRead
call adcWait
lds r16,ADCH ; Recebe 8 valores
cpi r16,240 ; if A0 > 240, jmp to Display1 
brsh Display3; else volta

call adcInitA1 
call adcRead
call adcWait
lds r16,ADCH 
cpi r16,240 ; if A1 > 240, jmp to Display5
brsh Display1

jmp Display2

Display3:
mov r16,c3
call setup

call delay

call adcInitA0 ; LSB
call adcRead
call adcWait
lds r16,ADCH ; Recebe 8 valores
cpi r16,240 ; if A0 > 240, jmp to Display1 
brsh Display4; else volta

call adcInitA1 
call adcRead
call adcWait
lds r16,ADCH 
cpi r16,240 ; if A1 > 240, jmp to Display5
brsh Display2

jmp Display3

Display4:
mov r16,c4
call setup

call delay

call adcInitA0 ; LSB
call adcRead
call adcWait
lds r16,ADCH ; Recebe 8 valores
cpi r16,240 ; if A0 > 240, jmp to Display1 
brsh Display5; else volta

call adcInitA1 
call adcRead
call adcWait
lds r16,ADCH 
cpi r16,240 ; if A1 > 240, jmp to Display5
brsh Display3

jmp Display4

Display5:
mov r16,r26
call setup

call delay

call adcInitA0 ; LSB
call adcRead
call adcWait
lds r16,ADCH ; Recebe 8 valores
cpi r16,240 ; if A0 > 240, jmp to Display1 
brsh JumpGrande2; else volta

call adcInitA1 
call adcRead
call adcWait
lds r16,ADCH 
cpi r16,240 ; if A1 > 240, jmp to Display5
brsh Display4

jmp Display5
JumpGrande2:
jmp Display0
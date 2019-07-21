.include "m328pdef.inc"
.org 0x0000
rjmp BCDsetup 
;Using registers from r16 to r20. Coloca o valor em r16 e vai sair em 
;r20(unidade), ,r21(dezena),r22(centena)
BCDsetup:
	;ldi r16,163 ; Number to enter bcd conversion
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



	ldi r16,255
	out DDRD,r16
	out DDRB,r16
	out PORTD,r21
	out PORTB,r22
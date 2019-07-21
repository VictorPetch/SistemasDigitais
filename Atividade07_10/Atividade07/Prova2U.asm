.include "m328pdef.inc"
.org 0x0000
rjmp ValoresIniciais
.def ViL = r17
;.def ViH = r17
.def c0 = r18
.def c1 = r19
.def c2 = r23
.def c3 = r24
.def c4 = r25
.def temp = r16
;r16 ate r26 não podem ser alterados
;r20 ate r22 são para BCD
;r10 ate r15 são pra guardar valores finais depois do BCD
;de cada tipo de moeda




ValoresIniciais:
ldi r16,0
ldi ViL, 149
ldi c0,10
ldi c1,5
ldi c2,8
ldi c3,14
ldi c4,3

;r9 para fazer o loop
Subtracao:
	;Pra ver se tem moeda
;c5 eh r26
mov r30,Vil
cpse r26,temp; skip if n tem moeda nesse cofre
jmp loop1
ret
	loop1:
		subi r30,100 ; Vil - Moeda_i
		cpi r30,0
		brlt Return; if deu negativo: soma de novo e sai do loop
		dec r26;else cont--
		cpi r26,0; if deu negativo, n tem mais como tirar moeda
		brlt Return
		jmp loop1
		Return:
			ldi r29,100
			add r30,r29
			ret
	seila:
	jmp seila
;call Subc4
;call Subc3
;;call Subc2
;call Subc1
;call Subc0
;Subtrair por 0.5 c4 vezes
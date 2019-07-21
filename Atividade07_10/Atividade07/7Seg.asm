.include "m328pdef.inc"
.org 0x0000
rjmp Displayout
 
DisplayOut:
ldi r19,6
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
ldi r19,0b1111110
Load1:
ldi r19,0b0000110
Load2:
ldi r19,0b1101101
Load3:
ldi r19,0b1001111
Load4:
ldi r19,0b0110011
Load5:
ldi r19,0b1011011
Load6:
ldi r19,0b1011111
Load7:
ldi r19,0b1110000
Load8:
ldi r19,0b1111111
Load9:
ldi r19,0b1111011
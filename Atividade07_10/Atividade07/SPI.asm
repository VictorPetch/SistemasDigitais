.include "m328Pdef.inc"
.org 0x0000 
jmp SPI_MasterInit

Wait_Transmit:
    ; Wait for transmission complete
    in r16, SPSR
    sbrs r16, SPIF
    rjmp Wait_Transmit
    
    ldi r16,0b00000000
    out PORTD,r16    


SPI_MasterInit:
    ; Set MOSI and SCK output, all others input
    ldi r17,00101000
    out DDRB,r17
    ; Enable SPI, Master, set clock rate fck/16
    ldi r17,0b01010001
    out SPCR,r17
    ldi r16,0b11111111
    out DDRD,r16
    ;sbi DDRD, 7
    ;sbi DDRD, 6
    ;sbi DDRD, 5


main:

    
    ldi r16,0b11111111
    out PORTD,r16

    ;call delay

    ldi r16, 0b10101010
    out SPDR,r16
    ;rjmp Wait_Transmit

    ldi r16,0b00000000
    out PORTD,r16
    call delay

    rjmp main

delay:
 clr r20
 clr r21
 ldi R22,100

 delayloop:
  dec r20
  brne delayloop
  dec r21
  brne delayloop
  dec R22
  brne delayloop
  ret
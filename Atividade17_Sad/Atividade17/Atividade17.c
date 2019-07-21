/*
 * Atividade17.c
 *
 * Created: 28/05/2019 09:21:23
 * Author : Victor
 */ 

#include <avr/io.h>
#define F_CPU 16000000UL
#include <util/delay.h>
#include "Atividade17.h"

int main(void)
{
	// set all PORTD,and some PORTB pins for output. Also PORTB2 for input
	DDRD = 0xFF;
	DDRB = 0xFF;
	DDRB &= ~(1 << DDB2);

	// clear everything and pull up for DDB2
	PORTD = 0x00;
	PORTB =  (1 << PORTB2);
	ADC_init();
	volatile int S;
	
	while (1)
	{
		 
		uint8_t j = PINB;
		j &= 0b00000100;
		if (j==0b00000100 ){ // if PORTB2 receber sinal
			
			S = 0;
			for (uint8_t i =0; i < 199; i++){			
				int A_0 = ADC_Conversion(0);
				int A_1 = ADC_Conversion(1);
				if (A_1 > A_0){
					S += (A_1 - A_0);
				}
				else {
					S+= (A_0 - A_1);
				}
						
			}
			S /=255;
			PORTD = (S & 0b0000000000111111)<<2 ; // SHIFT RIGHT Two bits to start from port 2
			PORTB = (S & 0b0000000011000000)>>6;
		}
		else {
			PORTB = 0x00;
			PORTD = 0X00;
		}
		
	}
	return 0;
}


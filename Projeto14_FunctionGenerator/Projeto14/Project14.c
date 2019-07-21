/*
 * Projeto14.c
 *
 * Created: 21/05/2019 10:20:30
 * Author : Victor
 */ 

#include <avr/io.h>
#define F_CPU 16000000
#include <util/delay.h>
#include "Project14.h"

int main(void)
{
	// set all PORTD PORTB pins for output
	DDRD = 0xFF;
	DDRB = (1 << DDB0) | (1 << DDB1);
	// clear everything
	PORTD = 0x00;
	PORTB = (0 << PORTB0) | (0 << PORTB1);
	ADC_init();
	volatile double n;
	while(1) {
		if(n > 666) n= 0;
		unsigned char ADC_out;
		ADC_out = ADC_Conversion(1);
		if(ADC_out > 200 ){
			triangular();	
		}
		else{
			ADC_out = ADC_Conversion(0);
			if(ADC_out > 200 ){
				squared();

			}
			else {
				seno();
				
			}
		}
		
	
		
	}
	return 0;
}

